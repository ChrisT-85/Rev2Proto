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
DISABLE_GROUP(0,1) ' Infeed , Stepper
DISABLE_GROUP(3,4,8) ' Film feed, Rewind, film feed brake
DISABLE_GROUP(2,5,6,7) ' Transfer, Jaws, Seal, Outfeed
DISABLE_GROUP(8) 'Fill Conveyor
DISABLE_GROUP(9,10)'skinpac

VR(infeed_acc)=3000000
VR(infeed_dec)=3000000
VR(oc_open_pos)=0

'RUN"HMI",2
'RUN"ANALOGUE",3
'RUN"GENERATE_DATA",3
'RUN"STEPPER_GUIDES",12
'RUN"CLOCK",13
'RUN"FILL_CONV",10
'RUN"AUTO_TENSION",15

'IF machine_mode>=2 THEN 'skinpac or vac test mode
'    machine_mode=0 'atmospheric
'    WA(50)
'ENDIF
'
'WAIT UNTIL machine_mode>=0

'seal_torque_rms=0
'transfer_not_ready=0
'infeed_pack_count=0
'alarm=0
'al_max_torque=0
'film_commands.0=0
'hmi_commands=0
'ppm=0
'data_machine_status=-1
'seal_pause=0
'seal_pause_aux=0
'crush_count=0
'OP(io_vitual_machine_run,OFF) ' Virtual IO Machine running off
'OP(o_magnets_ssr,OFF) 'Magnets SSR OFF

'Infeed  128.2/mm
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
'ACCEL=400000 '8500000
'DECEL=400000 '8500000
'SRAMP=150
'SPEED=30000
'SRAMP=150
ADDAX(15)

'Stepper  128.2/mm
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
'CREEP=600
'ACCEL=6000000
'DECEL=5000000
'SPEED=20000
'SRAMP=150

'Transfer 128.2/mm
BASE(ax_transfer)
UNITS=100
DATUM_IN=2
FHOLD_IN=-1
FWD_IN=-1
REV_IN=-1
JOGSPEED=1
P_GAIN=0
I_GAIN=0
D_GAIN=0
VFF_GAIN=0
OV_GAIN=0
FE_LIMIT=15000
REP_DIST=2000000000
DAC=0
SERVO=OFF
DAC_SCALE = -1
ENCODER_RATIO(12820,4097)
STEP_RATIO(4097,12820)
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
ENCODER_RATIO(-12820,8023)
STEP_RATIO(-8023,12820)
DATUM(0)
DEFPOS(0)
WAIT UNTIL OFFPOS=0

'Jaws  43.33333/mm
BASE(ax_jaws)
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

'Outfeed  128.2/mm
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
WA(1000)

SERVO AXIS(0)=ON
SERVO AXIS(1)=ON
SERVO AXIS(2)=ON
SERVO AXIS(3)=OFF
SERVO AXIS(4)=ON
SERVO AXIS(5)=ON
SERVO AXIS(6)=ON
SERVO AXIS(7)=ON

WA(100)

BASE(ax_filmfeed) 'Filmfeed
SPEED=VR(film_speed)*1000
ACCEL=VR(film_acc)*1000
DECEL=VR(film_dec)*1000
SRAMP=200
FE_LIMIT=20000

BASE(ax_jaws) ' Jaws
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
        VR(al_max_torque).ax_jaws=1
        GOTO restart_datum
    ENDIF
UNTIL NOT IDLE

REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(5) OR DRIVE_TORQUE AXIS(5)>1200 THEN
        PRINT #0, "Overtorque on Home Ret AX 5: ";DRIVE_TORQUE AXIS(5)
        VR(al_max_torque).ax_jaws=1
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
RS_LIMIT= -165050
FS_LIMIT=139000
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
        VR(al_max_torque).ax_transfer=1
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
        VR(al_max_torque).ax_transfer=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE
DEFPOS(0)
WAIT UNTIL OFFPOS=0
RS_LIMIT=-640
FS_LIMIT=164400
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
        VR(al_max_torque).ax_seal=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

DATUM(4)
WAIT LOADED

REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(6) OR DRIVE_TORQUE AXIS(6)> 1200 THEN
        PRINT #0, "Overtorque on home Ret AX 6: ";-DRIVE_TORQUE AXIS(6)
        VR(al_max_torque).ax_seal=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

MOVEABS (VR(-seal_home_offset)*10)

REPEAT
    IF IN(i_safety_general)=0 THEN GOTO restart_datum 'If safety off goto restart
    IF -1200>DRIVE_TORQUE AXIS(6) OR DRIVE_TORQUE AXIS(6)> 1200 THEN
        PRINT #0, "Overtorque on home Ret AX 6: ";-DRIVE_TORQUE AXIS(6)
        VR(al_max_torque).ax_seal=1
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

''RUN "MAX_TORQUES",4
'
restart:
'PRINT #0, "Restart Jump point"
'
''*********************************************** Machine Mode
'' 0 -> Atmos/Map-f
'' 1 -> Passive Conveyor
'' 2 -> SkinPAC
'' 3 -> Vac Test
'
'IF machine_mode=0 OR machine_mode=2 THEN ' atmos/map-f or skinpac mode
'    'STOP "VAC_TEST"
'    IF PROC_STATUS PROC(5)=0 THEN 'proc 5 = INFEED_MAIN
'        RUN "INFEED_MAIN",5
'        PRINT #0, "Run INFEED_MAIN"
'    ENDIF
'    IF PROC_STATUS PROC(20)=0 THEN 'proc 5 = INFEED_REGIST
'        RUN "INFEED_REGIST",20
'        PRINT #0, "Run INFEED_REGIST"
'    ENDIF
'    RUN"TRANSFER",6
'    PRINT #0, "Run Transfer"
'    IF machine_mode=0 THEN
'        'STOP "SEAL_SKINPAC"
'        'WA(500)
'        RUN"SEAL",7
'        PRINT #0, "Atmos/Map-F Mode"
'    ELSE
'        STOP "SEAL"
'        WA(500)
'        'RUN "SEAL_SKINPAC",7
'        PRINT #0, "SkinPAC Mode"
'    ENDIF
'    RUN"REWIND_TORQUE",8
'    PRINT #0, "Run Rewind"
'    RUN"FILM_FEED",9
'    PRINT #0, "Run Film Feed"
'
'    BASE(16) ' PWM Brake
'    IF MTYPE AXIS(16)<>10 THEN FORWARD AXIS(16)
'    PSWITCH(0,ON,16,11,ON,0,reel_brake_force) ' PWM Brake
'    PRINT #0, "Start PWM Reel Brake"
'
'ELSEIF machine_mode=1 OR machine_mode=3 THEN ' passive conveyor or vac test mode
'    IF machine_mode=3 THEN 'vac test mode
'        STOP "INFEED_MAIN"
'        STOP "INFEED_REGIST"
'        WA(500)
'        IF PROC_STATUS PROC(11)=0 THEN
'            'RUN "VAC_TEST" ,11
'            PRINT #0, "Start Vac Test Mode"
'        ENDIF
'
'    ELSE 'passive conveyor mode
'        IF PROC_STATUS PROC(5)=0 THEN 'proc 5 = INFEED_MAIN
'            RUN "INFEED_MAIN",5
'            PRINT #0, "Run INFEED_MAIN"
'        ENDIF
'    ENDIF
'ENDIF

WAIT UNTIL IN(i_safety_infeed)=0 OR IN(i_safety_general)=0 ' Wait until safety OFF
PRINT #0, "Safety Off "

OP(o_mc_running,0) ' Machine running off

IF machine_mode=1 THEN 'passive conveyor
    CANCEL(2) AXIS(0)
    CANCEL(2) AXIS(1)
    CANCEL(2) AXIS(7)
ENDIF

CANCEL(2) AXIS(8)
AXIS_ENABLE AXIS(8)=OFF

'STOP"TRANSFER"
'STOP"SEAL"
''STOP"SEAL_SKINPAC"
'STOP"REWIND_TORQUE"
'STOP"FILM_FEED"

PRINT #0, "Programs Off "

CANCEL(2) AXIS(2)
CANCEL(2) AXIS(3)
CANCEL(2) AXIS(4)
CANCEL(2) AXIS(5)
CANCEL(2) AXIS(6)
CANCEL(2) AXIS(7)
CANCEL(2) AXIS(16)
PRINT #0, "Cancel all moves"
WA(500)
OP(o_magnets_ssr,OFF) 'o_magnets_ssr
OP(o_gas_valve1,OFF) 'o_gas_valve1
OP(o_gas_valve2,OFF) 'o_gas_valve2
AXIS_ENABLE AXIS(2)=OFF
AXIS_ENABLE AXIS(3)=OFF
AXIS_ENABLE AXIS(4)=OFF
AXIS_ENABLE AXIS(5)=OFF
AXIS_ENABLE AXIS(6)=OFF
AXIS_ENABLE AXIS(7)=OFF
PRINT #0, "Enable off 1"

WA(800)
AXIS_ENABLE AXIS(0)=OFF
AXIS_ENABLE AXIS(1)=OFF
PRINT #0, "Enable off 2"
PSWITCH(0,OFF) ' PWM Brake
WA(100)

SERVO AXIS(0)=OFF
SERVO AXIS(1)=OFF
SERVO AXIS(2)=OFF
SERVO AXIS(3)=OFF
SERVO AXIS(4)=OFF
SERVO AXIS(5)=OFF
SERVO AXIS(6)=OFF
SERVO AXIS(7)=OFF
PRINT #0, "Servo OFF"
OP(o_brake_ssr,OFF) ' Reel Brake off
OP(o_brake_ssr,OFF) ' Reel Brake off
OP(o_gas_isol1,OFF)
OP(o_gas_isol2,OFF)
OP(o_vac_pump_relay,OFF)


BASE(ax_transfer)
SYNC(4,400)' Stop Syncronisation
WAIT UNTIL SYNC_CONTROL =0
'seal_pause=0
'seal_pause_aux=0
'crush_count=0
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
        PRINT #0, "Datum(7) ax",i
    ENDIF
    WA(100)
NEXT i

AXIS_ENABLE AXIS(0)=ON
AXIS_ENABLE AXIS(1)=ON
AXIS_ENABLE AXIS(2)=ON
AXIS_ENABLE AXIS(3)=OFF
AXIS_ENABLE AXIS(4)=ON
AXIS_ENABLE AXIS(5)=ON
AXIS_ENABLE AXIS(6)=ON
AXIS_ENABLE AXIS(7)=ON
PRINT #0, "Axis Enable"
WA(800)

SERVO AXIS(0)=ON
SERVO AXIS(1)=ON
SERVO AXIS(2)=ON
SERVO AXIS(3)=OFF
SERVO AXIS(4)=ON
SERVO AXIS(5)=ON
SERVO AXIS(6)=ON
SERVO AXIS(7)=ON
PRINT #0, "Servo ON"

WA(100)

BASE(4) 'Filmfeed
SPEED=film_speed*1000
ACCEL=film_acc*1000
DECEL=film_dec*1000
SRAMP=249
FE_LIMIT=15000
PRINT #0, "Film Feed Par Set, Ax4"

BASE(5) ' Jaws
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
        al_max_torque.5=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

PRINT #0, "Jaws Ret to 0 finish"

ACCEL=oc_acc*1000
DECEL=oc_dec*1000
SPEED=oc_speed*1000
SRAMP=oc_sshape
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
        al_max_torque.2=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE

PRINT #0, "Transfer Ret to 0 finish"

FE_LIMIT=15000
SRAMP=140
ACCEL=trf_acc*500
DECEL=trf_dec*500
SPEED=trf_speed*500
PRINT #0, "Transfer Par Set 1, Ax2"

BASE(6) 'Seal
RS_LIMIT=-640
FS_LIMIT=47000
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
        al_max_torque.6=1
        GOTO restart_datum
    ENDIF
UNTIL IDLE
PRINT #0, "Seal Ret to 0 finish"
FE_LIMIT=7000
SPEED=seal_speed*1000
ACCEL=seal_acc*1000
DECEL=seal_dec*1000
SRAMP=100
PRINT #0, "Seal Par Set 1 , Ax6"
WA(500)
GOTO restart