
CONSTANT ' Clear all defined constants

'I/O
'=========================================

'MC4N
CONSTANT "i_infeed_sensor",0 '      IN 0
CONSTANT "i_reg_film_sensor",1 '    IN 1
CONSTANT "i_trf_in_limit",2 '       IN 2
CONSTANT "i_seal_home_sensor",3 '   IN 3
CONSTANT "i_jaws_home_sensor",4 '   IN 4
CONSTANT "i_base_tool_lock_sens",5' IN 5
CONSTANT "i_pack_crush_sensor",6 '  IN 6
'CONSTANT "i_spare_7",7 '           IN 7

'CONSTANT "io_spare_8",8 '          I/O 8
'CONSTANT "io_spare_9",9 '          I/O 9
'CONSTANT "io_spare_10",10 '        I/O 10
CONSTANT "o_printer_signal",11 '    I/O 11
CONSTANT "o_infeed_sen_teach",12 '  I/O 12
CONSTANT "o_flashing_reset",13 '    I/O 13
CONSTANT "o_magnets_ssr",14 '       I/O 14
CONSTANT "o_heater_contactor",15 '  I/O 15

'P372 Input Flexslice (1) 16-31
CONSTANT "i_start_pb",16 '          IN 0
CONSTANT "i_stop_pb",17 '           IN 1
CONSTANT "i_reset_pb",18 '          IN 2
CONSTANT "i_estop_rem_out",19 '     IN 3
CONSTANT "i_guard_frt_lf",20 '      IN 4
CONSTANT "i_guard_frt_rg",21 '      IN 5
CONSTANT "i_guard_rear_lf",22 '     IN 6
CONSTANT "i_guard_rear_rg",23 '     IN 7

CONSTANT "i_estop_rear_if",24 '     IN 8
CONSTANT "i_guard_out_drop_fr",25 ' IN 9
CONSTANT "i_guard_out_drop_rear",26'IN 10
CONSTANT "i_guard_in_1",27 '        IN 11
CONSTANT "i_guard_in_2",28 '        IN 12
CONSTANT "i_guard_in_drop_fr",29 '  IN 13
CONSTANT "i_guard_in_drop_rear",30' IN 14
CONSTANT "i_estop_rem_in",31 '      IN 15

'P372 Input Flexslice (2) 32-47
CONSTANT "i_next_mc_ok",32 '        IN 0
CONSTANT "i_previous_mc_ok",33 '    IN 1
CONSTANT "i_safety_infeed",34 '     IN 2
CONSTANT "i_safety_general",35 '    IN 3
CONSTANT "i_seal_limit_sw",36 '     IN 4
CONSTANT "i_trf_out_limit",37 '     IN 5
CONSTANT "i_printer_error",38 '     IN 6
CONSTANT "i_gas_pressure_sw",39 '   IN 7

'CONSTANT "i_spare40",40 '          IN 8
'CONSTANT "i_spare41",41 '          IN 9
'CONSTANT "i_spare42",42 '          IN 10
'CONSTANT "i_spare43",43 '          IN 11
'CONSTANT "i_spare44",44 '          IN 12
'CONSTANT "i_spare45",45 '          IN 13
'CONSTANT "i_spare46",46 '          IN 14
'CONSTANT "i_spare47",47 '          IN 15

'P371 Output Flexslice (1) 16 31
CONSTANT "o_mc_running",16 '        OUT 0
CONSTANT "o_mc_ok",17 '             OUT 1
CONSTANT "o_start_pb_led",18 '      OUT 2
CONSTANT "o_stop_pb_led",19 '       OUT 3
CONSTANT "o_resistor_fan_1",20 '    OUT 4
CONSTANT "o_resistor_fan_2",21 '    OUT 5
CONSTANT "o_fan_cub",22 '           OUT 6
'CONSTANT "o_spare23",23 '          OUT 7

'CONSTANT "o_spare24"=24 '          OUT 8
'CONSTANT "o_spare25"=25 '          OUT 9
'CONSTANT "o_spare26"=26 '          OUT 10
'CONSTANT "o_spare27"=27 '          OUT 11
'CONSTANT "o_spare28"=28 '          OUT 12
'CONSTANT "o_spare29"=29 '          OUT 13
'CONSTANT "o_spare30"=62 '          OUT 14
'CONSTANT "o_spare31"=31 '          OUT 15

' Servo Axis
'==========================================
CONSTANT "ax_infeed",0
CONSTANT "ax_stepper",1
CONSTANT "ax_transfer",2
CONSTANT "ax_rewind",3
CONSTANT "ax_filmfeed",4
CONSTANT "ax_jaws",5
CONSTANT "ax_seal",6
CONSTANT "ax_outfeed",7
CONSTANT "ax_filmFeedBrake",8

CONSTANT "ax_virtual_Infeed",15
' axis status bits
CONSTANT "axis_speed_limit_active",0 '   bit0 - Speed Limit Active
CONSTANT "axis_fol_err_warn",1 '         bit1 - Following error warning range
CONSTANT "axis_comms_err",2 '            bit2 - Comms Error to remote drive
CONSTANT "axis_rem_drive_err",3 '        bit3 - Remote drive error
CONSTANT "axis_in_fwd_hard_limit",4 '    bit4 - In forward hardware limit
CONSTANT "axis_in_rev_hard_limit",5'     bit5 - In reverse hardware limit
CONSTANT "axis_datum_in_progress",6 '    bit6 - datuming in progress
CONSTANT "axis_feedhold_active",7 '      bit7 - freehold active
CONSTANT "axis_following_err",8 '        bit8 - following error exceeds limit
CONSTANT "axis_FS_limit_active",9 '      bit9 - FS limit active
CONSTANT "axis_RS_limit_active",10 '     bit10 - RS limit active
'==========================================

'alarms
'==========================================

CONSTANT "alarm",0 '
'--------------------------------- bit constants for VR0
CONSTANT "al_max_pack",0 '         bit0 - Al. Max Pack
CONSTANT "al_min_pack",1 '         bit1 - AL Min Pack
CONSTANT "al_trf_sync",2 '         bit2 - al transfer SYNC error
CONSTANT "al_filmSnap",3 '         bit3 - al film snap
CONSTANT "al_gas_pressure",4 '     bit4 - gas pressure alarm
CONSTANT "al_reg_film",5'          bit5 - reg film error
CONSTANT "al_vac_err",6 '          bit6 - cannot obtain vac error
CONSTANT "al_gas_err",7 '          bit7 - cannot obtain gas error
CONSTANT "al_seal_limit",8 '       bit8 - seal limit error
CONSTANT "al_prev_mc",9 '          bit9 - Previous Machine Error (warning)
CONSTANT "al_printer",10 '         bit10 - Printer Alarm
CONSTANT "al_next_mc",11 '         bit11 - Next Machine Ok
'                                  spare bits 9-14
CONSTANT "al_any_alarm",15 '       bit15- any alarm hmi
'----------------------------------------------------------------

CONSTANT "alarm_max_torque",1 ' Bit 0 -> Alarm AX0 ... Bit 15 -> Alarm AX15

CONSTANT "commands_hmi",2
'---------------------------------- bit constants for commands_hmi
CONSTANT "hmi_clockpulse",0 '       bit0 - clockpulse
CONSTANT "hmi_batch_end",1 '        bit1 - batch_end'
CONSTANT "hmi_passive_conv_on",2 '  bit2 - passive conveyor on
CONSTANT "hmi_tool_bypass",3 '      bit3 - tool_bypass
CONSTANT "hmi_prev_mc_bypass",4 '   bit4 - prev_mc_bypass
CONSTANT "hmi_prev_mc_nc",5 '        bit5 - previous machine alarm NC
CONSTANT "hmi_next_mc_bypass",6 '   bit6 - next_mc_bypass
CONSTANT "hmi_next_mc_nc",7 '       bit7 - next machine alarm NC
CONSTANT "hmi_printer_on",8 '       bit8 - printer_on
CONSTANT "hmi_printer_al_bypass",9 'bit9 - printer alarm bypass
CONSTANT "hmi_printer_al_nc",10 '   bit10 - printer_alarm NC
'----------------------------------------------------------------

CONSTANT "commands_mc",3
'---------------------------------- bit constants for commands_mc
CONSTANT "mc_batch_end_flag",0 '       bit0 - batch end flag
CONSTANT "mc_running",1 '       bit1 - mc_running
'----------------------------------------------------------------

'Machine
'==========================================
CONSTANT "axis_enable_ax",4 ' Bit 0..7 -> axis enable AX0..7 WDOG bit15
CONSTANT "servo_ax",5 ' Bit 0..7 -> servo AX0..7
CONSTANT "ethercat_state",6
CONSTANT "cubicle_temp", 7
CONSTANT "batch_count",8
CONSTANT "n_impressions",9
CONSTANT "PPM",10 ' was 108 for data?

''infeed / stepper
'==========================================
CONSTANT "commands_conv",11
'---------------------------------- bit constants for commands_film
CONSTANT "infeed_split_mode",0 '   bit0 - infeed split mode
CONSTANT "outfeed_pause",1 '       bit1 - outfeed pause
'----------------------------------------------------------------

'ax_infeed 0----------------------------------

CONSTANT "axisstatus_infeed",12
CONSTANT "al_rem_err_infeed",13
CONSTANT "mpos_infeed",14
CONSTANT "mspeed_infeed",15
CONSTANT "drive_torque_infeed",16
CONSTANT "mtype_infeed",17

'ax_stepper 1----------------------------------

CONSTANT "axisstatus_stepper",18
CONSTANT "al_rem_err_stepper",19
CONSTANT "mpos_stepper",20
CONSTANT "mspeed_stepper",21
CONSTANT "drive_torque_stepper",22
CONSTANT "mtype_stepper",23

'ax_virtual_Infeed 15--------------------------

CONSTANT "axisstatus_virtual_inf",24
CONSTANT "mpos_virtual_inf",25
CONSTANT "mspeed_virtual_inf",26
CONSTANT "mtype_virtual_inf",27

'CONSTANT "stp_increment",28
'CONSTANT "stp_final_increment",29
'CONSTANT "min_pack_size",30
'CONSTANT "max_pack_size",31
'CONSTANT "infeed_speed",32
'CONSTANT "infeed_acc",33
'CONSTANT "infeed_dec",34
'CONSTANT "infeed_pack_count",35
'CONSTANT "slipt_wait_pos",36


'Outfeed
'==========================================
'ax_outfeed 7
CONSTANT "axisstatus_outfeed",40
CONSTANT "al_rem_err_outfeed",41
CONSTANT "mpos_outfeed",42
CONSTANT "mspeed_outfeed",43
CONSTANT "drive_torque_outfeed",44
CONSTANT "mtype_outfeed",45
CONSTANT "outfeed_speed",46



'film feed
'==========================================
CONSTANT "commands_film",50
'---------------------------------- bit constants for commands_film
CONSTANT "film_start",0 '           bit0 - start film
CONSTANT "film_reg_on",1 '          bit1 - reg film on
CONSTANT "film_print_speed_save",2 'bit2 - Printer Speed Save
CONSTANT "film_on_transfer",3 '     bit3 - film on Transfer
'----------------------------------------------------------------

'ax_rewind 3----------------------------------
CONSTANT "axisstatus_rewind",51
CONSTANT "al_rem_err_rewind",52
CONSTANT "mpos_rewind",53
CONSTANT "mspeed_rewind",54
CONSTANT "drive_torque_rewind",55
CONSTANT "mtype_rewind",56

'ax_filmfeed 4--------------------------------
CONSTANT "axisstatus_filmfeed",57
CONSTANT "al_rem_err_filmfeed",58
CONSTANT "mpos_filmfeed",59
CONSTANT "mspeed_filmfeed",60
CONSTANT "drive_torque_filmfeed",61
CONSTANT "mtype_filmfeed",62

'ax_filmFeedBrake 8---------------------------
CONSTANT "axisstatus_ff_brake",63
CONSTANT "al_rem_err_ff_brake",64
CONSTANT "mpos_ff_brake",65
CONSTANT "mspeed_ff_brake",66
CONSTANT "drive_torque_ff_brake",67
CONSTANT "mtype_ff_brake",68

CONSTANT "film_length",69
CONSTANT "film_speed",70
CONSTANT "film_acc",71
CONSTANT "film_dec",72
CONSTANT "rw_stall_torque",73
CONSTANT "rw_acc_torque",74
CONSTANT "rw_run_torque",75
CONSTANT "film_travel_aft_mark",75
CONSTANT "film_brake_min_torque",76
CONSTANT "film_brake_max_torque",77
CONSTANT "min_diameter",78
CONSTANT "max_diameter",79
CONSTANT "diameter",80
'CONSTANT "auto_reel_tension_on",315
'CONSTANT "reel_brake_force",160

''transfer
'==========================================
CONSTANT "commands_trans",90
'---------------------------------- bit constants for commands_mc
CONSTANT "trans_not_ready",0 '           bit0 - start film
CONSTANT "trans_pos_set_flag",1 '          bit1 - reg film on
CONSTANT "film_print_speed_save",2 'bit2 - Printer Speed Save
CONSTANT "film_on_transfer",3 '     bit3 - film on Transfer
'----------------------------------------------------------------

'ax_transfer 2----------------------------------
CONSTANT "axisstatus_transfer",91
CONSTANT "al_rem_err_transfer",92
CONSTANT "mpos_transfer",93
CONSTANT "mspeed_transfer",94
CONSTANT "drive_torque_transfer",95
CONSTANT "mtype_transfer",96

'CONSTANT "pack_speed_count",97
CONSTANT "trf_tool_pos"98
CONSTANT "trf_speed",99
CONSTANT "trf_acc",100
CONSTANT "trf_dec"101
CONSTANT "trf_sshape",101
'CONSTANT "trf_pick_up_speed",102
'CONSTANT "transfer_offset",103
'CONSTANT "extra_pack_infeed",104
'CONSTANT "transfer_start",105
'CONSTANT "trf_position_set_flag",106
'CONSTANT "stp_mid_increment",107
'CONSTANT "gbl_trf_start",108
CONSTANT "brake_res_temp",110


''jaws
'==========================================
'ax_jaws 5---------------------------------
CONSTANT "axisstatus_jaws",111
CONSTANT "al_rem_err_jaws",112
CONSTANT "mpos_jaws",113
CONSTANT "mspeed_jaws",114
CONSTANT "drive_torque_jaws",115
CONSTANT "mtype_jaws",116

CONSTANT "oc_close_pos",117 '35
CONSTANT "oc_open_pos",118'36
CONSTANT "oc_mid_pos",119'37
CONSTANT "oc_speed",120'38
CONSTANT "oc_acc",121'39
CONSTANT "oc_dec",122'40
CONSTANT "oc_sshape",123'41


''seal
'==========================================
CONSTANT "commands_seal",130
'---------------------------------- bit constants for commands_seal
CONSTANT "seal_bypass",0 '          bit0 - seal_bypass
CONSTANT "seal_start",1 '           bit1 - start seal
'----------------------------------------------------------------
'ax_seal 6---------------------------------
CONSTANT "axisstatus_seal",131
CONSTANT "al_rem_err_seal",132
CONSTANT "mpos_seal",133
CONSTANT "mspeed_seal",134
CONSTANT "drive_torque_seal",135
CONSTANT "mtype_seal",136

'CONSTANT "default_Temperature",137
CONSTANT "seal_torque_rms",157

'CONSTANT "seal_up_pos", 42
'CONSTANT "seal_up1_pos",43
'CONSTANT "seal_up2_pos",44
'CONSTANT "seal_gas_pos",45
'CONSTANT "mapf_on" ,46
'CONSTANT "gas_time" ,47
'CONSTANT "seal_acc" ,48
'CONSTANT "seal_dec" ,49
'CONSTANT "seal_dec_mapf", 50
'CONSTANT "seal_speed" ,51
'CONSTANT "seal_time",109

'CONSTANT "seal_pause",55
'CONSTANT "pack_crush_on_off", 56
'CONSTANT "seal_crush_pos", 57
'CONSTANT "seal_cycle",58

CONSTANT "seal_home_offset",158
'CONSTANT "seal_compress_speed",330
'CONSTANT "seal_eject_pos_top",331
'CONSTANT "seal_eject_pos_bottom",332
'CONSTANT "seal_eject_speed",333
'CONSTANT "quiet_mode",334
'
'CONSTANT "seal_decompress_speed",336
'CONSTANT "seal_eject_cushion_up",337
'CONSTANT "seal_eject_cushion_down",338
'CONSTANT "seal_cusion_up",339
'CONSTANT "seal_cusion_down",340
'CONSTANT "crush_count",341
'CONSTANT "seal_compress_pos",342
'CONSTANT "seal_decompress_pos",343
'CONSTANT "seal_pause_aux",344

'CONSTANT "seal_max_torque",105
'CONSTANT "seal_hold_torque",106
'CONSTANT "seal_max_torque1",107
CONSTANT "seal_count",163
CONSTANT "seal_count1",164

'
''CONSTANT "pack_crush_on_off",230



'CONSTANT "op_status48to63",178
'CONSTANT "gas_setting",179
'CONSTANT "vac_setting",180
'CONSTANT "cure_time",181
'CONSTANT "atmosphere_hmi",182
'CONSTANT "hmi_reading",183

'CONSTANT "ain_0" ,197
'CONSTANT "ain_1", 198
'
'CONSTANT "progbar" ,209
'CONSTANT "progbarreset" ,210
'
'CONSTANT"passive_pack_count",225

'CONSTANT "Speed_Control_1",260
'CONSTANT "Speed_Control_2",261
'CONSTANT "Speed_Control_3",262
'CONSTANT "Speed_Control_4"263

'CONSTANT "axisstatus_ax9",118
'CONSTANT "mpos_ax9",126
'CONSTANT "mspeed_ax9",134'
'CONSTANT "drive_torque_ax9",142
'CONSTANT "mtype_ax9"152

''DataConnect
'==========================================
''CONSTANT "PPM",108
'CONSTANT "Product_code",501
'CONSTANT "data_machine_status",502
'CONSTANT "Shift_number",503
'CONSTANT "Products_Used", 506
'CONSTANT "Product_Index",507
'CONSTANT "Act_prd_count",508
'CONSTANT "Act_prd_run",509
'CONSTANT "Act_prd_av_sp",510
'CONSTANT "Act_prd_max_sp",511
'CONSTANT "Clear_Data",512
'CONSTANT "AuditTrail_Run",513
'CONSTANT "AlarmHist_Run",514

RUN "MAIN",1

'processes
'
'1  - MAIN *
'2  - HMI *
'3  - GENERATE DATA *
'4  - MAX TORQUES *
'5  - INFEED MAIN *
'6  - TRANSFER *
'7  - SEAL *
'8  - REWIND TOURQUE *
'9  - FILM FEED *
'10 - MIN_MAX *
'11 - TIMER *
'12 -
'13 -
'14 -
'15 - AUTO_TENSION *
'16 -
'17 -
'18 -
'19 -
'20 - INFEED REGIST *
