'==============================================================================
' Filename: FILMFEED_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for the film feed (nip roller)
'==============================================================================
' alarm        VR0   Bit 3 - AL Film Snap
'                    Bit 5 - Reg Film Error
'film_commands VR21  Bit 0 - start film,
'                    Bit 1 - reg film ON,
'                    Bit 2 - printer SPEED save
' hmi_commands VR159 Bit 3 - Seal Bypass

INCLUDE"INCLUDE_IO"

BASE(4)'film feed servo

IF film_commands.2 THEN ' Printer speed save
    SRAMP AXIS(4)=150
ELSE
    SRAMP AXIS(4)=250
ENDIF
CANCEL(2) AXIS(4)
WA(100)
OP(o_printer_signal,OFF)
local_reg_error_cnt=0
DATUM(7) AXIS(4)
AXIS_ENABLE AXIS(4)=ON
SERVO AXIS(4)=ON
WA(500) 'Wait for rewind

start:
SPEED AXIS(4)=film_speed*1000
ACCEL AXIS(4)=film_acc*1000
DECEL AXIS(4)=film_dec*1000

DEFPOS(0) AXIS(4)
IF film_on_transfer=0 THEN
    WAIT UNTIL (seal_start=0 AND hmi_commands.3=0 AND alarm.3=0) _
        OR film_commands.0 AND batch_end_flag=0
ELSE
    WAIT UNTIL (infeed_pack_count>=n_impressions AND seal_start=0 AND hmi_commands.3=0) _
        OR film_commands.0 AND batch_end_flag=0
ENDIF

MOVE(film_length*10) AXIS(4)

OP(o_printer_signal,ON)

IF film_commands.1 THEN ' If Registered film
    REGIST(21, 1, 0, 0,0) 'REGIST(21, channel, source, edge, window)
ENDIF
WA(100)
OP(o_printer_signal,OFF)
WAIT UNTIL IDLE AXIS(4) OR (R_MARK(1) AND film_commands.1)

IF film_commands.1 THEN
    IF R_MARK(1) THEN
        MOVEMODIFY(R_REGPOS(1)+film_travel_aft_mark*10) AXIS(4)
        local_reg_error_cnt=0
        alarm.5=0 ' Reset Reg film alarm
    ENDIF

    IF IDLE THEN
        local_reg_error_cnt=local_reg_error_cnt+1
        IF local_reg_error_cnt>2 THEN alarm.5=1 ' Set Reg film alarm
    ENDIF
ENDIF

WAIT IDLE AXIS(4)
WAIT UNTIL seal_start=1 OR film_commands.0
film_commands.0=0

GOTO start
