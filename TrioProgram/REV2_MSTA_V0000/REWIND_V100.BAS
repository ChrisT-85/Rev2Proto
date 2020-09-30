'==============================================================================
' Filename: REWIND_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for the Rewind
'==============================================================================


local_max_speed=5000

restart:
VR(alarm).al_filmsnap=0
BASE(ax_rewind)
DAC=0
SERVO=0
DAC AXIS(ax_filmfeedbrake)=0
SERVO AXIS(ax_filmfeedbrake)=0
AXIS_ENABLE=ON 'Enable Drive
AXIS_ENABLE AXIS(ax_filmfeedbrake)=ON 'Enable Drive

start:
'Stall torque
DAC=-VR(rw_stall_torque)
DAC AXIS(ax_filmfeedbrake)=VR(film_brake_max_torque)
WAIT UNTIL MSPEED AXIS(ax_filmfeed)>10000 OR MSPEED>local_max_speed _
    OR MSPEED AXIS(ax_filmfeedbrake)>local_max_speed
IF (MSPEED>local_max_speed) OR (MSPEED AXIS(ax_filmfeedbrake)>local_max_speed) THEN GOTO alarm_out
' Accel Torque
DAC=-VR(rw_acc_torque)
WAIT UNTIL MPOS AXIS(ax_filmfeed)>VR(film_length)*0.5 OR MSPEED>local_max_speed
IF (MSPEED>local_max_speed) OR (MSPEED AXIS(ax_filmfeedbrake)>local_max_speed) THEN GOTO alarm_out
' Run Torque
DAC=-VR(rw_run_torque)
DAC AXIS(ax_filmfeedbrake)=VR(film_brake_min_torque)
WAIT UNTIL IDLE AXIS(ax_filmfeed) OR MSPEED>local_max_speed
IF (MSPEED>local_max_speed) OR (MSPEED AXIS(ax_filmfeedbrake)>local_max_speed) THEN GOTO alarm_out
GOTO start

alarm_out:
DAC=0
DAC AXIS(ax_filmfeedbrake)=0
DRIVE_ENABLE=OFF
VR(alarm).al_filmsnap=1
PRINT #0, "FILM SNAP"
WAIT UNTIL IN(i_reset_pb)
GOTO restart
