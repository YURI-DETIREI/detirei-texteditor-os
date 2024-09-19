call cleardisplay ;comment if using a SLOW! emulator
jmp start

cleardisplay:
xor bx, bx
mov ax, 0x7720 ;(THEME) ;LIGHT: 0020; DARK: 7720;
cd01:
call print
cmp bx, 4000
jl cd01 
mov bx, 160
mov ax, 0x00ff ;(THEME) 
cd02:
call print
cmp bx, 3840
jl cd02    
ret

start:
mov bx, 160 
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
cmp al, 0x07 ; CTRL G
je offset0
;data write
call write
call popbx  
call print
cmp bx, 3840
jge resetbx
texteditorfinal: 
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
push ax
mov ax, 0x1000
mov ds, ax
pop ax 
cmp bx, 0xffff
je texteditor
mov b.[bx], al  ;  S
inc bx        
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
mov al, 0xff
sub bx, 2
call print    
call print
sub bx, 4
backspace1:
sub bx, 2 
call readscr
cmp al, 0xff
je backspace1
add bx, 2  
jmp texteditorfinal

offs:



enter:
call write
call enterlogic
call pushbx  
call forcompare
jmp texteditor 
enterlogic:   
call popbx
mov al, 0xff
call print
sub bx, 2 
;mov dx, bx
xor dx, dx
enter1:
add dx, 160
cmp bx, dx
jnl enter1
enter2:
add bx, 2
cmp bx, dx
jne enter2
;mov bx, dx
cmp bx, 3840
jge resetbx
ret
  

datafull:




resetbx:
mov bx, 160   
call pushbx
jmp texteditor

readscr:   
mov ax, 0xb800
mov ds, ax
mov ax, w.[bx]  ;  S    
ret

print:    
push ax
mov ax, 0xb800
mov ds, ax
pop ax
mov w.[bx], ax  ;  S
add bx, 2    
ret


kbget:
mov ah, 0
int 0x16
ret

forcompare2:
pusha
mov bx, 0x0094 ;version number, digit 3 is discarted  
CALL COMPARE 
MOV AX, 0x7056
mov bx, 3990 
CALL print  
call forcompareb
MOV BX, 3994
mov al, "."
call print 
popa


forcompare:
pusha
CALL COMPARE
mov ah, 0x70
mov bx, 3840
call forcompareb 
popa
jmp texteditor
forcompareb:
call forcomparec
mov dx, cx
;call forcomparec
;ret
forcomparec:
;--------------
MOV AL, DH
call asciih 
;--------------
MOV AL, DL 
call asciih
;--------------
;MOV AL, DH 
;call asciih
;--------------
;MOV AL, DL 
;call asciih          
ret

COMPARE:
call COMPARELOGIC
mov cx, dx  
mov bl, bh
COMPARELOGIC:
mov ah, 0
mov al, bl
mov dl, bl
and dl, 0x0f
and al, 0xf0
mov dh, 0x10
div dh
mov dh, al
;mov ah, 0
;mov al, bh
;mov cl, bh
;and cl, 0x0f
;and al, 0xf0
;mov ch, 0x10
;div ch
;mov ch, al
ret

asciih:          
push bx
mov bx, 0x07c0
mov ds, bx ; org 0x7c00
mov ah, 0
mov bx, [ascii]
add bx, ax
mov al, b.[bx] 
pop bx
mov ah, 0x70 
CALL print
ret
ascii:
db "0123456789ABCDEF"  
; CHANGELOG
; - Counter is in hexadecimal
; - (ULTRA) Optimized Code
; - changed clear char from 0x20 to 0xff (except in bars)
; - Better Backspace
; - Added jump to offset

readdat:   
mov ax, 0x1000
mov ds, ax
mov al, b.[bx]  ;  S    
ret

;-------------------------------------- 
kbgetp:
call kbget
mov ah, 0x07
call print
mov cl, al
cmp cl, 0x41
jl kbgetp1 
sub cl, 7
kbgetp1:
ret        

TOHEX:
;mov al, 0x10
;mul dh
;mov bl, al 
;add dl, 0xf0
;add bl, 0x0f
;and bl, dl
mov al, 0x10
mul ch
mov dh, al
add cl, 0xf0
add dh, 0x0f
and dh, cl
ret

offset0:
call kbgetp
mov ch, cl
call kbgetp
call TOHEX    
call kbgetp
mov ch, cl
call kbgetp
mov bh, dh
call TOHEX
mov bl, dh
;------------------- end
push bx
call popbx
call cleardisplay
mov bx, 160
writetovid: 
call pushbx
call readdat
inc bx
mov ah, 0x07
cmp al, 0x0d ; Enter
je calenterlogic
writetovid2:
call popbx
call print
cmp bx, 3840
jl writetovid
mov bx, 160 
;call pushbx 
pop bx                                    
call forcompare2


calenterlogic:
call enterlogic
jmp writetovid