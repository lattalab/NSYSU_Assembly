section .text
; Export the entry point to the ELF linker or loader.  
; The conventional entry point is "_start".
    global _start

section .data
signFlag db 0 ; indicating whether is negative or positive
LCMflag db 0  ; indicating whether we are calling LCM function
; print format
function1 db 'Function 1: maximum of '
f1_len equ $ - function1      
function2 db 'Function 2: greatest common divisor of '
f2_len equ $ - function2  
function3 db 'Function 3: least common multiply of '
f3_len equ $ - function3  
and_string db ' and '
and_len equ $ - and_string  
is_string db ' is '
is_len equ $ - is_string    
dot_string db '.'
dot_len equ $ - dot_string     

section .bss
buf resb 60             ; read from stdin and store in buf
a resd 1                ; function parameter a
b resd 1                ; function parameter b
op resd 1               ; function opcode
string resb 12          ; a string used to print number in stdout

section .text
; linker puts the entry point here:
_start:

  ; try to read from stdin
  mov ebx, 0 ; file descriptor (stdin)
  mov eax, 3 ; system call number (sys_read)
  ; read from stdin
  mov ecx, buf   ;move input to ecx
  mov edx, 60    ;Maximum to read 60 bytes
  int 0x80   ; call kernel

  ; Call string_to_int to convert and store in each integer
  mov ecx, 0          ; buffer offset to read a ,b ,op respectively
  mov esi, buf        ; Pointer to the string
  call string_to_int
  mov [a], eax        ; Store the result in 'a'
  lea esi, [buf+ecx]
  call string_to_int
  mov [b], eax        ; Store the result in 'b'
  lea esi, [buf+ecx]
  call string_to_int
  mov [op], eax       ; Store the result in 'op'

  ; Check which type function (opcode)
  cmp dword [op], 1
  jz max
  cmp dword [op], 2
  ; Clear the LCM flag
  mov byte [LCMflag], 0
  jz gcd
  cmp dword [op], 3
  ; Set the LCM flag
  mov byte [LCMflag], 1
  jz gcd

  ; GCD function also will be used in LCM function
gcd:
  ; Check the LCM flag
  cmp byte [LCMflag], 0
  jz is_gcd
  jmp is_lcm

is_gcd:
  call printbase_gcd
  mov dword eax, [a]
  mov dword ebx, [b]
  jmp gcd_loop

is_lcm:
  call printbase_lcm
  mov dword eax, [a]
  mov dword ebx, [b]
  jmp gcd_loop

gcd_loop:
  cmp ebx, 0
  je print_what
  xor edx, edx    ; Clear edx before division (and remainder in edx)
  div ebx         ; EAX/=EBX
  mov eax, ebx    ; restart with EAX = EBX
  mov ebx, edx    ; and          EBX = EDX
  jmp gcd_loop

print_what:
  ; Check the LCM flag
  cmp byte [LCMflag], 1
  jz calculate_lcm
  jmp print_gcd
  
calculate_lcm:
  mov ebx, eax               ; Store gcd in EBX
  mov dword eax, [a]         ; Restore original a in EAX

  xor edx, edx
  div ebx                    ; EAX = a / GCD(a, b)
  mov dword edx, [b]         ; Restore original b in EDX
  imul eax, edx              ; EAX *= b
  jmp print_lcm

print_lcm:
  ; Print LCM (which is now in eax)
  mov esi, string   ; esi points to the string buffer
  mov ecx, 0
  call int_to_string
  call print_string
  ; print dot at the end
  mov edx, dot_len     ; message length
  mov ecx, dot_string  ; message to write
  mov ebx, 1           ; file descriptor (stdout)
  mov eax, 4           ; system call number (sys_write)
  int 0x80             ; call kernel
  jmp Exit

print_gcd:
  ; Print GCD (which is now in eax)
  mov esi, string   ; esi points to the string buffer
  mov ecx, 0
  call int_to_string
  call print_string
  ; print dot at the end
  mov edx, dot_len     ; message length
  mov ecx, dot_string  ; message to write
  mov ebx, 1           ; file descriptor (stdout)
  mov eax, 4           ; system call number (sys_write)
  int 0x80             ; call kernel
  jmp Exit

printbase_gcd:
  ; Write the string to stdout:
  mov edx, f2_len ;message length
  mov ecx, function2 ;message to write
  mov ebx, 1   ;file descriptor (stdout)
  mov eax, 4   ;system call number (sys_write)
  int 0x80    ;call kernel
  call print_a
  mov edx, and_len ;message length
  mov ecx, and_string ;message to write
  mov ebx, 1   ;file descriptor (stdout)
  mov eax, 4   ;system call number (sys_write)
  int 0x80    ;call kernel
  call print_b
  mov edx, is_len ;message length
  mov ecx, is_string ;message to write
  mov ebx, 1   ;file descriptor (stdout)
  mov eax, 4   ;system call number (sys_write)
  int 0x80    ;call kernel
  ret
 
printbase_lcm:
  ; Write the string to stdout:
  mov edx, f3_len ;message length
  mov ecx, function3 ;message to write
  mov ebx, 1   ;file descriptor (stdout)
  mov eax, 4   ;system call number (sys_write)
  int 0x80    ;call kernel
  call print_a
  mov edx, and_len ;message length
  mov ecx, and_string ;message to write
  mov ebx, 1   ;file descriptor (stdout)
  mov eax, 4   ;system call number (sys_write)
  int 0x80    ;call kernel
  call print_b
  mov edx, is_len ;message length
  mov ecx, is_string ;message to write
  mov ebx, 1   ;file descriptor (stdout)
  mov eax, 4   ;system call number (sys_write)
  int 0x80    ;call kernel
  ret 
 
  ; Max function
max:
printbase_max:
  ; Write the string to stdout:
  mov edx, f1_len     ;message length
  mov ecx, function1  ;message to write
  mov ebx, 1          ;file descriptor (stdout)
  mov eax, 4          ;system call number (sys_write)
  int 0x80            ;call kernel
  call print_a
  mov edx, and_len    ;message length
  mov ecx, and_string ;message to write
  mov ebx, 1          ;file descriptor (stdout)
  mov eax, 4          ;system call number (sys_write)
  int 0x80            ;call kernel
  call print_b
  mov edx, is_len     ;message length
  mov ecx, is_string  ;message to write
  mov ebx, 1          ;file descriptor (stdout)
  mov eax, 4          ;system call number (sys_write)
  int 0x80            ;call kernel

judgement:
  mov dword eax, [a]
  mov dword ebx, [b]
  cmp eax, ebx
  jge winner_a   ; if 'a' >= 'b', jump to winner_a
  jmp winner_b

winner_b:
  call print_b
  ; print dot at the end
  mov edx, dot_len     ;message length
  mov ecx, dot_string  ;message to write
  mov ebx, 1           ;file descriptor (stdout)
  mov eax, 4           ;system call number (sys_write)
  int 0x80             ;call kernel
  jmp Exit

winner_a:
  call print_a
  ; print dot at the end
  mov edx, dot_len     ;message length
  mov ecx, dot_string  ;message to write
  mov ebx, 1           ;file descriptor (stdout)
  mov eax, 4           ;system call number (sys_write)
  int 0x80             ;call kernel
  jmp Exit

; Write as an helpful function to print
print_b:
  ; Print b
  mov eax, [b]     ; Load the value at memory location 'b' into eax
  mov esi, string  ; esi points to the string buffer
  mov ecx, 0
  call int_to_string
  call print_string
  ret

print_a:
  ; Print a
  mov eax, [a]     ; Load the value at memory location 'a' into eax
  mov esi, string  ; esi points to the string buffer
  mov ecx, 0
  call int_to_string
  call print_string
  ret

print_string:
  ; Write the string to stdout
  mov edx, ecx    ; Message length
  mov ecx, eax    ; Message to write (buffer)
  mov ebx, 1      ; File descriptor (stdout)
  mov eax, 4      ; System call number (sys_write)
  int 0x80        ; Call kernel
  ret
  
; End program
Exit:
  ; Exit via the kernel:
  mov ebx,0   ;process' exit code
  mov eax,1   ;system call number (sys_exit)
  int 0x80    ;call kernel - this interrupt won't return
  
; Read from stdin
; Input:
; ESI = pointer to the string to convert
; Output:
; EAX = integer value
string_to_int:
  xor eax, eax    ; Clear EAX
  xor edx, edx    ; Clear EDX (will indicate negative sign if needed)
.parse_loop:
  movzx ebx, byte [esi] ; Load the next byte and zero extend into EBX
  inc ecx
  cmp ebx, '0'
  jl .not_digit         ; If it's less than '0', it might be a sign or end of input
  cmp ebx, '9'
  jg .not_digit         ; If it's greater than '9', it's not a digit
  sub ebx, '0'          ; Convert from ASCII to integer
  imul eax, eax, 10
  add eax, ebx          ; EAX = EAX * 10 + EBX
  inc esi
  jmp .parse_loop

.not_digit:
  cmp ebx, '-'
  je .negate            ; If it's a '-', we need to negate the result
  cmp ebx, ' '          ; Space indicates end of this number
  je .done
  cmp ebx, 10           ; Newline indicates end of input
  je .done
  cmp ebx, 0            ; Null terminator indicates end of input
  je .done
  inc esi
  jmp .parse_loop       ; Ignore any other non-digit characters

.negate:
  mov edx, 1            ; Set the negative flag
  inc esi
  jmp .parse_loop

.done:
  test edx, edx         ; Check if we need to negate the result
  jz .return            ; If not, just return
  neg eax               ; Negate the result if needed

.return:
  ret

; Input:
; EAX = integer value to convert
; ESI = pointer to buffer to store the string in (must have room for at least 10 bytes)
; Output:
; EAX = pointer to the first character of the generated string
; ECX = length of the generated string
int_to_string:
  add esi, 11
  mov byte [esi], 0  ; String terminator '\0'
  mov ebx, 10        ; divsor 除數
  
  ; Clear the sign flag
  mov byte [signFlag], 0
  
  test eax, eax      
  jns .positive           ; Jump if the number is non-negative
  mov byte [signFlag], 1  ; Set flag to 1 (negative)
  neg eax                 ; Negate eax if it's negative
.positive:
.next_digit:
  inc ecx
  xor edx, edx        ; Clear EDX prior to dividing EDX:EAX by EBX
  div ebx             ; EAX /= 10
  add dl, '0'         ; Convert the remainder to ASCII 
  dec esi             ; store characters in reverse order
  mov [esi], dl
  test eax, eax            
  jnz .next_digit     ; Repeat until eax==0

  ; Check the sign flag
  cmp byte [signFlag], 1
  jne .end
  dec esi             ; Move back one more position for the negative sign
  inc ecx
  mov byte [esi], '-' ; Add the negative sign
  ; return a pointer to the first digit (not necessarily the start of the provided buffer)
.end:
    mov eax, esi       ; Set eax to point to the start of the string
    ret