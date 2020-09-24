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

IF VR(commands_seal).seal_pause_memory=1 THEN
    VR(commands_seal).seal_cycle=1
    VR(commands_seal).seal_manual_page=1
    WAIT UNTIL VR(commands_seal).seal_manual_page=0 OR VR(commands_seal).seal_manual_button=1
    IF VR(commands_seal).seal_manual_button=1 THEN
        VR(commands_seal).seal_start=1
        GOTO manual_seal_start
    ENDIF
    VR(commands_seal).seal_manual_page=0
    VR(commands_seal).seal_manual_button=0
    VR(commands_seal).seal_pause_memory=0
ENDIF

start:
WAIT UNTIL MPOS AXIS(ax_seal)<4000
local_torque=0
VR(commands_seal).seal_start=0
VR(commands_seal).seal_cycle=0
VR(commands_seal).seal_pause=0
VR(commands_seal).seal_manual_page=0
VR(commands_seal).seal_manual_button=0
VR(commands_seal).seal_pause_memory=0

SPEED AXIS(ax_seal)=(VR(seal_speed)*1000)
ACCEL AXIS(ax_seal)=(VR(seal_acc)*1000)
DECEL AXIS(ax_seal)=(VR(seal_dec)*1000)

WAIT UNTIL VR(commands_seal).seal_start=1
manual_seal_start:
VR(commands_seal).seal_cycle=1
VR(commands_seal).seal_pause=0
VR(seal_crush_count)=0
local_gas_complete=0
local_eject_up_flag=0
local_seal_cushion_up_flag=0
local_seal_cushion_down_flag=0
local_eject_cushion_down_flag=0

retry_seal:
WAIT UNTIL VR(commands_seal).seal_pause=0 OR IN(i_safety_general)=OFF

IF IN(i_safety_general)=OFF THEN
    VR(commands_seal).seal_pause=0
ENDIF
TRIGGER

retry_loop:

IF VR(commands_seal).seal_eject_cushion_up=1 AND VR(seal_eject_pos_bottom)<VR(seal_compress_pos) THEN
    MOVEABS(VR(seal_eject_pos_bottom)*10) AXIS(ax_seal)
    IF debug_seal=1 THEN PRINT #7,"Move Cushion Up Pos "
    ELSE
        MOVEABS(VR(seal_up_pos)*10) AXIS(6)
        IF debug_seal=1 THEN PRINT #7,"Move to Atmos Pos "
    ENDIF

    REPEAT ' seal travelling up
    'record torque
        IF -DRIVE_TORQUE AXIS(ax_seal)>local_torque THEN local_torque=-DRIVE_TORQUE AXIS(ax_seal)

    'Pack Crush Detect
        IF VR(commands_seal).seal_pack_crush_on=1 AND MPOS AXIS(ax_seal)<=((VR(seal_crush_pos)*10)-5000)_
                AND VR(seal_crush_count)<> 4 THEN
            IF IN(i_pack_crush_sensor) AND MPOS AXIS(ax_seal)<(VR(seal_crush_pos)*10) THEN
            IF debug_seal=1 THEN PRINT #7,"seal_pack_crush_pause TRIGGERED"
            VR(seal_crush_count)=VR(seal_crush_count)+1
            IF VR(seal_crush_count)=2 OR VR(seal_crush_count)=4 THEN
                VR(commands_seal).seal_pause=1
                VR(commands_seal).seal_pause_memory=1
            ENDIF
            SPEED AXIS(ax_seal)=0
            WAIT UNTIL MSPEED AXIS(ax_seal)<10
            IF debug_seal=1 THEN PRINT #7,"Move Seal to Zero"
            MOVEMODIFY(0) AXIS(ax_seal)
            SPEED AXIS(ax_seal)=(VR(seal_speed)*1000)
            WAIT UNTIL IDLE AXIS(ax_seal)
            IF VR(seal_crush_count)=1 OR VR(seal_crush_count)=3 OR VR(seal_crush_count)=4 THEN
                IF VR(seal_crush_count)=4 THEN WAIT UNTIL VR(commands_seal).seal_pause=0
                WA(200)
                IF debug_seal=1 THEN PRINT #7,"Pack crush - go to retry"
                GOTO retry_loop
            ELSE
                GOTO retry_seal
            ENDIF
        ENDIF
    ENDIF

''    'Map-F
''    IF mapf_on=1 AND MPOS AXIS(6)>((seal_gas_pos*10)-(276*5)) AND local_gas_complete=0 THEN
''        IF debug_seal=1 THEN PRINT #7,"Map-F Pos - Gas ON"
''        OP(o_gas_valve1,ON)
''        OP(o_gas_valve2,ON)
''        WAIT UNTIL IDLE AXIS(6)
''        WA(gas_time)
''        OP(o_gas_valve1,OFF)
''        OP(o_gas_valve2,OFF)
''        local_gas_complete=1
''        MOVEABS(seal_up_pos*10) AXIS(6)
''    ELSE

    'seal_eject_cushion_up
'    IF VR(seal_eject_pos_bottom)<VR(seal_compress_pos) THEN
'        IF VR(commands_seal).seal_eject_cushion_up=1_
'                AND local_eject_up_flag=0 _
'                AND MPOS AXIS(ax_seal)>((VR(seal_eject_pos_bottom)/3)*10) _
'                AND MSPEED AXIS(ax_seal)<=(VR(seal_eject_speed)*1000)+500 THEN
'            MOVEMODIFY(VR(seal_up_pos)*10) AXIS(ax_seal)
'            IF debug_seal=1 THEN PRINT #7,"Eject Cusion UP Complete"
'            local_eject_up_flag=1
'        ENDIF
'    ENDIF

'   ' ENDIF

    'seal_cushion_up
    IF VR(commands_seal).seal_cushion_up=1_
            AND MPOS AXIS(ax_seal)>((VR(seal_compress_pos)*10)-(276*5)) _
            AND local_seal_cushion_up_flag=0 THEN
        SPEED AXIS(ax_seal)=(VR(seal_compress_speed)*1000)
        IF debug_seal=1 THEN PRINT #7,"Seal Cusion UP Complete"
        local_seal_cushion_up_flag=1
    ENDIF
    WA(1)
UNTIL MPOS AXIS(ax_seal)>((VR(seal_up_pos)*10)-(276*3))

IF debug_seal=1 THEN PRINT #7,"Seal Position Reached"

'REV
IF READ_OP(o_magnets_ssr)=OFF AND VR(seal_time)>=400 THEN OP(o_magnets_ssr,ON)

WAIT IDLE AXIS(ax_seal)

VR(commands_seal).seal_pause=0
VR(seal_crush_count)=0
VR(seal_max_torque)=torque
torque=0

'REV
IF VR(seal_time)>=400 THEN MOVEABS(VR(seal_hold_pos)*10) AXIS(ax_seal)

WA(seal_time)
VR(seal_hold_torque)=-DRIVE_TORQUE AXIS(ax_seal)

IF VR(seal_time)>=400 THEN
    MOVEABS(VR(seal_end_pos)*10) AXIS(ax_seal)
    WAIT UNTIL MPOS AXIS(ax_seal)>(VR(seal_end_pos)*10)-260
ENDIF

OP(o_magnets_ssr,OFF)

IF VR(seal_eject_pos_bottom)>VR(seal_decompress_pos) THEN VR(seal_eject_pos_bottom)=VR(seal_decompress_pos)

IF VR(commands_seal).seal_eject_cushion_down=1 THEN
    MOVEABS(VR(seal_eject_pos_bottom)*10) AXIS(ax_seal)
ELSE
    MOVEABS(276*5) AXIS(ax_seal)
ENDIF

IF VR(commands_seal).seal_eject_cushion_down=1 THEN
    SPEED AXIS(ax_seal)=(VR(seal_decompress_speed)*1000)
ELSE
    SPEED AXIS(ax_seal)=(VR(seal_speed)*1000)
ENDIF

REPEAT ' seal moving down
    'seal_cusion_down
    IF VR(commands_seal).seal_eject_cushion_down=1 _
            AND MPOS AXIS(ax_seal)<=((VR(seal_decompress_pos)*10)+276)_
            AND local_seal_cushion_down_flag=0 THEN
        SPEED AXIS(ax_seal)=(VR(seal_speed)*1000)
        local_seal_cushion_down_flag=1
    ENDIF

    'seal_eject_cushion_down
    IF VR(commands_seal).seal_eject_cushion_down=1_
            AND local_eject_cushion_down_flag=0 _
            AND MPOS AXIS(ax_seal)<((VR(seal_eject_pos_bottom)*10)+(276*5)) THEN
        MOVEMODIFY(276*5) AXIS(ax_seal)
        local_eject_cushion_down_flag=1
    ENDIF
    WA(1)
UNTIL MPOS AXIS(ax_seal)<4200

VR(seal_count)=VR(seal_count)+1

IF VR(commands_film).film_print_speed_save THEN VR(commands_seal).seal_start=0

GOTO start
