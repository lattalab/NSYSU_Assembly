TEX:
    .text 
	.align	2
    .extern printf
	.global	main
main:
    @ prologue
    @ Save registers and the return address.
    stmfd sp! , {r0-r9, fp, lr} 
    add fp, sp, #4

    @ print first line output
    ldr r0, =string1
    bl  printf
    BL  start_deasm
    @ load test.S
    .include "test.S"

    start_deasm:
		ldr	r7, =start_deasm
		mov	r8, r14  // point to start to deasm
        mov r11 , r8 // save first line PC value in test.S

        @ represent current PC value (used to output)
		mov	r10, #0

    @ run through each instruction	
	LOOP:	
        cmp	r8, r7
		beq	EXIT
		
        @ print PC and updata PC
        ldr r0 , =print_pc
        mov r1 , r10
        add r10 , r10 , #4
        bl printf

		ldr     r4, [r8]  // load instruction
        @ get condition field
        ldr     r5, =0xf0000000 
        and     r6, r4, r5

        @ check which condition
        CMP     r6, #0x00000000
        beq     EQ
        CMP     r6, #0x10000000
        beq     NE
        CMP     r6, #0x20000000
        beq     CSHS
        CMP     r6, #0x30000000
        beq     CCLO
        CMP     r6, #0x40000000
        beq     MI
        CMP     r6, #0x50000000
        beq     PL
        CMP     r6, #0x60000000
        beq     VS
        CMP     r6, #0x70000000
        beq     VC
        CMP     r6, #0x80000000
        beq     HI
        CMP     r6, #0x90000000
        beq     LS
        CMP     r6, #0xa0000000
        beq     GE
        CMP     r6, #0xb0000000
        beq     LT
        CMP     r6, #0xc0000000
        beq     GT
        CMP     r6, #0xd0000000
        beq     LE
        CMP     r6, #0xe0000000
        beq     AL
        CMP     r6, #0xf0000000
        beq     NV

    instruction_type:
        @ first test Undefined instruction
        // MUL
        ldr r9 , =0x0F0000F0
        and r6, r4 , r9
        cmp r6, #0x00000090
        beq outUND
        // CLZ
        ldr r9 , =0x0FF000F0
        and r6, r4, r9 
        ldr r9 , =0x01600010
        cmp r6, r9
        beq outUND
        // half-word and sign byte data transfer
        ldr r9 , =0x0e000090
        and r6, r4, r9  
        cmp r6 , #0x00000090
        beq outUND
        // LDM and STM
        ldr r9 , =0x0e000000
        and r6, r4, r9 
        cmp r6, #0x08000000
        beq outUND

        @ test if data_processing instruction?
        and r9 , r4, #0x0C000000
        cmp r9, #0x0
        beq data_processing

        @ test if data movement instruction
        cmp r9, #0x04000000
        beq data_transfer

        @ branch instruction
        Branch:
            @ test if branch instruction, if not: Undefined instruction occur
            ldr r9, =0x0e000000
            and r6, r4 , r9
            cmp r6, #0x0A000000
            BNE outUND
            
            @ branch or branch-link
            and r6 , r4 , #0x01000000
            cmp r6 , #0x01000000
            @ test if need to link, otherwise B instruction
            beq outBL
            B outB

        @ if current instruction is data_processing instruction
        data_processing:
            and r6 , r4 , #0x01e00000 // get opcode
            CMP     r6, #0x00000000
            beq     outAND
            CMP     r6, #0x00200000
            beq     outEOR
            CMP     r6, #0x00400000
            beq     outSUB
            CMP     r6, #0x00600000
            beq     outRSB
            CMP     r6, #0x00800000
            beq     outADD
            CMP     r6, #0x00a00000
            beq     outADC
            CMP     r6, #0x00c00000
            beq     outSBC
            CMP     r6, #0x00e00000
            beq     outRSC
            CMP     r6, #0x01000000
            beq     outTST
            CMP     r6, #0x01200000
            beq     outTEQ
            CMP     r6, #0x01400000
            beq     outCMP
            CMP     r6, #0x01600000
            beq     outCMN
            CMP     r6, #0x01800000
            beq     outORR
            CMP     r6, #0x01a00000
            beq     outMOV
            CMP     r6, #0x01c00000
            beq     outBIC
            CMP     r6, #0x01e00000
            beq     outMVN

        @ if current instruction is LDR or STR
        data_transfer:
            and r6 , r4, #0x00100000
            cmp r6 , #0x00100000
            beq outLDR
            cmp r6 , #0x0
            beq outSTR


        @ output condition
        EQ:
            ldr r0 , = EQ_condition
            bl printf
            B instruction_type
        NE:
            ldr r0 , = NE_condition
            bl printf
            B instruction_type
        CSHS:
            ldr r0 , = CSHS_condition
            bl printf   
            B instruction_type
        CCLO:
            ldr r0 , = CCLO_condition
            bl printf
            B instruction_type
        MI:
            ldr r0 , = MI_condition
            bl printf
            B instruction_type
        PL:
            ldr r0 , = PL_condition
            bl printf
            B instruction_type
        VS:
            ldr r0 , = VS_condition
            bl printf   
            B instruction_type
        VC:
            ldr r0 , = VC_condition
            bl printf
            B instruction_type
        HI:
            ldr r0 , = HI_condition
            bl printf
            B instruction_type
        LS:
            ldr r0 , = LS_condition
            bl printf
            B instruction_type
        GE:
            ldr r0 , = GE_condition
            bl printf  
            B instruction_type 
        LT:
            ldr r0 , = LT_condition
            bl printf
            B instruction_type
        GT:
            ldr r0 , = GT_condition
            bl printf
            B instruction_type
        LE:
            ldr r0 , = LE_condition
            bl printf
            B instruction_type
        AL:
            ldr r0 , = AL_condition
            bl printf  
            B instruction_type 
        NV:
            ldr r0 , = NV_condition
            bl printf
            B instruction_type

        @ output data_processing instruction
        outAND:     
            ldr r0, =stringAND
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outEOR:     
            ldr r0, =stringEOR
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outSUB:     
            ldr r0, =stringSUB
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outRSB:     
            ldr r0, =stringRSB
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outADD:     
            ldr r0, =stringADD
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outADC:     
            ldr r0, =stringADC
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outSBC:     
            ldr r0, =stringSBC
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outRSC:     
            ldr r0, =stringRSC
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outTST:     
            ldr r0, =stringTST
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outTEQ:     
            ldr r0, =stringTEQ
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outCMP:     
            ldr r0, =stringCMP
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outCMN:     
            ldr r0, =stringCMN
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outORR:     
            ldr r0, =stringORR
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outMOV:     
            ldr r0, =stringMOV
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outBIC:     
            ldr r0, =stringBIC
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP
        outMVN:     
            ldr r0, =stringMVN
            BL  printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B   LOOP

        @ output data_transfer instruction
        outLDR:
            ldr r0, =stringLDR
            BL printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B LOOP
        outSTR:
            ldr r0, =stringSTR
            BL printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            B LOOP

        @ output branch instruction
        outB:
            ldr r0 , =stringB

            @ get label field from branch instruction
            and r6 , r4, #0x00ffffff
            @ test if we need to do sign extension (MSB)
            cmp r6 , #0x00800000
            ORRGE r6 , #0xff000000
            @ the offset need to multiple 4 (word-aligned)
            LSL r6 , r6 , #2

            @ point to label (PC + 8 + offset)
            add r2 , r8 , #8
            add r2 , r2 , r6
            @ 平移
            sub r1 , r2 , r11
            

            bl printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            b LOOP
        outBL:
            ldr r0 , =stringBL

            @ get label field from branch instruction
            and r6 , r4, #0x00ffffff
            @ test if we need to do sign extension (MSB)
            cmp r6 , #0x00800000
            ORRGE r6 , #0xff000000
            @ the offset need to multiple 4 (word-aligned)
            LSL r6 , r6 , #2

            @ point to label (PC + 8 + offset)
            add r2 , r8 , #8
            add r2 , r2 , r6
            @ 平移
            sub r1, r2 , r11

            bl printf
            add r8, r8 , #4   // r8 = loacation of next instruction
            b LOOP
        
        @ output Undefined instruction
        outUND:
            ldr r0, =stringUND
            bl printf
            add r8, r8, #4
            b LOOP

EXIT:
    mov r0, #0          @ return 0

    @ epilogue
    ldmfd sp! , {r0-r9, fp, lr}
    sub sp ,fp, #4
    bx lr

@ needed string to get correct output
string1:
    .asciz "PC	condition	instruction\n"
print_pc:
    .asciz "%d\t"

@ condition string
EQ_condition:
    .asciz "EQ\t\t"
NE_condition:
    .asciz "NE\t\t"
CSHS_condition:
    .asciz "CS/HS\t\t"
CCLO_condition:
    .asciz "CC/LO\t\t"
MI_condition:
    .asciz "MI\t\t"
PL_condition:
    .asciz "PL\t\t"
VS_condition:
    .asciz "VS\t\t"
VC_condition:
    .asciz "VC\t\t"
HI_condition:
    .asciz "HI\t\t"
LS_condition:
    .asciz "LS\t\t"
GE_condition:
    .asciz "GE\t\t"
LT_condition:
    .asciz "LT\t\t"
GT_condition:
    .asciz "GT\t\t"
LE_condition:
    .asciz "LE\t\t"
AL_condition:
    .asciz "AL\t\t"
NV_condition:
    .asciz "NV\t\t"

@ output data_processing instruction type
stringAND:
    .asciz "AND\n"
stringEOR:
    .asciz "EOR\n"
stringSUB:
    .asciz "SUB\n"
stringRSB:
    .asciz "RSB\n"
stringADD:
    .asciz "ADD\n"
stringADC:
    .asciz "ADC\n"
stringSBC:
    .asciz "SBC\n"
stringRSC:
    .asciz "RSC\n"
stringTST:
    .asciz "TST\n"
stringTEQ:
    .asciz "TEQ\n"
stringCMP:
    .asciz "CMP\n"
stringCMN:
    .asciz "CMN\n"
stringORR:
    .asciz "ORR\n"
stringMOV:
    .asciz "MOV\n"
stringBIC:
    .asciz "BIC\n"
stringMVN:
    .asciz "MVN\n"

@ data_transfer instruction
stringLDR:
    .asciz "LDR\n"
stringSTR:
    .asciz "STR\n"

@ branch instruction
stringB:
    .asciz "B\t%d\n"
stringBL:
    .asciz "BL\t%d\n"

@ Undefined instruction
stringUND:
    .asciz "UND\n"

.end