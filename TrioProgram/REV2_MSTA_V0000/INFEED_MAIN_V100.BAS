'==============================================================================
' Filename: INFEED_MAIN_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for starting and stopping of the machine
' Passive Conveyor and bacth end
'==============================================================================

VR(infeed_pack_count)=0
VR(commands_mc).mc_batch_end_flag=0

BASE(ax_infeed)
REG_INPUTS=0
WAIT UNTIL IN(i_safety_infeed) AND IN(i_safety_general)

start:
IF IN(i_infeed_sensor)=OFF THEN
    OP(o_infeed_sen_teach,ON)
    WA(3000)
    OP(o_infeed_sen_teach,OFF)
ENDIF

CANCEL(2) AXIS(ax_outfeed)

PRINT #0, "Infeed Main Start Point"
VR(commands_hmi).hmi_batch_end=0
SPEED AXIS(ax_virtual_infeed)=VR(infeed_speed)*10
SPEED AXIS(ax_outfeed)=VR(outfeed_speed)*10
VR(alarm).al_max_pack=0
VR(alarm).al_min_pack=0
VR(alarm).al_filmsnap=0
VR(alarm).al_gas_pressure=0
VR(alarm).al_reg_film=0
VR(commands_hmi).hmi_clockpulse=0

base_check:

WAIT UNTIL (IN(i_safety_infeed) AND IN(i_safety_general))
IF IN(i_base_tool_lock_sens)=0 THEN
    VR(alarm).al_base_tool_not_locked=1
ELSE
    VR(alarm).al_base_tool_not_locked=0
ENDIF

IF VR(alarm).al_base_tool_not_locked=1 THEN GOTO base_check


WAIT UNTIL (IN(i_safety_infeed) AND IN(i_safety_general) AND (IN(i_start_pb)) AND IN(i_stop_pb) _
    AND VR(commands_trans).trans_not_ready=0 AND VR(alarm).al_prev_mc=0_
    AND VR(alarm).al_next_mc=0 AND VR(alarm).al_any_alarm=0 OR IN(i_base_tool_lock_sens)=0) 'safety and start

IF IN(i_base_tool_lock_sens)=0 THEN GOTO base_check

IF VR(commands_hmi).hmi_passive_conv_on=1 THEN
    GOTO passive_mode
ELSE
    WAIT UNTIL PROC_STATUS PROC(proc_filmfeed)<>0
ENDIF

restart_trf:

WAIT UNTIL IN(i_safety_infeed) AND IN(i_safety_general) AND IN(i_stop_pb)_
    AND VR(commands_trans).trans_not_ready=0 AND VR(commands_seal).seal_pause=0

SPEED AXIS(ax_virtual_infeed)=VR(infeed_speed)*10
SPEED AXIS(ax_outfeed)=VR(outfeed_speed)*10
IF IDLE AXIS(ax_outfeed) THEN FORWARD AXIS(ax_outfeed) ' Start outfeed
WA(1000)
FORWARD AXIS(ax_virtual_infeed)' Start virtual axis
VR(pack_speed_count)=0
TICKS=60000
TICKS PROC(proc_infeed_regist)=1500
BASE(ax_infeed)
REGIST(21,0,0,0,0)'REGIST(21, channel, source, edge, window)'rising edge
local_pack_in=0
VR(pack_size)=(VR(min_pack_size)+VR(max_pack_size))/2

REPEAT
'clock pulse
    IF VR(commands_hmi).hmi_clockpulse AND (TICKS PROC(proc_infeed_regist)<0) THEN
        WAIT UNTIL VR(commands_seal).seal_pause=0 OR IN(i_safety_general)=0
        MOVELINK(VR(stp_increment)*10,VR(stp_increment)*10,1500,1800,ax_virtual_infeed,18,MPOS AXIS(ax_virtual_infeed)_
            +10000) AXIS(ax_stepper)
        WAIT LOADED AXIS(ax_stepper)
        VR(infeed_pack_count)=VR(infeed_pack_count)+1
        VR(batch_count)=VR(batch_count)+1
        TICKS PROC(proc_infeed_regist)=2000
        VR(pack_speed_count)=VR(pack_speed_count)+1
    ENDIF

    'MOVELINK (distance, link_dist, link_acc, link_dec, link_axis[, link_options][, link_pos][,base_dist])

    IF R_MARK(0) THEN
        IF local_pack_in=0 THEN
            VR(pack_speed_count)=VR(pack_speed_count)+1
            local_pack_start=R_REGPOS(0)
            PRINT #0, "Reg Pos 0: "; R_REGPOS(0)
            REGIST(21,0,0,1,0)'REGIST(21, channel, source, edge, window)'falling edge
            local_pack_in=1
        ELSE
            VR(pack_size)=(R_REGPOS(0)-local_pack_start)/97.8
            'PRINT #0, "Pack size: "; VR(pack_size)
            REGIST(21,0,0,0,0)'REGIST(21, channel, source, edge, window)'rising edge
            local_pack_in=0
        ENDIF
    ENDIF
'batch end
    IF (VR(commands_hmi).hmi_batch_end AND IDLE AXIS(ax_stepper)) THEN GOSUB batch_end
'cycle stop
    IF IN(i_stop_pb)=0 OR IN(i_safety_general)=0_
            OR VR(pack_size)> VR(max_pack_size) _
            OR VR(pack_size)< VR(min_pack_size) _
            OR VR(alarm).al_any_alarm _
            OR VR(alarm).al_next_mc _
            OR VR(alarm).al_printer _
            OR (local_pack_in=1 AND MPOS AXIS(ax_infeed)>(local_pack_start+VR(max_pack_size)*97.8)) THEN

        IF (local_pack_in=1 AND MPOS AXIS(ax_infeed)>(local_pack_start+VR(max_pack_size)*97.8)) THEN
            PRINT #0, "New Max Pack"
            VR(pack_size)=(MPOS AXIS(ax_infeed)-local_pack_start)/97.8
        ENDIF

        PRINT #0, "ALARM POINT"
        CANCEL(2) AXIS(ax_virtual_infeed)
        CANCEL(2) AXIS(ax_outfeed)
    ENDIF
'trans not ready
    IF VR(commands_trans).trans_not_ready=0 AND VR(infeed_pack_count)=(VR(n_impressions)+1)_
            AND (MPOS AXIS(ax_seal)>4500 OR MPOS AXIS(ax_transfer)>1000) THEN
        PRINT #0, "TRF NOT READY"
        PRINT #0, "infeed_pack_count: ";VR(infeed_pack_count)
        PRINT #0, "Seal MPOS seal: ";MPOS AXIS(ax_seal)
        PRINT #0, "Seal MPOS trf: ";MPOS AXIS(ax_transfer)
        local_trf_step_needed=VR(gbl_trf_start)-4000
        VR(commands_trans).trans_not_ready=1
    ENDIF

    IF VR(commands_trans).trans_not_ready=1 _
            AND (MPOS AXIS(ax_stepper)> local_trf_step_needed) _
            OR (MPOS AXIS(ax_stepper)> local_trf_step_needed AND VR(commands_seal).seal_pause=1) THEN
        CANCEL AXIS(ax_virtual_infeed)
    ENDIF

UNTIL IDLE AXIS(ax_virtual_infeed)

IF VR(commands_trans).trans_not_ready=1 OR VR(commands_seal).seal_pause=1 THEN GOTO restart_trf

IF VR(pack_size)> VR(max_pack_size) OR VR(pack_size)<VR(min_pack_size) THEN
    PRINT #0, "Pack size: "; VR(pack_size)
    IF VR(pack_size)>VR(max_pack_size)THEN VR(alarm).al_max_pack=1 'Set Max pack Alarm
    IF VR(pack_size)<VR(min_pack_size) THEN VR(alarm).al_min_pack=1 ' Set Min Pack Alarm
ENDIF
IF NOT IN(i_safety_general) THEN CANCEL AXIS(ax_outfeed)
IF VR(alarm)<>0 THEN
    REPEAT
        OP(o_flashing_reset,ON)
        WA(300)
        OP(o_flashing_reset,OFF)
        WA(300)
    UNTIL IN(i_reset_pb)
ENDIF

IF WDOG THEN GOTO start
CANCEL AXIS(ax_outfeed)
VR(infeed_pack_count)=0

GOTO exit

batch_end:
BASE(ax_stepper)
PRINT #0, "Batch End Start"
WA(500)
WAIT UNTIL (MPOS AXIS(ax_transfer)<1000 AND MPOS AXIS(ax_seal)<4000)
CANCEL AXIS(ax_virtual_infeed)
IF VR(infeed_pack_count)=0 THEN VR(commands_mc).mc_batch_end_flag=1

IF VR(commands_trans).trans_final_inc_on=0 THEN VR(infeed_pack_count)=VR(n_impressions)
WA(100)
IF VR(commands_mc).mc_batch_end_flag=1 THEN VR(commands_seal).seal_bypass=1
MOVE (VR(stp_final_increment)*10)
WAIT UNTIL IDLE OR IN(i_stop_pb)=0 OR IN(i_safety_general)=0
IF VR(commands_trans).trans_final_inc_on=1 THEN
    VR(infeed_pack_count)=VR(n_impressions)
    WAIT UNTIL (MPOS AXIS(ax_oc) > (VR(oc_close_pos)-1000)) OR IN(i_safety_general)=0
ENDIF
WAIT UNTIL VR(infeed_pack_count)=0 OR IN(i_stop_pb)=0 OR IN(i_safety_general)=0
WAIT UNTIL (MPOS AXIS(ax_transfer)<1000 AND MPOS AXIS(ax_seal)<4000)
WA(3000)
IF VR(commands_mc).mc_batch_end_flag=0 THEN GOTO batch_end
WA(5000)
CANCEL AXIS(ax_outfeed)
VR(commands_seal).seal_bypass=0
VR(commands_mc).mc_batch_end_flag=0

BASE(ax_infeed)
PRINT #0, "Batch End Finish"
RETURN

passive_mode:

WAIT UNTIL IN(i_safety_infeed) AND IN(i_safety_general) 'wait for safety

SPEED AXIS(ax_infeed)=(VR(infeed_speed)*10)
SPEED AXIS(ax_stepper)=(VR(infeed_speed)*10)
SPEED AXIS(ax_outfeed)=(VR(outfeed_speed)*10)

FORWARD AXIS(ax_infeed)
FORWARD AXIS(ax_stepper)

REPEAT
    SPEED AXIS(ax_infeed)=(VR(infeed_speed)*10)
    SPEED AXIS(ax_stepper)=(VR(infeed_speed)*10)
    SPEED AXIS(ax_outfeed)=(VR(outfeed_speed)*10)
    IF IN(i_infeed_sensor)=1 AND VR(passive_pack_count)=0 THEN
        TICKS=2000
        VR(passive_pack_count)=1
    ENDIF
    IF VR(passive_pack_count)=1 THEN
        IF TICKS<=0 THEN
            VR(passive_pack_count)=0
        ENDIF
        IF IN(i_infeed_sensor)=0 THEN
            VR(passive_pack_count)=0
            VR(batch_count)=VR(batch_count)+1
        ENDIF
    ENDIF

UNTIL IN(i_safety_infeed)=0 OR IN(i_safety_general)=0_
    OR IN(i_stop_pb)=0_
    OR VR(commands_hmi).hmi_passive_conv_on=0 _
    OR VR(alarm).al_next_mc _
    OR VR(alarm).al_any_alarm

CANCEL(2) AXIS(ax_infeed)
CANCEL(2) AXIS(ax_stepper)
CANCEL(2) AXIS(ax_outfeed)

GOTO start
RETURN

exit:
