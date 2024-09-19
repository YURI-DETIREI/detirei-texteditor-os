;jmp start ;comment if using a emulator
cleardisplay:
xor bx, bx
mov ax, 0x7720 ;(THEME) ;LIGHT: 7720; DARK: 0020;
cd01:
call print
cmp bx, 4000
jl cd01 
mov bx, 160
mov ah, 0x00 ;(THEME) 
cd02:
call print
cmp bx, 3840
jl cd02    

start:
mov bx, 160 
call pushbx                                     
call forcompare2
call forcompare
texteditor:
call popbx
;rec. values for al: 7c or B3   
mov ax, 0x87b3 ;(THEME) ;LIGHT: FF7C; DARK: 877C;
call print
sub bx, 2 
call pushbx
call kbget
mov ah, 0x07 ;(THEME) ;LIGHT: 70; DARK: 07;
cmp al, 0x08 ; Backspace
je backspace 
cmp al, 0x0d ; Enter
je enter  
cmp al, 0x00 ; Null
je texteditor
cmp ax, 0x2207 ; CTRL G
je offset0
;data write
call write
call popbx  
call print
cmp bx, 3840
jge resetbx 
call pushbx  
call forcompare 
jmp texteditor 
 
pushbx:
mov dx, bx
mov bx, cx
ret
popbx:
mov cx, bx  
mov bx, dx
ret 
 
write:
push ds   
push ax
mov ax, 0x1000
mov ds, ax
pop ax 
cmp bx, 0xffff
je texteditor
mov b.[bx], al  ;  S
inc bx    
pop ds    
ret

backspace:
cmp bx, 0
je texteditor
dec bx 
mov al, 0
call write 
dec bx
call popbx
cmp bx, 160
jle texteditor
mov al, 0x20
sub bx, 2
call print    
call print
sub bx, 4
call pushbx
call forcompare 
jmp texteditor

offs:



enter:
call write   
call popbx
mov al, 0x20
call print
sub bx, 2 
mov dx, bx
xor bx, bx
enter1:
add bx, 160
cmp dx, bx
jg enter1
sub dx, 2
enter2:
add dx, 2
cmp dx, bx
jne enter2
mov bx, dx
cmp dx, 3840
jge resetbx
call pushbx  
call forcompare 
jmp texteditor  

datafull:




resetbx:
mov bx, 160   
call pushbx
jmp texteditor


print: 
push ds   
push ax
mov ax, 0xb800
mov ds, ax
pop ax
mov w.[bx], ax  ;  S
add bx, 2    
pop ds
ret


kbget:
mov ah, 0
int 0x16
ret

forcompare2:
pusha
mov bx, 00093 ;version number, digits 1 and 3 is discarted  
CALL COMPARE
MOV AX, 0x7056
mov bx, 3990 
call forcompareb
MOV BX, 3994
mov al, "."
call print 
popa


forcompare:
pusha
CALL COMPARE
ADD AL, 0x30
mov ah, 0x70
mov bx, 3840
call forcompareb 
popa
jmp texteditor
forcompareb:
CALL print
;--------------
MOV AL, CH
ADD AL, 0x30 
CALL print
;--------------
MOV AL, CL
ADD AL, 0x30
CALL print
;--------------
MOV AL, DH
ADD AL, 0x30 
CALL print
;--------------
MOV AL, DL
ADD AL, 0x30
CALL print          
ret

COMPARE:
mov ax, 0xffff
mov dx, 0x00ff 
xor cx, cx
hexcmp0: 
inc dl
inc ax
cmp ax, bx
je hexcmp1
cmp dl, 9 
jne hexcmp0
inc dh
mov dl, 0xff
cmp dh, 0x0a
jne hexcmp0
inc cl
mov dh, 0
cmp cl, 0x0a
jne hexcmp0
inc ch
mov cl, 0
push cx
and ch, 00001111b
cmp ch, 0x0a 
pop cx
jne hexcmp0
add ch, 7

hexcmp1:
mov al, ch        
and ax, 0000000011110000b
mov bh, 0x10
div bh
and ch, 00001111b
ret

  
; CHANGE LOG
; - OPTIMIZATION OF PROGRAM
;
;
;
;


;--------------------------------------
offset0:
