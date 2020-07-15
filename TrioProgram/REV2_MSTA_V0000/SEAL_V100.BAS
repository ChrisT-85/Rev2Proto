BASE(6)
MERGE=0
OP(o_magnets_ssr,OFF)
VR(commands_seal).seal_pause=0
crush_count=0

start:
WAIT UNTIL MPOS<4000
torque=0
seal_start=0
seal_cycle=0
WAIT UNTIL seal_start=1
seal_cycle=1
seal_pause=0
crush_count=0

TRIGGER
pack_crush_end_jump:
SPEED=seal_speed*1000
ACCEL=seal_acc*1000
DECEL=seal_dec*1000

'cushion eject UP
IF seal_eject_cushion_up=1 THEN
    SPEED AXIS(6)=seal_speed*1000
    MOVEABS(seal_eject_pos_bottom*10) AXIS(6)
    WA(20)

    REPEAT
        IF -DRIVE_TORQUE>torque THEN torque=-DRIVE_TORQUE

        'Pack Crush
        IF pack_crush_on_off=1 AND crush_count<2 THEN
            IF IN(i_pack_crush_sensor) AND MPOS AXIS(6)<(seal_crush_pos*10) THEN
                DECEL=18000000
                CANCEL(2)
                PRINT #0, "Pack Crush: seal_eject_cushion_up"
                PRINT #0, "Pack Crush: Dist = ";(MPOS/264)
                GOTO pack_block_routine
            ENDIF
        ENDIF
    UNTIL MPOS AXIS(6)>(seal_eject_pos_bottom/3)*10 AND MSPEED AXIS(6)<=(seal_eject_speed*1000)
ENDIF

'cusion seal UP
IF seal_cusion_up=1 THEN
    MOVEMODIFY(seal_compress_pos*10) AXIS(6)
    SPEED AXIS(6)=seal_speed*1000
    WA(20)
    REPEAT
        IF -DRIVE_TORQUE>torque THEN torque=-DRIVE_TORQUE

        'Pack Crush
        IF pack_crush_on_off=1 AND crush_count<2 THEN
            IF IN(i_pack_crush_sensor) AND MPOS AXIS(6)<(seal_crush_pos*10) THEN
                DECEL=18000000
                CANCEL(2)
                PRINT #0, "Pack Crush: seal_cusion_up"
                PRINT #0, "Pack Crush: Dist = ";(MPOS/264)
                GOTO pack_block_routine
            ENDIF
        ENDIF
    UNTIL MPOS AXIS(6)>((seal_compress_pos/3)*10)*2 AND MSPEED AXIS(6)<=(seal_compress_speed*1000)
    SPEED AXIS(6)=seal_compress_speed*1000
ENDIF

MOVEMODIFY(seal_up_pos*10) AXIS(6)
WA(20)

REPEAT
    IF -DRIVE_TORQUE>torque THEN torque=-DRIVE_TORQUE
    'Pack Crush
    IF pack_crush_on_off=1 AND crush_count<2 THEN
        IF IN(i_pack_crush_sensor) AND MPOS AXIS(6)<(seal_crush_pos*10) THEN
            DECEL=18000000
            CANCEL(2)
            PRINT #0, "Pack Crush: no cushion"
            PRINT #0, "Pack Crush: Dist = ";(MPOS/264)
            GOTO pack_block_routine
        ENDIF
    ENDIF
    IF READ_OP(o_magnets_ssr)=OFF AND MPOS AXIS(6)>=(seal_up1_pos*10) AND seal_time>400 THEN OP(o_magnets_ssr,ON)
UNTIL IDLE AXIS(6)

seal_pause=0
seal_pause_aux=0
crush_count=0
seal_max_torque=torque
torque=0

MOVEABS(seal_up1_pos*10)
IF seal_time>400 THEN
    WA(seal_time-400)
ELSE
    WA(seal_time)
ENDIF
seal_hold_torque=-DRIVE_TORQUE

IF seal_time>400 THEN
    MOVEABS(seal_up2_pos*10) AXIS(6)
    WAIT UNTIL MPOS AXIS(6)>(seal_up2_pos*10)-260
ENDIF
OP(o_magnets_ssr,OFF)

IF seal_eject_cushion_down=1 THEN
    IF seal_cusion_down=1 AND seal_eject_pos_bottom>seal_decompress_pos THEN
        'PRINT #0, "Option 1"
        SPEED AXIS(6)=seal_decompress_speed*1000
        MOVEABS(276*5) AXIS(6)'Move Seal up 5mm
        WAIT UNTIL MPOS AXIS(6)<=(seal_decompress_pos*10)
        SPEED AXIS(6)=seal_speed*1000
        timing_seal_end=1

    ELSEIF seal_cusion_down=1 AND seal_eject_pos_bottom<seal_decompress_pos THEN
        'PRINT #0, "Option 2"
        SPEED AXIS(6)=seal_decompress_speed*1000
        MOVEABS(seal_eject_pos_bottom*10) AXIS(6)
        WAIT UNTIL MPOS AXIS(6)<=(seal_decompress_pos*10)
        SPEED AXIS(6)=(seal_speed*1000)/2
        rem_down_eject=(seal_up1_pos-((seal_up1_pos-seal_eject_pos_bottom)/2))*10
        'PRINT #0, "Option 2 - ";rem_down_eject
        WAIT UNTIL IDLE AXIS(6)

        MOVEMODIFY(276*5) AXIS(6)'Move Seal up 5mm
        timing_seal_end=1

    ELSEIF seal_cusion_down=0 THEN
        'PRINT #0, "Option 3"
        SPEED AXIS(6)=seal_speed*1000
        MOVEABS(seal_eject_pos_bottom*10) AXIS(6)
        WAIT UNTIL REMAIN AXIS(6)<((seal_eject_pos_bottom/3)*10)*2 AND MSPEED<=(seal_eject_speed*1000)

        MOVEMODIFY(276*5) AXIS(6)'Move Seal up 5mm
        timing_seal_end=1
    ENDIF
ELSE
    IF seal_cusion_down=1 THEN
        'PRINT #0, "Option 4"
        SPEED AXIS(6)=seal_decompress_speed*1000
        MOVEABS(276*5) AXIS(6)'Move Seal up 5mm
        WAIT UNTIL MPOS AXIS(6)<=(seal_decompress_pos*10)
        SPEED AXIS(6)=seal_speed*1000
        timing_seal_end=1
    ELSE
        'PRINT #0, "Option 5"
        SPEED AXIS(6)=seal_speed*1000
        MOVEABS(276*5) AXIS(6)'Move Seal up 5mm
        timing_seal_end=1
    ENDIF
ENDIF

SPEED AXIS(6)=seal_speed*1000
WAIT UNTIL MPOS AXIS(6)<36000
IF film_commands.2 THEN seal_start=0 'Printer speed save

GOTO start

pack_block_routine:
CANCEL(2)
WAIT IDLE
seal_pause=1
crush_count=crush_count+1

MOVEABS(0) AXIS(6)
WAIT UNTIL IDLE AXIS(6)

MOVEABS(seal_crush_pos*10)
WAIT UNTIL MPOS AXIS(6)>=(seal_crush_pos*10) OR IN(i_pack_crush_sensor)=ON

IF IN(i_pack_crush_sensor)=ON THEN
    CANCEL(2)
    WAIT IDLE
    PRINT #0, "Crush Stop Dist = ";(MPOS/264)
    MOVEABS(0) AXIS(6)
    WAIT UNTIL IDLE AXIS(6)
ELSE
    GOTO pack_crush_end_jump
ENDIF

IF crush_count>1 THEN
    seal_pause_aux=1
    WAIT UNTIL seal_pause=0
ENDIF

PRINT #0, "Pack Crush: END"
GOTO pack_crush_end_jump

seal_pause=0
crush_count=0
