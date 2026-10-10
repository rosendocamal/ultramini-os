[org 0x7c00]
[bits 16] 

mov [MAIN_DISK], dl ; Guardamos el disco primario

mov bp, 0x1000
mov sp, bp ; Colocamos un stack en 0x1000

mov bx, PROMPT
call print_string

mov dl, [MAIN_DISK]
mov ah, 0x02 ; Lectura
mov al, 0x01 ; N° de sectores a leer = 1
mov ch, 0x00 ; Cilindro = 0
mov dh, 0x00 ; Cabezal = 0
mov cl, 0x02 ; Sector = 2
mov bx, 0x8000 ; Guardar en 0x8000
int 0x13 ; Llamada a la BIOS

mov ax, handler_kbd
call install_keyboard

call second_stage

install_keyboard:
    push word 0
    pop ds ; ds = 0
    cli
    mov word [4 * KEYBOARD_INTERRUPT], keyboardDriver
    mov [4 * KEYBOARD_INTERRUPT + 2], cs
    mov word [HANDLER], ax
    sti
    ret

handler_kbd:
    mov al, [bx]
    cmp al, 'h'
    je .hola
    cmp al, 'a'
    je .adios
    mov bx, INVALID
    call print_string
    ret
.hola:
    mov bx, HOLA
    call print_string
    ret
.adios:
    mov bx, ADIOS
    call print_string
    ret

keyboardDriver:
    pusha
    in al, 0x60
    test al, 0x80
    jnz .end ; No leímos nada
    mov bl, al
    xor bh, bh
    mov al, [cs:bx + keymap]
    cmp al, 13
    je .enter
    mov bl, [WORD_SIZE]
    mov [WRD+bx], al
    inc bx
    mov [WORD_SIZE], bl
    mov ah, 0x0e
    int 0x10
.end:
    mov al, 0x61
    out 0x20, al 
    popa
    iret
.enter:
    mov bx, WRD
    mov cl, [WORD_SIZE]
    mov dx, [HANDLER]
    call dx
    mov byte [WORD_SIZE], 0
    jmp .end

print_string:
    pusha
    xor si, si ; si = 0
.loop:
    mov al, byte [bx+si]
    inc si,
    cmp al, 0
    je .end
    call print_char
    jmp .loop
.end:
    popa
    ret

print_char:
    push ax
    mov ah, 0x0e
    int 0x10
    pop ax
    ret

HANDLER: dw 0
WRD: times 64 db 0
WORD_SIZE: db 0
MAIN_DISK: db 0
PROMPT: db "Hello from miniOS ", 0x0
INVALID: db "Comando incorrecto ", 0x0
HOLA: db "Hello World ", 0x0
ADIOS: db "Bye World ", 0x0
KEYBOARD_INTERRUPT EQU 9

keymap:
    %include "keymap.inc"

times 510-($-$$) db 0
dw 0xaa55

second_stage:
    jmp $

times 1024-($-$$) db 0