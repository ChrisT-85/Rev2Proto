'==============================================================================
' Filename: INFEED_REGIST_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for positioning of the pack on the stepper belt,
'==============================================================================

BASE(ax_virtual_infeed)
REG_INPUTS=0
local_sensor_pos=8541
loop:
BASE(ax_virtual_infeed)
WAIT UNTIL NOT IDLE AXIS(ax_virtual_infeed)
REGIST(20,0,4,0,0)'REGIST(20, channel, source, edge, window) Single channel hardware registration

WA(10)
WAIT UNTIL MARK
local_start_pos=REG_POS + local_sensor_pos
BASE(ax_stepper)
local_move_left=ENDMOVE-MPOS
local_correction= local_sensor_pos-local_move_left-50
'PRINT #0, "Start Pos 2: ";local_start_pos
'PRINT #0, "MoveLeft 1: ";local_move_left
'PRINT #0, "Correction: ";local_correction

IF VR(commands_trans).trans_final_inc_on AND VR(infeed_pack_count)=VR(n_impressions) THEN
    IF (local_correction < 8541) THEN
        local_correction_start=(VR(stp_final_increment)-(VR(stp_increment)/2)*10)
        'WAIT UNTIL (ENDMOVE-MPOS < (stp_increment*10)*0.85) OR IN(i_safety_infeed)=0 'If Safety infeed off go to cancel
        WAIT UNTIL (REMAIN< local_correction) OR IN(i_safety_infeed)=0 'If Safety infeed off go to cancel
        'CANCEL AXIS(15)
        IF IN(i_safety_infeed)=0 THEN
            CANCEL(2) AXIS(ax_infeed)
            CANCEL(2) AXIS(ax_stepper)
            GOTO loop
        ENDIF
        SPEED AXIS(ax_infeed) = VP_SPEED AXIS(ax_virtual_infeed)
        MOVE (local_correction-8541) AXIS(ax_infeed)
        local_start_pos=local_start_pos-(local_correction-8541)
    ENDIF
ELSE
    IF (local_correction < 100) THEN
        'WAIT UNTIL (ENDMOVE-MPOS < (stp_increment*10)*0.5) OR IN(i_safety_infeed)=0 'If Safety infeed off go to cancel
        WAIT UNTIL (REMAIN < (VR(stp_increment)*4)) OR IN(i_safety_infeed)=0 'If Safety infeed off go to cancel
        IF IN(i_safety_infeed)=0 THEN
            CANCEL(2) AXIS(ax_infeed)
            CANCEL(2) AXIS(ax_stepper)
            GOTO loop
        ENDIF
        SPEED AXIS(ax_stepper) = VP_SPEED AXIS(ax_virtual_infeed)
        MOVE (local_correction-100) AXIS(ax_infeed)
        local_start_pos=local_start_pos-(local_correction-50)
    ENDIF
ENDIF


IF VR(infeed_pack_count)=(VR(n_impressions)-1) AND VR(commands_trans).trans_final_inc_on THEN 'If final increment ON
    MOVELINK(VR(stp_final_increment)*10,VR(stp_final_increment)*10,1000,1000,ax_virtual_infeed,18,local_start_pos)
ELSE
    MOVELINK((VR(stp_increment)*10),(VR(stp_increment)*10),1000,1000,ax_virtual_infeed,18,local_start_pos)
ENDIF

WAIT LOADED

BASE(ax_infeed)
VR(infeed_pack_count)=VR(infeed_pack_count)+1
VR(batch_count)=VR(batch_count)+1

IF VR(commands_conv).conv_infeed_split_mode=1 THEN
    local_split_wait_pos_act=MPOS+(VR(split_wait_pos)*10)
    WAIT UNTIL (MPOS>local_split_wait_pos_act OR IN(i_safety_infeed)=0)
ENDIF

GOTO loop



