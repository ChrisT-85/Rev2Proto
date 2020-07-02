
'I/O

'MC4N
i_infeed_sensor=0 'IN 0
i_reg_film_sensor=1 'IN 1
i_trf_in_limit=2 'IN 2
i_seal_home_sensor=3 'IN 3
i_jaws_home_sensor=4 'IN 4
'i_conveyor_stop_sensor=5 'IN 5
i_pack_crush_sensor=6 'IN 6
'i_spare_7=7 'IN 7

'io_spare_8=8 'I/O 8
'io_spare_9=9 'I/O 9
o_printer_signal=10 'I/O 10
'o_brake_ssr=11 'I/O 11
o_infeed_sen_teach=12 'I/O 12
o_flashing_reset=13 'I/O 13
o_magnets_ssr=14 'I/O 14
o_heater_contactor=15 'I/O 15

'P372 Input Flexslice (1) 16-31
i_start_pb=16 'IN 0
i_stop_pb=17 'IN 1
i_reset_pb=18 'IN 2
i_estop_outfeed=19 'IN 3
i_guard_frt_lf=20 'IN 4
i_guard_frt_rg=21 'IN 5
i_guard_rear_lf=22 'IN 6
i_guard_rear_rg=23 'IN 7

i_estop_outfeed1=24 'IN 8
i_guard_outfeed_drop_front=25 'IN 9
i_guard_outfeed_drop_rear=26 'IN 10
i_guard_infeed_1=27 'IN 11
i_guard_infeed_2=28 'IN 12
i_guard_infeed_drop_front=29 'IN 13
i_guard_infeed_drop_rear=30 'IN 14
'i_conv_lifeline=31 'IN 15

'P372 Input Flexslice (2) 32-47
'i_tool_load_infeed=32 'IN 0
'i_tool_load_outfeed=33 'IN 1
i_safety_infeed=34 'IN 2
i_safety_general=35 'IN 3
i_safety_fill_conv=36 'IN 4
i_next_mc_ok=37 'IN 5
i_printer_error=38 'IN 6
i_seal_limit_sw=39 'IN 7

i_trf_out_limit=40 'IN 8
i_gas_pressure_sw=41 'IN 9
'i_tool_load_slide_infeed=42 'IN 10
'i_tool_load_slide_outfeed=43 'IN 11
i_labeler_alarm=44 'IN 12
'i_spare_45=45 'IN 13
'i_guards_conveyor=46 'IN 14
i_previous_machine_healthy=47 'IN 15

'P371 Output Flexslice (1) 16 31
o_resistor_fan_1=16 'OUT 0
o_resistor_fan_2=17 'OUT 1
o_gas_isol1=18 'OUT 2 ' Splitter P1
o_gas_isol2=19 'OUT 3 ' Splitter P2
o_gas_valve1=20 'OUT 4 ' Splitter P3
o_gas_valve2=21 'OUT 5 ' Splitter P4
o_fan_cub=22 'OUT 6
'spare=55 'OUT 7

o_mc_running=24 'OUT 8
o_mc_ok=25 'OUT 9
o_fill_cnv_running=26 'OUT 10
o_beacon_green=27 'OUT 11
o_beacon_amber=28 'OUT 12
o_vac_pump_relay=29 'OUT 13
'o_spare=62 'OUT 14
o_beacon_red=31 'OUT 15

io_vitual_machine_run=200

