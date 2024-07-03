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

    @ store first , otherwise it will be rewrite after calling the subroutine
    ldr r4, [r1, #4]    @ load the argv[1]

    @ index
    mov r5, #0
    @ string length
    mov r6 , #0

    @ print info
    ldr r0, =message_format
    bl   printf     @ print the initial message

@ calculating strlen()
count:
    @ load each byte
    ldrb r1, [r4, r5]
    @ check if null character reached
    cmp r1, #0
    beq reset
    @ index++
    add r5, r5 , #1
    b count

@ set up string length and store in r6
reset:
    mov r6, r5
    mov r5, #0
    add r6 ,r6, #1

@ print each character according the condition
loop:
    @ first check if reached the end of string
    cmp r5, r6
    beq EXIT
    @ load character
    ldrb r3, [r4, r5]

    @ upper letter
    cmp r3, #'A'
    blt next_char
    cmp r3, #'Z'
    ble upper       @ 'A'~'Z' will enter

    @ lower letter
    cmp r3, #'a'
    blt next_char
    cmp r3, #'z'
    bgt next_char

    @ print lowercase letter
    ldr r0, =char_format
    mov r1, r3
    bl	printf 
    b next_char

@ translate to lowercase letter
upper:
    @ offset to change uppercase letter
    add r3 , r3 , #32
    mov r1, r3  
    ldr r0, =char_format
    bl	printf    

@ get next character and loop
next_char:
    add r5, r5, #1
    b loop

EXIT:
    mov r0, #0          @ return 0

    @ epilogue
    ldmfd sp! , {r0-r9, fp, lr}
    sub sp ,fp, #4
    bx lr

message_format:
    .asciz "program1 result: "
char_format:
    .asciz "%c"   

.end