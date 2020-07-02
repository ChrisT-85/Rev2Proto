'==============================================================================
' Filename: AUTOTENSION_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for the Auto adjustment of the film feed brake
'==============================================================================
'Add to MC_CONFIG
'AXIS_OFFSET SLOT(-1) = 13

BASE(13) ' reel shaft encoder 2048 PPR
ATYPE=76 ' encoder axis
ENCODER_RATIO(-1,1)' change to ENCODER_RATIO(1,1)for opp hand MC

IF min_torque=0 THEN min_torque=20 ' inital value if VR=0
IF max_torque=0 THEN max_torque=90 ' inital value if VR=0
IF min_diameter=0 THEN min_diameter=90 ' inital value if VR=0
IF max_diameter=0 THEN max_diameter=210 ' inital value if VR=0

start:
WAIT UNTIL auto_reel_tension_on=1
local_scale=(max_torque-min_torque)/(max_diameter-min_diameter)

BASE(4) ' Film Feed Servo
WAIT UNTIL NOT IDLE
DEFPOS(0) AXIS(13)' zero encoder axis
WAIT IDLE
WA(50)

BASE(13)' reel shaft encoder
local_film_length_mm= film_length/12.829
local_rotation=MPOS/2048

IF (local_rotation=0) THEN local_rotation=0.1
diameter=local_film_length_mm/(3.1415*local_rotation)
local_torque=(diameter-min_diameter)*local_scale+min_torque

IF (local_torque>max_torque) THEN local_torque=max_torque
IF (local_torque<min_torque) THEN local_torque=min_torque
reel_brake_force=local_torque

BASE(16)' Brake Axis
PSWITCH(0,ON,16,11,ON,0,reel_brake_force) 'PSWITCH(switch, enable [,axis, output, state, setpos, resetpos])
GOTO start
