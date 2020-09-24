'==============================================================================
' Filename: MAIN_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for homing and program start/stop
'==============================================================================

OP(8,31,OFF) 'RESET Outputs
DISABLE_GROUP(-1)' Clear all groups
DATUM(0)
DISABLE_GROUP(ax_filmfeed,ax_rewind,ax_filmfeedbrake)
DISABLE_GROUP(ax_transfer,ax_oc,ax_seal,ax_outfeed)

VR(infeed_acc)=3000000
VR(infeed_dec)=3000000
VR(oc_open_pos)=0

RUN"HMI_V100",proc_hmi
'RUN"ANALOGUE",3
'RUN"GENERATE_DATA",proc_gen_data


VR(seal_torque_rms)=0
VR(commands_trans).trans_not_ready=0
VR(infeed_pack_count)=0
VR(alarm)=0
VR(alarm_max_torque)=0
VR(commands_film).film_start=0
VR(hmi_commands)=0
VR(ppm)=0
'data_machine_status=-1
VR(seal_pause)=0
VR(seal_crush_count)=0
VR(commands_mc).mc_running=0
OP(o_magnets_ssr,OFF) 'Magnets SSR OFF

'Virtual infeed axis
BASE(ax_virtual_infeed)
UNITS=100
ACCEL=60000
ATYPE=0
CREEP=1
DATUM_IN=0
DECEL=40000
D_GAIN=0
FE_LIMIT=200
FHOLD_IN=-1
FS_LIMIT=4000000000
FWD_IN=-1
I_GAIN=0
JOGSPEED=1
OV_GAIN=0
P_GAIN=1
REP_DIST=2000000000
REV_IN=-1
RS_LIMIT=-4000000000
SERVO=0
SPEED=35000
SRAMP=249
VFF_GAIN=0

'Infeed  109.5/mm ' chnage to 97.8/mm
BASE(ax_infeed)
UNITS=100
DATUM_IN=-1
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=2000
REP_DIST=2000000000
DAC=0
SERVO=OFF
DAC_SCALE = 1
ENCODER_RATIO(1,1)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0
ACCEL=400000 '8500000
DECEL=400000 '8500000
SRAMP=150
SPEED=30000
SRAMP=150
ADDAX(ax_virtual_infeed)

'Stepper  109.5/mm ' change to 97.8/mm
BASE(ax_stepper)
UNITS=100
DATUM_IN=-1
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=5000
REP_DIST=2000000000
DAC=0
SERVO=OFF
DAC_SCALE = 1
ENCODER_RATIO(1,1)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0
CREEP=600
ACCEL=6000000
DECEL=5000000
SPEED=20000
SRAMP=150

'Transfer 109.5/mm
BASE(ax_transfer)
UNITS=100
DATUM_IN=2
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=10.0
I_GAIN=0
D_GAIN=0
VFF_GAIN=15.0
OV_GAIN=0
FE_LIMIT=15000
REP_DIST=2000000000
DAC=0
SERVO=OFF
DAC_SCALE = -1
ENCODER_RATIO(9780,4097) ' was (10950,4097)
STEP_RATIO(4097,9780) ' was (4097,10950)
CLUTCH_RATE=2
SYNC(4,0)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0

'Rewind
BASE(ax_rewind)
UNITS=100
DATUM_IN=-1
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=200
REP_DIST=2000000000
DAC=0
SERVO=OFF
DRIVE_ENABLE=OFF
DAC_SCALE = -1
ENCODER_RATIO(-1,1)
STEP_RATIO(-1,1)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0

'FilmFeed 128.2/mm
BASE(ax_filmfeed)
UNITS=100
DATUM_IN=-1
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=50000
REP_DIST=2000000000
FS_LIMIT=4000000
RS_LIMIT=-4000000000
ACCEL=300000
DECEL=200000
CREEP=1
SPEED=150000
SRAMP=150
DAC=0
SERVO=OFF
DAC_SCALE = -1
ENCODER_RATIO(-9780,8023) ' ENCODER_RATIO(-12820,8023)
STEP_RATIO(-8023,9780) 'STEP_RATIO(-8023,12820)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0

'Jaws  43.33333/mm
BASE(ax_oc)
UNITS=150
DATUM_IN=4
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=3000
REP_DIST=2000000000
FS_LIMIT=6600
RS_LIMIT=-200
ACCEL=1500000
DECEL=800000
CREEP=100
SPEED=800000
SRAMP=120
DAC=0
SERVO=OFF
DAC_SCALE = -1
ENCODER_RATIO(-1,1)
STEP_RATIO(-1,1)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0

'Seal  264/mm
BASE(ax_seal)
UNITS=100
DATUM_IN=3
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=5000
REP_DIST=2000000000
FS_LIMIT=40000
RS_LIMIT=-640
ACCEL=1300000
DECEL=700000
CREEP=300
SPEED=150000
SRAMP=100
DAC=0
SERVO=OFF
DAC_SCALE = 1
ENCODER_RATIO(-1,1)
STEP_RATIO(-1,1)
SPEED=200
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0

'Outfeed  109.5/mm
BASE(ax_outfeed)
UNITS=100
DATUM_IN=-1
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=2000
REP_DIST=2000000000
FS_LIMIT=4000000000
RS_LIMIT=-4000000000
ACCEL=50000
DECEL=350000
CREEP=1
SPEED=30000
SRAMP=200
DAC=0
SERVO=OFF
DAC_SCALE = -1
FE_LIMIT=10000
ENCODER_RATIO(-1,1)
STEP_RATIO(-1,1)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0


'Film Feed Servo Brake
BASE(ax_filmfeedbrake)
UNITS=100
DATUM_IN=-1
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=200
FS_LIMIT=4000000000
RS_LIMIT=-4000000000
REP_DIST=2000000000
ACCEL=100
DECEL=100
DAC=0
SERVO=OFF
DRIVE_ENABLE=OFF
DAC_SCALE = -1
ENCODER_RATIO(-1,1)
STEP_RATIO(-1,1)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0

'Virtual infeed axis
BASE(ax_virtual_infeed)
ATYPE=0
UNITS=100
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=200
FS_LIMIT=4000000000
RS_LIMIT=-4000000000
REP_DIST=2000000000
ACCEL=VR(infeed_acc) ' was 60000
DECEL=VR(infeed_dec) ' was 40000
CREEP=1
SPEED=VR(infeed_speed)*10
SRAMP=200
SERVO=OFF
DATUM(0)
WA(100)
DEFPOS(0)
WAIT UNTIL OFFPOS=0


restart_datum:
WDOG=OFF

RAPIDSTOP(2)
WA(500)

WAIT UNTIL IN(i_safety_general)=0
WA(100)

REPEAT
    OP(o_flashing_reset,ON)
    WA(300)
    OP(o_flashing_reset,OFF)
    WA(300)
UNTIL IN(i_safety_infeed)=1 AND IN(i_safety_general)=1 'Wait for safety

OP(o_stop_pb_led,ON)

WA(3000)
DATUM(0)
WA(100)
WDOG=ON
AXIS_ENABLE AXIS(0)=ON
AXIS_ENABLE AXIS(1)=ON
AXIS_ENABLE AXIS(2)=ON
AXIS_ENABLE AXIS(3)=OFF
AXIS_ENABLE AXIS(4)=ON
AXIS_ENABLE AXIS(5)=ON
AXIS_ENABLE AXIS(6)=ON
AXIS_ENABLE AXIS(7)=ON
AXIS_ENABLE AXIS(8)=OFF
WA(1000)

SERVO AXIS(0)=ON
SERVO AXIS(1)=ON
SERVO AXIS(2)=ON
SERVO AXIS(3)=OFF
SERVO AXIS(4)=ON
SERVO AXIS(5)=ON
SERVO AXIS(6)=ON
SERVO AXIS(7)=ON
SERVO AXIS(8)=OFF

WA(100)

BASE(ax_filmfeed) 'Filmfeed
SPEED=VR(film_speed)*1000
ACCEL=VR(film_acc)*1000
DECEL=VR(film_dec)*1000
SRAMP=200
FE_LIMIT=20000

BASE(ax_oc) ' Jaws
RS_LIMIT=-7000
FS_LIMIT=7000
FE_LIMIT=6000
CREEP=100
SPEED=1000
ACCEL=10000
DECEL=40000
SRAMP=150
DATUM(4)
WAIT LOADED

REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(5) OR DRIVE_TORQUE AXIS(5)>1200 THEN
        PRINT #0, "Overtorque on Home Ret AX 5: ";DRIVE_TORQUE AXIS(5)
        VR(alarm_max_torque).ax_oc=1
        GOTO restart_datum
    ENDIF
UNTIL NOT IDLE

REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(5) OR DRIVE_TORQUE AXIS(5)>1200 THEN
        PRINT #0, "Overtorque on Home Ret AX 5: ";DRIVE_TORQUE AXIS(5)
        VR(alarm_max_torque).ax_oc=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

MOVEABS(0)
'52mm from the outside frame
RS_LIMIT=-200
FS_LIMIT=4925
FE_LIMIT=3000
ACCEL=VR(oc_acc)*1000
DECEL=VR(oc_dec)*1000
SPEED=VR(oc_speed)*1000
SRAMP=VR(oc_sshape)
WAIT IDLE

BASE(2) 'Transfer
RS_LIMIT= -330100
FS_LIMIT=278000
FE_LIMIT=12000
CREEP=200
SPEED=3000
ACCEL=10000
DECEL=10000
SRAMP=130
DATUM(4)
WAIT LOADED

REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(2) OR DRIVE_TORQUE AXIS(2)>1200 THEN
        PRINT #0, "Overtorque on Home Ret AX 2: ";DRIVE_TORQUE AXIS(2)
        VR(alarm_max_torque).ax_transfer=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

'MOVEABS(85*128.2) 'Eclipse X
MOVEABS(0) ' Revolution

WAIT LOADED
REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(2) OR DRIVE_TORQUE AXIS(2)>1200 THEN
        PRINT #0, "Overtorque on Home Ret AX 2: ";DRIVE_TORQUE AXIS(2)
        VR(alarm_max_torque).ax_transfer=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE
DEFPOS(0)
WAIT UNTIL OFFPOS=0
RS_LIMIT=-1280
FS_LIMIT=328200
FE_LIMIT=15000
ACCEL=VR(trf_acc)*500
DECEL=VR(trf_dec)*500
SPEED=VR(trf_speed)*500
SRAMP=140
WAIT IDLE

BASE(6) 'Seal
RS_LIMIT= -42500
FS_LIMIT=47000
FE_LIMIT=2500
CREEP=300
SPEED=2000
ACCEL=3000
DECEL=3000
SRAMP=150
MOVE (VR(seal_home_offset))
REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(6) OR DRIVE_TORQUE AXIS(6)> 1200 THEN
        PRINT #0, "Overtorque on home Ret AX 6: ";-DRIVE_TORQUE AXIS(6)
        VR(alarm_max_torque).ax_seal=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

DATUM(4)
WAIT LOADED

REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(6) OR DRIVE_TORQUE AXIS(6)> 1200 THEN
        PRINT #0, "Overtorque on home Ret AX 6: ";-DRIVE_TORQUE AXIS(6)
        VR(alarm_max_torque).ax_seal=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

MOVEABS(-VR(seal_home_offset)*10)

REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(6) OR DRIVE_TORQUE AXIS(6)> 1200 THEN
        PRINT #0, "Overtorque on home Ret AX 6: ";-DRIVE_TORQUE AXIS(6)
        VR(alarm_max_torque).ax_seal=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

DEFPOS(0)
RS_LIMIT=-640
FS_LIMIT=47000
FE_LIMIT=7000

SPEED=(VR(seal_speed)*1000)
ACCEL=(VR(seal_acc)*1000)
DECEL=(VR(seal_dec)*1000)
SRAMP=100

MOVEABS(0)
WAIT IDLE

RUN "MAX_TORQUES_V100",4
'
restart:
PRINT #0, "Restart Jump point"

IF VR(commands_hmi).hmi_passive_conv_on=0 THEN

IF PROC_STATUS PROC(proc_infeed_main)=0 THEN
    RUN "INFEED_MAIN_V100",proc_infeed_main
    PRINT #0, "Run INFEED_MAIN"
ENDIF
IF PROC_STATUS PROC(proc_infeed_regist)=0 THEN 'proc 5 = INFEED_REGIST
    RUN "INFEED_REGIST_V100",proc_infeed_regist
    PRINT #0, "Run INFEED_REGIST"
ENDIF
RUN"TRANSFER_V100",proc_transfer
PRINT #0, "Run Transfer"
RUN"SEAL_V100",proc_seal
PRINT #0, "Atmos/Map-F Mode"
RUN"REWIND_V100",proc_rewind
PRINT #0, "Run Rewind"
RUN"FILMFEED_V100",proc_filmfeed
PRINT #0, "Run Film Feed"

ELSE
    IF PROC_STATUS PROC(proc_infeed_main)=0 THEN
        RUN "INFEED_MAIN_V100",proc_infeed_main
        PRINT #0, "Run INFEED_MAIN"
    ENDIF
ENDIF

WAIT UNTIL IN(i_safety_infeed)=0 OR IN(i_safety_general)=0 ' Wait until safety OFF
PRINT #0, "Safety Off "

VR(commands_mc).mc_running=0

IF VR(commands_hmi).hmi_passive_conv_on=1 THEN
    CANCEL(2) AXIS(ax_infeed)
    CANCEL(2) AXIS(ax_stepper)
    CANCEL(2) AXIS(ax_outfeed)
ENDIF

CANCEL(2) AXIS(ax_filmfeedbrake)
AXIS_ENABLE AXIS(ax_filmfeedbrake)=OFF

STOP"TRANSFER_V100"
STOP"SEAL_V100"
STOP"REWIND_V100"
STOP"FILMFEED_V100"

PRINT #0, "Programs Off "

CANCEL(2) AXIS(ax_transfer)
CANCEL(2) AXIS(ax_rewind)
CANCEL(2) AXIS(ax_filmfeed)
CANCEL(2) AXIS(ax_oc)
CANCEL(2) AXIS(ax_seal)
CANCEL(2) AXIS(ax_outfeed)
CANCEL(2) AXIS(ax_filmfeedbrake)
PRINT #0, "Cancel all moves"
WA(500)
OP(o_magnets_ssr,OFF) 'o_magnets_ssr
AXIS_ENABLE AXIS(ax_transfer)=OFF
AXIS_ENABLE AXIS(ax_rewind)=OFF
AXIS_ENABLE AXIS(ax_filmfeed)=OFF
AXIS_ENABLE AXIS(ax_oc)=OFF
AXIS_ENABLE AXIS(ax_seal)=OFF
AXIS_ENABLE AXIS(ax_outfeed)=OFF
AXIS_ENABLE AXIS(ax_filmfeedbrake)=OFF
PRINT #0, "Enable off 1"

WA(800)
AXIS_ENABLE AXIS(ax_infeed)=OFF
AXIS_ENABLE AXIS(ax_stepper)=OFF
PRINT #0, "Enable off 2"
WA(100)

SERVO AXIS(ax_infeed)=OFF
SERVO AXIS(ax_stepper)=OFF
SERVO AXIS(ax_transfer)=OFF
SERVO AXIS(ax_rewind)=OFF
SERVO AXIS(ax_filmfeed)=OFF
SERVO AXIS(ax_oc)=OFF
SERVO AXIS(ax_seal)=OFF
SERVO AXIS(ax_outfeed)=OFF
SERVO AXIS(ax_filmfeedbrake)=OFF
'PRINT #0, "Servo OFF"
''OP(o_brake_ssr,OFF) ' Reel Brake off
'OP(o_brake_ssr,OFF) ' Reel Brake off
'OP(o_gas_isol1,OFF)
'OP(o_gas_isol2,OFF)
'OP(o_vac_pump_relay,OFF)


BASE(ax_transfer)
SYNC(4,400)' Stop Syncronisation
WAIT UNTIL SYNC_CONTROL =0
VR(seal_pause)=0
VR(seal_crush_count)=0
REPEAT
    OP(o_flashing_reset,ON)
    TICKS=300
    WAIT UNTIL TICKS<=0 OR IN(i_reset_pb)
    OP(o_flashing_reset,OFF)
    TICKS=300
    WAIT UNTIL TICKS<=0 OR IN(i_reset_pb)
UNTIL IN(i_safety_infeed) AND IN(i_safety_general)
IF WDOG=0 THEN WDOG=ON

PRINT #0, "Safety ON"
WA(1500)

FOR i=2 TO 7
    BASE (i)
    PRINT #0, "Ax:",i
    IF (AXISSTATUS AND 511) >0 THEN
        PRINT #0, "axisstatus ",AXISSTATUS
        DATUM(7)

    ENDIF
    WA(100)
NEXT i

AXIS_ENABLE AXIS(ax_infeed)=ON
AXIS_ENABLE AXIS(ax_stepper)=ON
AXIS_ENABLE AXIS(ax_transfer)=ON
AXIS_ENABLE AXIS(ax_rewind)=OFF
AXIS_ENABLE AXIS(ax_filmfeed)=ON
AXIS_ENABLE AXIS(ax_oc)=ON
AXIS_ENABLE AXIS(ax_seal)=ON
AXIS_ENABLE AXIS(ax_outfeed)=ON
AXIS_ENABLE AXIS(ax_filmfeedbrake)=ON
PRINT #0, "Axis Enable"
WA(800)

SERVO AXIS(ax_infeed)=ON
SERVO AXIS(ax_stepper)=ON
SERVO AXIS(ax_transfer)=ON
SERVO AXIS(ax_rewind)=OFF
SERVO AXIS(ax_filmfeed)=ON
SERVO AXIS(ax_oc)=ON
SERVO AXIS(ax_seal)=ON
SERVO AXIS(ax_outfeed)=ON
SERVO AXIS(ax_filmfeedbrake)=ON
PRINT #0, "Servo ON"

WA(100)

BASE(ax_filmfeed) 'Filmfeed
SPEED=(VR(film_speed)*1000)
ACCEL=(VR(film_acc)*1000)
DECEL=(VR(film_dec)*1000)
SRAMP=249
FE_LIMIT=15000
PRINT #0, "Film Feed Par Set, Ax4"

BASE(ax_oc) ' Jaws
CANCEL(2)
WA(100)
RS_LIMIT=-200
FS_LIMIT=4925'6600
FE_LIMIT=1000
SPEED=6000
ACCEL=10000
DECEL=10000
SRAMP=240
PRINT #0, "Jaws Par Set, Ax5"
MOVEABS(0)
WA(100)
PRINT #0, "Jaws move to 0"
REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart 'If safety off goto restart
    IF -1200>DRIVE_TORQUE OR DRIVE_TORQUE>1200 THEN
        PRINT #0, "Overtorque on Home Ret AX 5: ";DRIVE_TORQUE
        alarm_max_torque.ax_oc=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

PRINT #0, "Jaws Ret to 0 finish"

ACCEL=(VR(oc_acc)*1000)
DECEL=(VR(oc_dec)*1000)

SPEED=(VR(oc_speed)*1000)
SRAMP=VR(oc_sshape)
FE_LIMIT=3000

PRINT #0, "Jaws Par Set 1, Ax5"

BASE(2) 'Transfer
SYNC(4,400)
WAIT UNTIL SYNC_CONTROL =0
PRINT #0, "Transfer Sync control= 0, Ax2"
RS_LIMIT=-640
FS_LIMIT=164400'139000
FE_LIMIT=9000
SPEED=40000
ACCEL=30000
DECEL=30000
SRAMP=240
PRINT #0, "Transfer Par Set, Ax2"

MOVEABS(0)
WA(100)
REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(2) OR DRIVE_TORQUE AXIS(2)>1200 THEN
        PRINT #0, "Overtorque on Home Ret AX 2: ";DRIVE_TORQUE AXIS(2)
        alarm_max_torque.ax_transfer=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

PRINT #0, "Transfer Ret to 0 finish"

FE_LIMIT=15000
SRAMP=140
ACCEL=(VR(trf_acc)*500)
DECEL=(VR(trf_dec)*500)
SPEED=(VR(trf_speed)*500)
PRINT #0, "Transfer Par Set 1, Ax2"

BASE(ax_seal) 'Seal
RS_LIMIT=-640
FS_LIMIT=60000
FE_LIMIT=2000
SPEED=6000
ACCEL=3000
DECEL=3000
SRAMP=240
PRINT #0, "Seal Par Set, Ax6"
MOVEABS(0)
WA(100)
REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(6) OR DRIVE_TORQUE AXIS(6)> 1200 THEN
        PRINT #0, "Overtorque on home Ret AX 6: ";-DRIVE_TORQUE AXIS(6)
        alarm_max_torque.ax_seal=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE
PRINT #0, "Seal Ret to 0 finish"
FE_LIMIT=7000
SPEED=(VR(seal_speed)*1000)
ACCEL=(VR(seal_acc)*1000)
DECEL=(VR(seal_dec)*1000)
SRAMP=100
PRINT #0, "Seal Par Set 1 , Ax6"
WA(500)
GOTO restart



