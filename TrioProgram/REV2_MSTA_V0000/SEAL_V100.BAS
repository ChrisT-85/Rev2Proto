BASE(ax_seal)
MERGE=0
OP(o_magnets_ssr,OFF)
VR(commands_seal).seal_pause=0
VR(seal_crush_count)=0
local_gas_complete=0
local_eject_up_flag=0
local_seal_cushion_up_flag=0
local_seal_cushion_down_flag=0
local_eject_cushion_down_flag=0

debug_seal=debug_seal

start:
WAIT UNTIL MPOS AXIS(ax_seal)<4000
local_torque=0
VR(commands_seal).seal_start=0
VR(commands_seal).seal_cycle=0
VR(commands_seal).seal_pause=0

WAIT UNTIL VR(commands_seal).seal_start=1
VR(commands_seal).seal_cycle=1
VR(commands_seal).seal_pause=0
VR(seal_crush_count)=0

pack_crush_end_jump:
SPEED AXIS(ax_seal)=(VR(seal_speed)*1000)
ACCEL AXIS(ax_seal)=(VR(seal_acc)*1000)
DECEL AXIS(ax_seal)=(VR(seal_dec)*1000)


IF VR(commands_seal).seal_eject_cushion_up=1 THEN
    MOVEABS(VR(seal_eject_pos_bottom)*10) AXIS(ax_seal)
    IF debug_seal=1 THEN PRINT #7,"Move Cushion Up Pos "
    WA(20)

    REPEAT
        IF -DRIVE_TORQUE AXIS(ax_seal)>local_torque THEN local_torque=-DRIVE_TORQUE AXIS(ax_seal)

        'Pack Crush
        IF VR(commands_seal).seal_pack_crush_on=1 AND VR(seal_crush_count)<2 THEN
            IF IN(i_pack_crush_sensor) AND MPOS AXIS(ax_seal)<(VR(seal_crush_pos)*10) THEN
                DECEL=18000000
                CANCEL(2)
                PRINT #0, "Pack Crush: seal_eject_cushion_up"
                PRINT #0, "Pack Crush: Dist = ";(MPOS/264)
                GOTO pack_block_routine
            ENDIF
        ENDIF
    UNTIL MPOS AXIS(ax_seal)>(VR(seal_eject_pos_bottom)/3)*10 _
        AND MSPEED AXIS(ax_seal)<=(VR(seal_eject_speed)*1000)
ENDIF

'cusion seal UP
IF VR(commands_seal).seal_cusion_up=1 THEN
    MOVEMODIFY(VR(seal_compress_pos)*10) AXIS(ax_seal)
    SPEED AXIS(ax_seal)=VR(seal_speed)*1000
    WA(20)
    REPEAT
        IF -DRIVE_TORQUE>local_torque THEN local_torque=-DRIVE_TORQUE
        'Pack Crush
        IF VR(commands_seal).seal_pack_crush_on=1 AND VR(seal_crush_count)<2 THEN
            IF IN(i_pack_crush_sensor) AND MPOS AXIS(ax_seal)<(VR(seal_crush_pos)*10) THEN
                DECEL=18000000
                CANCEL(2)
                PRINT #0, "Pack Crush: seal_eject_cushion_up"
                PRINT #0, "Pack Crush: Dist = ";(MPOS/264)
                GOTO pack_block_routine
            ENDIF
        ENDIF
    UNTIL MPOS AXIS(ax_seal)>((VR(seal_compress_pos)/3)*10)*2 _
        AND MSPEED AXIS(ax_seal)<=(VR(seal_compress_speed)*1000)
    SPEED AXIS(ax_seal)=VR(seal_compress_speed)*1000
ENDIF

MOVEMODIFY(VR(seal_up_pos)*10) AXIS(ax_seal)
WA(20)

REPEAT
    IF -DRIVE_TORQUE>local_torque THEN local_torque=-DRIVE_TORQUE
    'Pack Crush
    IF VR(commands_seal).seal_pack_crush_on=1 AND VR(seal_crush_count)<2 THEN
        IF IN(i_pack_crush_sensor) AND MPOS AXIS(ax_seal)<(VR(seal_crush_pos)*10) THEN
            DECEL=18000000
            CANCEL(2)
            PRINT #0, "Pack Crush: seal_eject_cushion_up"
            PRINT #0, "Pack Crush: Dist = ";(MPOS/264)
            GOTO pack_block_routine
        ENDIF
    ENDIF
    IF READ_OP(o_magnets_ssr)=OFF AND MPOS AXIS(ax_seal)>=(VR(seal_hold_pos)*10) _
            AND VR(seal_time)>400 THEN
        OP(o_magnets_ssr,ON)
    ENDIF

UNTIL IDLE AXIS(ax_seal)

VR(commands_seal).seal_pause=0
VR(commands_seal).seal_pause_aux=0
VR(seal_crush_count)=0
VR(seal_max_torque)=local_torque
local_torque=0

MOVEABS(VR(seal_hold_pos)*10)
IF VR(seal_time)>400 THEN
    WA(seal_time-400)
ELSE
    WA(seal_time)
ENDIF
VR(seal_hold_torque)=-DRIVE_TORQUE

IF VR(seal_time)>400 THEN
    MOVEABS(VR(seal_end_pos)*10) AXIS(6)
    WAIT UNTIL MPOS AXIS(6)>(VR(seal_end_pos)*10)-260
ENDIF
OP(o_magnets_ssr,OFF)

IF VR(commands_seal).seal_eject_cushion_down=1 THEN
    IF VR(commands_seal).seal_eject_cushion_down=1 _
            AND VR(seal_eject_pos_bottom)>VR(seal_decompress_pos) THEN
        'PRINT #0, "Option 1"
        SPEED AXIS(ax_seal)=VR(seal_decompress_speed)*1000
        MOVEABS(276*5) AXIS(ax_seal)'Move Seal to 5mm
        WAIT UNTIL MPOS AXIS(ax_seal)<=(VR(seal_decompress_pos)*10)
        SPEED AXIS(ax_seal)=VR(seal_speed)*1000
        timing_seal_end=1

    ELSEIF VR(commands_seal).seal_eject_cushion_down=1 _
            AND VR(seal_eject_pos_bottom)<VR(seal_decompress_pos) THEN
        'PRINT #0, "Option 2"
        SPEED AXIS(ax_seal)=VR(seal_decompress_speed)*1000
        MOVEABS(VR(seal_eject_pos_bottom)*10) AXIS(ax_seal)
        WAIT UNTIL MPOS AXIS(ax_seal)<=(VR(seal_decompress_pos)*10)
        SPEED AXIS(ax_seal)=(VR(seal_speed)*1000)/2
        local_rem_down_eject=(seal_up1_pos-((seal_up1_pos-seal_eject_pos_bottom)/2))*10
        'PRINT #0, "Option 2 - ";local_rem_down_eject
        WAIT UNTIL IDLE AXIS(ax_seal)

        MOVEMODIFY(276*5) AXIS(ax_seal)'Move Seal to 5mm
        timing_seal_end=1

    ELSEIF VR(commands_seal).seal_cushion_down=0 THEN
        'PRINT #0, "Option 3"
        SPEED AXIS(ax_seal)=VR(seal_speed)*1000
        MOVEABS(VR(seal_eject_pos_bottom)*10) AXIS(ax_seal)
        WAIT UNTIL REMAIN AXIS(ax_seal)<((VR(seal_eject_pos_bottom)/3)*10)*2 _
            AND MSPEED<=(VR(seal_eject_speed)*1000)

        MOVEMODIFY(276*5) AXIS(6)'Move Seal to 5mm
        timing_seal_end=1
    ENDIF
ELSE
    IF VR(commands_seal).seal_cushion_down=1 THEN
        'PRINT #0, "Option 4"
        SPEED AXIS(ax_seal)=VR(seal_decompress_speed)*1000
        MOVEABS(276*5) AXIS(ax_seal)'Move Seal to 5mm
        WAIT UNTIL MPOS AXIS(ax_seal)<=(VR(seal_decompress_pos)*10)
        SPEED AXIS(ax_seal)=VR(seal_speed)*1000
        timing_seal_end=1
    ELSE
        'PRINT #0, "Option 5"
        SPEED AXIS(ax_seal)=VR(seal_speed)*1000
        MOVEABS(276*5) AXIS(6)'Move Seal to 5mm
        timing_seal_end=1
    ENDIF
ENDIF

SPEED AXIS(ax_seal)=seal_speed*1000
WAIT UNTIL MPOS AXIS(ax_seal)<36000
VR(seal_count)=VR(seal_count)+1

IF VR(commands_film).film_print_speed_save THEN VR(commands_seal).seal_start=0

GOTO start

pack_block_routine:
CANCEL(2)
WAIT IDLE

VR(commands_seal).seal_pause=1
VR(seal_crush_count)=0
VR(seal_crush_count)=VR(seal_crush_count)+1

MOVEABS(0) AXIS(ax_seal)
WAIT UNTIL IDLE AXIS(ax_seal)

MOVEABS(VR(seal_crush_pos)*10)
WAIT UNTIL MPOS AXIS(ax_seal)>=(VR(seal_crush_pos)*10) OR IN(i_pack_crush_sensor)=ON

IF IN(i_pack_crush_sensor)=ON THEN
    CANCEL(2)
    WAIT IDLE
    PRINT #0, "Crush Stop Dist = ";(MPOS/264)
    MOVEABS(0) AXIS(ax_seal)
    WAIT UNTIL IDLE AXIS(ax_seal)
ELSE
    GOTO pack_crush_end_jump
ENDIF

IF VR(seal_crush_count)>1 THEN
    VR(commands_seal).seal_pause_aux=1
    WAIT UNTIL VR(commands_seal).seal_pause=0
ENDIF

PRINT #0, "Pack Crush: END"
GOTO pack_crush_end_jump
