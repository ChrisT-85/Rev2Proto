'==============================================================================
' Filename: MAX_TORQUES_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for monitoring the torque values of the servo axis
'==============================================================================

local_done=0
VR(alarm_max_torque)=0 ' VR00, Bit 0 -> Alarm AX0 ... Bit 15 -> Alarm AX15
loop:
IF IN(i_safety_general) THEN

    'infeed
    IF DRIVE_TORQUE AXIS(ax_infeed)>1500 THEN
        PRINT #0, "Overtorque Infeed: ";DRIVE_TORQUE AXIS(ax_infeed)
        VR(alarm_max_torque).ax_infeed=1
        GOTO alarm_out
    ENDIF
    ' STEPPER
    IF DRIVE_TORQUE AXIS(ax_stepper)>2000 THEN
        PRINT #0, "Overtorque Stepper: ";DRIVE_TORQUE AXIS(ax_stepper)
        VR(alarm_max_torque).ax_stepper=1
        GOTO alarm_out
    ENDIF

    ' TRANSFER
    IF -4000>DRIVE_TORQUE AXIS(ax_transfer) OR DRIVE_TORQUE AXIS(ax_transfer)>4000 THEN
        PRINT #0, "Overtorque Transfer: ";DRIVE_TORQUE AXIS(ax_transfer)
        VR(alarm_max_torque).ax_transfer=1
        GOTO alarm_out
    ENDIF

    ' REWIND
    IF -5000> MSPEED AXIS(ax_rewind) >8000 THEN
        PRINT #0, "Overspeed Rewind: ";MSPEED AXIS(ax_rewind)
        VR(alarm_max_torque).ax_rewind=1
        GOTO alarm_out
    ENDIF

    ' FILMFEED
    IF -3500>DRIVE_TORQUE AXIS(ax_filmfeed) OR DRIVE_TORQUE AXIS(ax_filmfeed)>3500 THEN
        PRINT #0, "Overtorque Film Feed: ";DRIVE_TORQUE AXIS(ax_filmfeed)
        VR(alarm_max_torque).ax_filmfeed=1
        GOTO alarm_out
    ENDIF

    ' JAWS
    IF -4000>DRIVE_TORQUE AXIS(ax_oc) OR DRIVE_TORQUE AXIS(ax_oc)>4000 THEN
        PRINT #0, "Overtorque Jaws: ";DRIVE_TORQUE AXIS(ax_oc)
        VR(alarm_max_torque).ax_oc=1
        GOTO alarm_out
    ENDIF

    ' SEAL
    IF -4500>-DRIVE_TORQUE AXIS(ax_seal) OR -DRIVE_TORQUE AXIS(ax_seal)> 4500 THEN
        PRINT #0, "Overtorque Seal: ";-DRIVE_TORQUE AXIS(ax_seal)
        VR(alarm_max_torque).ax_seal=1
        GOTO alarm_out
    ENDIF

    IF (MPOS AXIS(ax_seal)>=0) AND SERVO AXIS(ax_seal)=ON AND IN(i_seal_limit_sw)=ON THEN
        PRINT #0, "Seal Limit Active "
        VR(alarm).al_seal_limit=1
        GOTO alarm_out
    ENDIF

    ' OUTFEED
    IF DRIVE_TORQUE AXIS(ax_outfeed)>3500 THEN
        PRINT #0, "Overtorque Outfeed: ";-DRIVE_TORQUE AXIS(ax_outfeed)
        VR(alarm_max_torque).ax_outfeed=1
        GOTO alarm_out
    ENDIF

    ' TRANSFER Sync error ' If transfer in sync and has passed midle travel point alarm
    IF SYNC_CONTROL AXIS(ax_transfer)=3 AND MPOS AXIS(ax_transfer)>60000 THEN
        PRINT #0, "Transfer sync error"
        VR(alarm).al_trf_sync=1
        GOTO alarm_out
    ENDIF

ENDIF

IF (MSPEED AXIS(ax_virtual_infeed)>100) AND VR(commands_hmi).hmi_batch_end=0 THEN
    VR(commands_mc).mc_running=1
    IF IDLE AXIS(ax_outfeed) THEN FORWARD AXIS(ax_outfeed) ' Start outfeed
    WA(200)
    OP(o_mc_running,1)
    OP(o_stop_pb_led,OFF)
    OP(o_start_pb_led,ON)
ELSE
    VR(commands_mc).mc_running=0
    OP(o_mc_running,0)
    OP(o_start_pb_led,OFF)
    OP(o_stop_pb_led,ON)
ENDIF


IF IN(i_safety_infeed)=0 THEN
    VR(batch_count)=VR(batch_count)-VR(infeed_pack_count)
    VR(pack_speed_count)=VR(pack_speed_count)-VR(infeed_pack_count)
    VR(infeed_pack_count)=0
    CANCEL(2) AXIS(ax_infeed)
    CANCEL(2) AXIS(ax_stepper)
    CANCEL(2) AXIS (ax_virtual_infeed)
    WA(10)
    VR(alarm).al_max_pack=0 ' Reset Max Pack Alarm
    VR(alarm).al_min_pack=0 ' Reset Min Pack Alarm
    VR(alarm_max_torque).ax_infeed=0 'Reset max torque infeed
    VR(commands_trans).trans_not_ready=0
    VR(commands_trans).trans_pos_set_flag=0
    local_done=1
ENDIF

IF IN(i_safety_infeed)=1 AND local_done=1 THEN
    local_done=0
    VR(infeed_pack_count)=0
ENDIF

'PRINT #0, "Torque Infeed: ";DRIVE_TORQUE AXIS(ax_infeed)
'PRINT #0, "Torque Stepper: ";DRIVE_TORQUE AXIS(ax_stepper)
'PRINT #0, "Torque Outfeed: ";DRIVE_TORQUE AXIS(ax_outfeed)


GOTO loop:

alarm_out:
OP(o_mc_running,0)
'STOP"INFEED_MAIN"
'STOP"TRANSFER"
'STOP"SEAL"
'STOP"REWIND_TORQUE"
'STOP"FILM_FEED"
'STOP"INFEED_REGIST"
'STOP"MAIN"

RAPIDSTOP(2)

OP(o_magnets_ssr,OFF)
WA(10)
WDOG=OFF
