	adds r1,r2,r3
	mov r1, #1
L1:	add r1, r1, #1
	cmple r2, #100
	ble L1
	ldr r3, [r1, #10]
	str r5, [r2], #6

    ADDGE r1, r2, r3
    SUBEQ r4, r5, r6
    ANDNE r7, r8, r9
    ORRPL r10, r11, r12
    EORVS r13, r14, r15
    MOVLS r1, r2
    MVNLT r3, r4
    CMPHI r5, r6
    CMNLO r7, r8
    TEQMI r9, r10
    TSTAL r11, r12
    BICCC r13, r14, r15
    ADCVC r1, r2, r3
    SBCVS r4, r5, r6
    RSCCS r7, r8, r9
    RSBNE r10, r11, r12
    LDRGT r13, [r14]
    STRLE r15, [r1]
    BNE   L1
    BLPL  label1
	BEQ	  label2
    CLZAL r1, r2
    MULCC r3, r4, r5
    MLAHI r6, r7, r8, r9
	UMULL r1, r2, r3, r4
    UMLAL r5, r6, r7, r8
    SMULL r9, r10, r11, r12
	SMLAL r9, r10, r11, r12

label1:	ADDS r1, r2, r3
label2: ADDS r1, r2, r4

    LDMFD r10! ,{r2-r9}
    STMIA r11 ,{r0-r5}
	SWI #7
	SWP r8 , r9 , [r4]
	LDRH r1 ,[r2]
	LDRSH r1 ,[r2]
	LDRSB r1 ,[r2]
	STRH r3 ,[r4]
	STRB r3 ,[r4]
	LDRB r7, [r8]
    LSL r1, r2, #4
    LSR r3, r4, #4
    ASR r4, r5, #4
    ROR r3 , r4, #2
    RRX r7, r8
    ADR r1, L1
    ldr r2, =0x87654321



    
    