start: 
call cleardisplay ;COMMENT THIS LINE WHEN USING A EMULATOR
call resetbx2
call pushbx                                    
call forcompare2
;call forcompare
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

datafull:




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
mov ax, 00091 ;version number, digits 1 and 3 is discarted 
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
CALL ce 
;MOV BL, AL
mov bx, 3840
call forcompareb
popa
jmp texteditor
forcompareb:
CALL print
;--------------
MOV AL, CH
CALL ce 
;MOV CH, AL 
CALL print
;--------------
MOV AL, CL
CALL ce 
;MOV CL, AL
CALL print
;--------------
MOV AL, DH
CALL ce 
;MOV DH, AL
CALL print
;--------------
MOV AL, DL
CALL ce 
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
mov ax, 0
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

ce:
cmp al, 0    
je ce0 
cmp al, 1    
je ce1 
cmp al, 2    
je ce2 
cmp al, 3    
je ce3 
cmp al, 4    
je ce4 
cmp al, 5    
je ce5 
cmp al, 6    
je ce6 
cmp al, 7    
je ce7 
cmp al, 8    
je ce8 
cmp al, 9    
je ce9
ce0:
mov al, "0" 
ret 
ce1:
mov al, "1" 
ret
ce2:
mov al, "2" 
ret
ce3:
mov al, "3" 
ret
ce4:
mov al, "4" 
ret
ce5:
mov al, "5" 
ret
ce6:
mov al, "6" 
ret
ce7:
mov al, "7" 
ret
ce8:
mov al, "8" 
ret
ce9:
mov al, "9" 
ret  

; CHANGE LOG
; -1st Version Published
; -Print Version no.
;
;
;
