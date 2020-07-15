'==============================================================================
' Filename: TRANSFER_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for transferring the packs into the machine
'==============================================================================

BASE(ax_transfer)
SYNC(4,400)'stop sync 400ms
WAIT UNTIL SYNC_CONTROL =0 ' No synchronisation
BASE(ax_oc)
MOVEABS (VR(oc_open_pos))' Open Jaws
WAIT IDLE

start:

BASE(ax_transfer)
ACCEL=VR(trf_acc)*900
DECEL=VR(trf_dec)*900
SPEED=VR(trf_speed)*900

MOVEABS(0)

BASE(ax_oc)
ACCEL=VR(oc_acc)*1000
DECEL=VR(oc_dec)*1000
SPEED=VR(oc_speed)*1000
SRAMP=VR(oc_sshape)

BASE(ax_oc)
WAIT UNTIL VR(infeed_pack_count)>=VR(n_impressions)

IF VR(commands_trans).trans_pos_set_flag=0 THEN
    IF VR(commands_trans).trans_final_inc_on THEN
        local_transfer_start=ENDMOVE AXIS(1)-100
    ELSE
        local_transfer_start=ENDMOVE AXIS(1)+((VR(stp_final_increment)*10)-(VR(stp_increment)*10))
    ENDIF
    VR(commands_trans).trans_pos_set_flag=1
ENDIF

VR(gbl_trf_start)=local_transfer_start

WAIT UNTIL (MPOS<1000 AND MPOS AXIS(ax_seal)<4200) AND VR(commands_seal).seal_cycle=0
MOVEABS(VR(oc_mid_pos)) AXIS(ax_oc) 'Close to middle POS

ACCEL=VR(trf_acc)*1000
DECEL=VR(trf_dec)*1000
SPEED=VR(trf_speed)*1000
WAIT UNTIL MPOS AXIS(ax_oc)> (VR(oc_mid_pos)-1000)
MOVEABS(0) AXIS(ax_seal)

WAIT UNTIL MPOS AXIS(ax_stepper) >= local_transfer_start-100

IF VR(commands_trans).trans_final_inc_on=0 THEN
    SPEED AXIS(ax_virtual_infeed)=(VR(infeed_speed)*VR(trf_pick_up_speed))
ENDIF

IF VR(commands_trans).trans_final_inc_on THEN MOVEABS(VR(oc_close_pos)) AXIS(ax_oc)
VR(commands_trans).trans_pos_set_flag=0
VR(infeed_pack_count)=(VR(infeed_pack_count)-VR(n_impressions))

'SYNC(CONTROL, SYNC_TIME, [sync_position, SYNC_AXIS, pos1[, pos2 [,pos3]]])
local_time_to_sync=400 'Time to complete the synchronisation movement in milliseconds ' was 300
local_sync_position = local_transfer_start 'The captured position on the sync_axis
local_pos1= 0 'Absolute position on the first axis on the base array
WAIT UNTIL MPOS AXIS(ax_seal)<1000

SYNC(ax_stepper,local_time_to_sync,local_sync_position,1,local_pos1)

IF VR(commands_trans).trans_not_ready=1 THEN
    IF IDLE AXIS(ax_virtual_infeed)=0 THEN FORWARD AXIS(ax_virtual_infeed)
    VR(commands_trans).trans_not_ready=0
ENDIF

WAIT UNTIL SYNC_TIMER>150 '300
MOVEABS(VR(oc_close_pos)) AXIS(ax_oc)
WAIT UNTIL MPOS AXIS(ax_oc) > (VR(oc_close_pos)-1000)
MOVEABS(VR(trf_tool_pos)*10)
WAIT LOADED
WAIT UNTIL VP_SPEED > MSPEED/10
SYNC(4,400)'stop sync 400ms
WA(20)
SPEED AXIS(ax_virtual_infeed)=VR(infeed_speed)*10
WAIT UNTIL SYNC_CONTROL =0 ' No synchronisation
MOVEMODIFY(VR(trf_tool_pos)*10)
MOVE(50) AXIS(ax_oc)
WAIT UNTIL REMAIN <(VR(oc_open_ant_pos)) '1500 orig 3000
IF VR(commands_conv).outfeed_pause=1 THEN CANCEL AXIS(ax_outfeed) ' Stop outfeed
MOVEABS(276*5) AXIS(ax_seal)'Move Seal up 5mm
MOVEABS(VR(oc_open_pos)) AXIS(ax_oc)' Open Jaws

IF VR(oc_speed)<=22 THEN ' less than 30m/min
    WAIT UNTIL MPOS AXIS(ax_oc)<(VR(oc_open_pos)+80) '2mm ish
ELSE
    WAIT UNTIL MPOS AXIS(ax_oc)<(VR(oc_open_pos)+1500)'34.6mm '3000
ENDIF

IF VR(commands_conv).outfeed_pause=1 THEN FORWARD AXIS(ax_outfeed) ' restart outfeed
IF VR(commands_seal).seal_bypass=0 THEN VR(commands_seal).seal_start=1 'Do not Seal if seal bypass
GOTO start
