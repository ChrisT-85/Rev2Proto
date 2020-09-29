'==============================================================================
' Filename: HMI_V***.BAS
' Revisions:
' V100 - Initial release. (Systems Team)
'------------------------------------------------------------------------------
' Abstract:
' This program is for reading the servo axis to HMI,
' brake resistor AND cubicle temps
' next mc, prev mc and printer alarms
'==============================================================================

VR(al_rem_err_infeed)=0
VR(al_rem_err_stepper)=0
VR(al_rem_err_transfer)=0
VR(al_rem_err_rewind)=0
VR(al_rem_err_filmfeed)=0
VR(al_rem_err_oc)=0
VR(al_rem_err_seal)=0
VR(al_rem_err_outfeed)=0

TICKS=60000

loop:

VR(axisstatus_infeed)=AXISSTATUS AXIS(ax_infeed)
IF VR(axisstatus_infeed).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_infeed,$2101,1,5,al_rem_err_infeed) THEN PRINT #0, "Error reading AX 0 alarm"
    WA(100)
ENDIF

VR(axisstatus_stepper)=AXISSTATUS AXIS(ax_stepper)
IF VR(axisstatus_stepper).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_stepper,$2101,1,5,al_rem_err_stepper) THEN PRINT #0, "Error reading AX 1 alarm"
    WA(100)
ENDIF

VR(axisstatus_transfer)=AXISSTATUS AXIS(ax_transfer)
IF VR(axisstatus_transfer).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_transfer,$2101,1,5,al_rem_err_transfer) THEN PRINT #0, "Error reading AX 2 alarm"
    WA(100)
ENDIF

VR(axisstatus_rewind)=AXISSTATUS AXIS(ax_rewind)
IF VR(axisstatus_rewind).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_rewind,$2101,1,5,al_rem_err_rewind) THEN PRINT #0, "Error reading AX 3 alarm"
    WA(100)
ENDIF

VR(axisstatus_filmfeed)=AXISSTATUS AXIS(ax_filmfeed)
IF VR(axisstatus_filmfeed).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_filmfeed,$2101,1,5,al_rem_err_filmfeed) THEN PRINT #0, "Error reading AX 4 alarm"
    WA(100)
ENDIF

VR(axisstatus_oc)=AXISSTATUS AXIS(ax_oc)
IF VR(axisstatus_oc).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_oc,$2101,1,5,al_rem_err_oc) THEN PRINT #0, "Error reading AX 5 alarm"
    WA(100)
ENDIF

VR(axisstatus_seal)=AXISSTATUS AXIS(ax_seal)
IF VR(axisstatus_seal).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_seal,$2101,1,5,al_rem_err_seal) THEN PRINT #0, "Error reading AX 6 alarm"
    WA(100)
ENDIF

VR(axisstatus_outfeed)=AXISSTATUS AXIS(ax_outfeed)
IF VR(axisstatus_outfeed).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_outfeed,$2101,1,5,al_rem_err_outfeed) THEN PRINT #0, "Error reading AX 7 alarm"
    WA(100)
ENDIF

VR(axisstatus_ff_brake)=AXISSTATUS AXIS(ax_filmfeedbrake)
IF VR(axisstatus_ff_brake).axis_rem_drive_err THEN
    IF NOT CO_READ_AXIS(ax_filmfeedbrake,$2101,1,5,al_rem_err_ff_brake) THEN PRINT #0, "Error reading AX 7 alarm"
    WA(100)
ENDIF

VR(axisstatus_virtual_inf)=AXISSTATUS AXIS(ax_virtual_infeed)
WA(100)

'infeed
VR(mpos_infeed)=MPOS AXIS(ax_infeed)
VR(mspeed_infeed)=MSPEED AXIS(ax_infeed)
VR(drive_torque_infeed)=DRIVE_TORQUE AXIS(ax_infeed)
VR(mtype_infeed)=MTYPE AXIS(ax_infeed)
WA(100)

'stepper
VR(mpos_stepper)=MPOS AXIS(ax_stepper)
VR(mspeed_stepper)=MSPEED AXIS(ax_stepper)
VR(drive_torque_stepper)=DRIVE_TORQUE AXIS(ax_stepper)
VR(mtype_stepper)=MTYPE AXIS(ax_stepper)
WA(100)

'transfer
VR(mpos_transfer)=MPOS AXIS(ax_transfer)
VR(mspeed_transfer)=MSPEED AXIS(ax_transfer)
VR(drive_torque_transfer)=DRIVE_TORQUE AXIS(ax_transfer)
VR(mtype_transfer)=MTYPE AXIS(ax_transfer)
WA(100)

'rewind
VR(mpos_rewind)=MPOS AXIS(ax_rewind)
VR(mspeed_rewind)=MSPEED AXIS(ax_rewind)
VR(drive_torque_rewind)=DRIVE_TORQUE AXIS(ax_rewind)
VR(mtype_rewind)=MTYPE AXIS(ax_rewind)
WA(100)

'filmfeed
VR(mpos_filmfeed)=MPOS AXIS(ax_filmfeed)
VR(mspeed_filmfeed)=MSPEED AXIS(ax_filmfeed)
VR(drive_torque_filmfeed)=DRIVE_TORQUE AXIS(ax_filmfeed)
VR(mtype_filmfeed)=MTYPE AXIS(ax_filmfeed)
WA(100)

'openclose
VR(mpos_oc)=MPOS AXIS(ax_oc)
VR(mspeed_oc)=MSPEED AXIS(ax_oc)
VR(drive_torque_oc)=DRIVE_TORQUE AXIS(ax_oc)
VR(mtype_oc)=MTYPE AXIS(ax_oc)
WA(100)

'seal
VR(mpos_seal)=MPOS AXIS(ax_seal)
VR(mspeed_seal)=MSPEED AXIS(ax_seal)
VR(drive_torque_seal)=DRIVE_TORQUE AXIS(ax_seal)
VR(mtype_seal)=MTYPE AXIS(ax_seal)
WA(100)

'outfeed
VR(mpos_outfeed)=MPOS AXIS(ax_outfeed)
VR(mspeed_outfeed)=MSPEED AXIS(ax_outfeed)
VR(drive_torque_outfeed)=DRIVE_TORQUE AXIS(ax_outfeed)
VR(mtype_outfeed)=MTYPE AXIS(ax_outfeed)
WA(100)

'film feed brake
VR(mpos_ff_brake)=MPOS AXIS(ax_filmfeedbrake)
VR(mspeed_ff_brake)=MSPEED AXIS(ax_filmfeedbrake)
VR(drive_torque_ff_brake)=DRIVE_TORQUE AXIS(ax_filmfeedbrake)
VR(mtype_ff_brake)=MTYPE AXIS(ax_filmfeedbrake)
WA(100)

'virtual infeed
VR(mpos_virtual_inf)=MPOS AXIS(ax_virtual_infeed)
VR(mspeed_virtual_inf)=MSPEED AXIS(ax_virtual_infeed)
VR(mtype_virtual_inf)=MTYPE AXIS(ax_virtual_infeed)
WA(100)

'CONSTANT "axis_enable_ax",4 ' Bit 0..7 -> axis enable AX0..7 WDOG bit15
VR(axis_enable_ax).0= AXIS_ENABLE AXIS(ax_infeed)
VR(axis_enable_ax).1= AXIS_ENABLE AXIS(ax_stepper)
VR(axis_enable_ax).2= AXIS_ENABLE AXIS(ax_transfer)
VR(axis_enable_ax).3= AXIS_ENABLE AXIS(ax_rewind)
VR(axis_enable_ax).4= AXIS_ENABLE AXIS(ax_filmfeed)
VR(axis_enable_ax).5= AXIS_ENABLE AXIS(ax_oc)
VR(axis_enable_ax).6= AXIS_ENABLE AXIS(ax_seal)
VR(axis_enable_ax).7= AXIS_ENABLE AXIS(ax_outfeed)
VR(axis_enable_ax).8= AXIS_ENABLE AXIS(ax_filmfeedbrake)
VR(axis_enable_ax).15= WDOG
WA(100)

'CONSTANT "servo_ax",5 ' Bit 0..7 -> servo AX0..7
VR(servo_ax).0=SERVO AXIS(ax_infeed)
VR(servo_ax).1=SERVO AXIS(ax_stepper)
VR(servo_ax).2=SERVO AXIS(ax_transfer)
VR(servo_ax).3=SERVO AXIS(ax_rewind)
VR(servo_ax).4=SERVO AXIS(ax_filmfeed)
VR(servo_ax).5=SERVO AXIS(ax_oc)
VR(servo_ax).6=SERVO AXIS(ax_seal)
VR(servo_ax).7=SERVO AXIS(ax_outfeed)
VR(servo_ax).8=SERVO AXIS(ax_filmfeedbrake)
WA(100)

ETHERCAT($22, 0, ethercat_state) 'Get ethercat state and put on VR6 ethercat_state
'Read RMS torque % from Seal Drive and save on VR157 "seal_torque_rms"
IF VR(ethercat_state)>0 THEN
    IF NOT CO_READ_AXIS(6,$2108,1,6,seal_torque_rms) THEN PRINT #0, "Error reading Seal RMS torque"
ENDIF
WA(100)

IF VR(brake_res_temp)>450 THEN
    OP(o_resistor_fan_1,ON)
    IF VR(brake_res_temp)>500 THEN OP(o_resistor_fan_2,ON)
ELSE
    IF VR(brake_res_temp)<300 THEN
        OP(o_resistor_fan_1,OFF)
        OP(o_resistor_fan_2,OFF)
    ENDIF
ENDIF
IF VR(cubicle_temp)>300 THEN
    OP(o_fan_cub,ON)
ELSE
    IF VR(cubicle_temp)<200 THEN
        OP(o_fan_cub,OFF)
    ENDIF
ENDIF
WA(100)

'IF (IN(i_previous_mc_ok)=0 AND VR(commands_hmi).hmi_prev_mc_nc=0) THEN
'    VR(alarm).al_prev_mc=1
'ELSE
'    VR(alarm).al_prev_mc=0
'ENDIF

IF (IN(i_printer_error)=1 AND VR(commands_hmi).hmi_printer_al_nc=0)_
        OR (IN(i_printer_error)=0 AND VR(commands_hmi).hmi_printer_al_nc=1)_
        AND (VR(commands_hmi).hmi_printer_al_bypass=0)THEN
    VR(alarm).al_printer=1
ELSE
    VR(alarm).al_printer=0
ENDIF

IF (IN(i_next_mc_ok)=1 AND VR(commands_hmi).hmi_next_mc_nc=0)_
        OR (IN(i_next_mc_ok)=0 AND VR(commands_hmi).hmi_next_mc_nc=1)_
        AND (VR(commands_hmi).hmi_next_mc_bypass=0)THEN
    VR(alarm).al_next_mc=1
ELSE
    VR(alarm).al_next_mc=0
ENDIF

'ppm
IF TICKS<0 THEN
    TICKS=60000
    IF VR(commands_conv).conv_infeed_split_mode=1 THEN
        VR(ppm)=(VR(pack_speed_count)/2)
    ELSE
        VR(ppm)=VR(pack_speed_count)
    ENDIF
    VR(pack_speed_count)=0
ENDIF

IF VR(seal_count)>1000 THEN
    VR(seal_count1)=VR(seal_count1)+1
ENDIF
IF VR(seal_count1)>VR(seal_service_due) THEN
    VR(commands_hmi).hmi_service_due=1
ELSE
    VR(commands_hmi).hmi_service_due=0
ENDIF

'IF IN(i_reset_pb) THEN
'    VR(alarm).al_min_pack=0 ' Reset Min Pack Alarm
'    VR(alarm).al_reg_film=0 ' Reg Film Error
'ENDIF

'**are these required? reset elsewhere
WA(10)
'op_status48to63=READ_OP(48,63) 'Read Outputs to VR(178)

GOTO loop
