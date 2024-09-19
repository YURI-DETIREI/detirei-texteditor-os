start:
call cleardisplay ;COMMENT THIS LINE WHEN USING A EMULATOR
call resetbx2 
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


enter:
call write   
call popbx
mov al, 0x20
call print
sub bx, 2 
mov dx, bx
mov bx, 0
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



cleardisplay:
mov bx, 0
mov ax, 0x0020 ;(THEME) ;LIGHT: 7720; DARK: 0020;
cd01:
call print
cmp bx, 4000
jl cd01
mov bx, 0
mov ah, 0x77 ;(THEME) 
cd02:
call print
cmp bx, 160
jl cd02
mov bx, 3840
cd03:
call print
cmp bx, 4000
jl cd03     
ret

resetbx:
mov bx, 160   
call pushbx
jmp texteditor
resetbx2:
mov bx, 160 
ret

;exiting:
;mov ax, 0x0003
;int 0x10
;hlt


;0x10000 - text data
;
;
;

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
mov ax, 00092 ;version number, digits 1 and 3 is discarted 
CALL COMPARE 
MOV AH, 0x70 ;(THEME)
;MOV AL, BL
;CALL ce 
;MOV BL, AL
mov bx, 3990
mov al,"V"
call forcompareb
mov bx, 3994
mov al,"."
call print
popa
;ret

forcompare:
pusha
mov ax, bx
CALL COMPARE 
MOV AH, 0x70 ;(THEME)
MOV AL, BL
ADD AL, 0x30 
;MOV BL, AL
mov bx, 3840
call forcompareb
popa
jmp texteditor
forcompareb:
CALL print
;--------------
MOV AL, CH
ADD AL, 0x30
;MOV CH, AL 
CALL print
;--------------
MOV AL, CL
ADD AL, 0x30
;MOV CL, AL
CALL print
;--------------
MOV AL, DH
ADD AL, 0x30 
;MOV DH, AL
CALL print
;--------------
MOV AL, DL
ADD AL, 0x30
;MOV DL, AL
CALL print          
ret

;---------------------------------
;MOV AX, 0x3C00
;mov bx, 0
;mov cx, 0 
;mov dx, 0 
compare:
mov bx, 0
mov cx, bx 
mov dx, bx
comp01:
cmp ax, bx
je tocomp02 
inc bx
inc dl
cmp dl, 0x0a
jne comp01
mov dl, 0
inc dh
cmp dh, 0x0a
jne comp01
mov dh, 0 
inc cl
cmp cl, 0x0a
jne comp01
mov cl, 0
inc ch
jne comp01  

tocomp02:
mov bx, 0
mov es, ax
mov ax, bx
comp02:
cmp ch, bh
je toexit
inc bh
inc al
cmp al, 0x0a
jne comp02
mov al, 0
inc ah 
cmp ah, 0x0a
jne comp02

toexit:
mov ch, al
mov bl, ah
mov ax, es

exit:

ret

  
; CHANGE LOG
; -Optimized COMPARE
;
;
;
;
