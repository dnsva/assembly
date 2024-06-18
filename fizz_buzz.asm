
; rules
; 1. if the number is divisible by 3, print "Fizz"
; 2. if the number is divisible by 5, print "Buzz"
; 3. if the number is divisible by 3 and 5, print "FizzBuzz"
; 4. otherwise, print the number

section .data

    str_fizz db "Fizz", 0xA ; newline character
    str_fizz_len equ $ - str_fizz
    str_buzz db "Buzz", 0xA ; newline character
    str_buzz_len equ $ - str_buzz
    str_fizz_buzz db "FizzBuzz", 0xA ; newline character
    str_fizz_buzz_len equ $ - str_fizz_buzz

    format db "%d\n", 0xA,  0 ; format string for printing the number


section .bss

global main

section .text


extern printf ; from C library

main:
    ; eax, ebx, ecx, edx = sys_write
    ; edi = i loop cuonter
    xor edi, edi ; i = 0

loop:

    ;INCREMENT i
    inc edi ; i++

    ;EXIT CONDITION:
    cmp edi, 100 ; check if i is 100
    jg exit ; if i is greater than 100, jump to exit

    ;----------------------------------------------------------------

    ; check if the number is divisible by 3
    xor eax, eax ; clear eax
    xor ebx, ebx ; clear ebx
    xor edx, edx ; clear edx

    mov eax, edi ; the curr number (i)
    mov ebx, 3 ; to divide by 3
    div ebx ; divide by 3
    and edx, edx ; check if the remainder is 0
    jz divisible_by_3 ; if the remainder is 0, jump to divisible_by_3
    ;----------------------------------------------------------------

    ; check if the number is divisible by 5
    xor eax, eax ; clear eax
    xor ebx, ebx ; clear ebx
    xor edx, edx ; clear edx

    mov eax, edi ; the curr number (i)
    mov ebx, 5 ; to divide by 5
    div ebx ; divide by 5
    and edx, edx ; check if the remainder is 0
    jz divisible_by_5 ; if the remainder is 0, jump to divisible_by_5
    jnz print_number ; if the remainder is not 0, jump to print_number
    ;----------------------------------------------------------------

divisible_by_3:

    ;Check if ALSO divisible by 5!!!!!!!!!!!!!!!!!!
    xor eax, eax ; clear eax
    xor ebx, ebx ; clear ebx
    xor edx, edx ; clear edx

    mov eax, edi ; the curr number (i)
    mov ebx, 5 ; to divide by 5
    div ebx ; divide by 5
    and edx, edx ; check if the remainder is 0
    jz divisible_by_3_and_5 ; if the remainder is 0, jump to divisible_by_3_and_5
    ;----------------------------------------------------------------

    ; print "Fizz"
    mov eax, 4 ; sys_write
    mov ebx, 1 ; stdout
    mov ecx, str_fizz ; address of the string
    mov edx, str_fizz_len ; length of the string
    int 0x80 ; syscall

    jmp loop ; continue to the next number

divisible_by_5:
    ; print "Buzz"
    mov eax, 4 ; sys_write
    mov ebx, 1 ; stdout
    mov ecx, str_buzz ; address of the string
    mov edx, str_buzz_len ; length of the string
    int 0x80 ; syscall

    jmp loop ; continue to the next number

divisible_by_3_and_5:
    ; print "FizzBuzz"
    mov eax, 4 ; sys_write
    mov ebx, 1 ; stdout
    mov ecx, str_fizz_buzz ; address of the string
    mov edx, str_fizz_buzz_len ; length of the string
    int 0x80 ; syscall

    jmp loop ; continue to the next number
    
print_number:
    ; print the number

    ; i want to print edi

    push edi
    push format
   call printf
   ; call printf wrt ..plt
    add esp, 8 ; 2*4 bytes

    jmp loop ; continue to the next number

exit:
    ; exit
    mov eax, 1 ; sys_exit
    xor ebx, ebx ; exit code
    int 0x80 ; syscall
