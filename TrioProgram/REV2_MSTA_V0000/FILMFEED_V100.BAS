'==============================================================================
' Filename: FILMFEED_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for the film feed (nip roller)


BASE(ax_filmfeed)

IF VR(commands_film).film_print_speed_save THEN
    SRAMP=150
ELSE
    SRAMP=250
ENDIF
CANCEL(2) AXIS(ax_filmfeed)
WA(100)
OP(o_printer_signal,OFF)
local_reg_error_cnt=0
DATUM(7)
AXIS_ENABLE=ON
SERVO=ON
WA(500) 'Wait for rewind

start:
SPEED=VR(film_speed)*1000
ACCEL=VR(film_acc)*1000
DECEL=VR(film_dec)*1000

DEFPOS(0)
IF VR(commands_film).film_on_transfer=0 THEN
    WAIT UNTIL (VR(commands_seal).seal_start=0 AND VR(commands_seal).seal_bypass=0 AND VR(alarm).al_filmsnap=0) _
        OR VR(commands_film).film_start AND VR(commands_mc).batch_end_flag=0
ELSE
    WAIT UNTIL (infeed_pack_count>=n_impressions AND VR(commands_seal).seal_start=0 AND VR(alarm).al_filmsnap=0) _
        OR VR(commands_film).film_start AND VR(commands_mc).batch_end_flag=0
ENDIF

MOVE(VR(film_length)*10)

OP(o_printer_signal,ON)

IF VR(commands_film).film_reg_on THEN
    REGIST(21, 1, 0, 0,0) 'REGIST(21, channel, source, edge, window)
ENDIF
WA(100)
OP(o_printer_signal,OFF)
WAIT UNTIL IDLE OR (R_MARK(1) AND VR(commands_film).film_reg_on)

IF VR(commands_film).film_reg_on THEN
    IF R_MARK(1) THEN
        MOVEMODIFY(R_REGPOS(1)+(VR(film_travel_aft_mark)*10))
        local_reg_error_cnt=0
        VR(alarm).al_reg_film=0 ' Reset Reg film alarm
    ENDIF

    IF IDLE THEN
        local_reg_error_cnt=local_reg_error_cnt+1
        IF local_reg_error_cnt>2 THEN VR(alarm).al_reg_film=1 ' Set Reg film alarm
    ENDIF
ENDIF

WAIT IDLE
WAIT UNTIL VR(commands_seal).seal_start=1 OR VR(commands_film).film_start
VR(commands_film).film_start=0

GOTO start
