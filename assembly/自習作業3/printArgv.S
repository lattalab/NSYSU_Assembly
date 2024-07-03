    .text 
	.align	2
	.global	main
main:
    @ prologue
    @ Save registers and the return address.
    stmfd sp! , {fp, lr} 

    mov r4, r0  // argc
    mov r5, r1  // base of argv
    mov r6 , #0

loop:
    cmp r4, r6
    ldrgt r0 , =str
    ldrgt r1, [r5, r6, LSL #2]  // print argv[i]
    blgt printf
    cmp r4, r6
    addgt r6, r6 , #1
    bgt loop

    @ epilogue
    ldmfd sp!, {fp, lr}
    mov pc, lr
str:
    .asciz "%s\n"
