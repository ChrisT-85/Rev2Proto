'==============================================================================
' Filename: REWIND_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for the Rewind
'==============================================================================
' alarm        VR0   Bit 3 - AL Film Snap
'                    Bit 5 - Reg Film Error
'film_commands VR21  Bit 0 - start film,
'                    Bit 1 - reg film ON,
'                    Bit 2 - printer SPEED save
' hmi_commands VR159 Bit 3 - Seal Bypass

INCLUDE"INCLUDE_IO"

local_max_speed=5000
restart:
alarm.3=0 'Reset Film Snap Alarm
BASE(3)
DAC=0
SERVO=0
AXIS_ENABLE=ON 'Enable Drive

start:
'Stall torque
DAC=-rw_stall_torque

WAIT UNTIL MSPEED AXIS(4)>10000 OR MSPEED>max_speed
IF MSPEED>max_speed THEN GOTO alarm_out
' Accel Torque
DAC=-rw_acc_torque
WAIT UNTIL MPOS AXIS(4)>film_lenght*0.5 OR MSPEED>max_speed
IF MSPEED>max_speed THEN GOTO alarm_out
' Run Torque
DAC=-rw_run_torque
WAIT UNTIL IDLE AXIS(4) OR MSPEED>max_speed
IF MSPEED>max_speed THEN GOTO alarm_out
GOTO start

alarm_out:
DAC=0
DRIVE_ENABLE=OFF
alarm.3=1
PRINT #0, "FILM SNAP"
WAIT UNTIL IN(i_reset_pb)
GOTO restart
