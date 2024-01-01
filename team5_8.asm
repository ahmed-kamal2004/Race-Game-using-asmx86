extrn powerUpBlue:byte
extrn powerUpRed:byte
extrn enablePowerUpBlue:byte
extrn enablePowerUpRed:byte
extrn username1:byte
extrn username2:byte
extrn powerUpRed:byte
extrn second:byte
extrn is_Blue_Win:byte
public PowerUp
.model small
.code

PowerUp proc far 
mov ah,2h
mov bh,0h
mov dh,23d
mov dl,4d
int 10h
 
 mov ah,9h
 lea dx,username1
 int 21h
;;powerup numbers
mov ah,2h
mov bh,0h
mov dh,24d
mov dl,4d
int 10h

mov ah,2h
 mov dl,enablePowerUpBlue
  add dl,30h
 int 21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;user two
mov ah,2h
mov bh,0h
mov dh,23d
mov dl,20d
int 10h
 
 mov ah,9h
 lea dx,username2
 int 21h

mov ah,2h
mov bh,0h
mov dh,24d
mov dl,20d
int 10h

mov ah,2h
 mov dl,enablePowerUpRed
 add dl,30h
 int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;timer
mov ah,0h
mov al,second
mov dl,60d;;get minute
div dl
mov bl,ah;seconds

mov ah,2h;mov curser
mov bh,0h
mov dh,24d
mov dl,27d
int 10h
;;;print minute
mov ah,2h
 mov dl,al
 add dl,30h
 int 21h

mov ah,2h
 mov dl,':'
 int 21h
 ;;;;;;;;;;;;;;;;;;;;; print second
 mov ah,0h
mov al,bl
mov dl,10d;for print second
div dl
mov bl,ah

;;;second digit
mov ah,2h
 mov dl,al
 add dl,30h
 int 21h
 ;;;first
 mov ah,2h
 mov dl,bl
 add dl,30h
 int 21h

RET
 PowerUp endp
 end