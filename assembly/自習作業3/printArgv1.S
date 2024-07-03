    .text 
	.align	2
	.global	main
main:
    @ prologue
    @ Save registers and the return address.
    stmfd sp! , {fp, lr} 

    ldr r0, [r1, #4] // load argv[1]
    //ldr r0 , =str
    //mov r1 , r4
    bl printf

    @ epilogue
    ldmfd sp!, {fp, lr}
    mov pc, lr
str:
    .asciz "%s\n"
