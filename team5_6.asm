extrn CarRedimg:byte
extrn CarBlueimg:byte
extrn username1:byte;;;untill ahmed send
extrn username2:byte;;;untill ahmed send
public design
.model small
.code
design proc far
;;;;; drow car for design only nesma
lea si,CarRedimg
mov di,32200d;row 100 colunm 150
mov bx,58d
cardraw:
mov cx,100d
repe movsb
add di,220d
dec bx
cmp bx,0
jnz cardraw

lea si,CarBlueimg
mov di,32030d;row 100 colunm 150
mov bx,56d
carBluedraw:
mov cx,100d
repe movsb
add di,220d
dec bx
cmp bx,0
jnz carBluedraw
;;;;;untill ahmed send FOR PRINT NAME
mov ah,02h
mov dl, 4D  ;Column
mov dh, 22D  ;Row
mov bh,00h
int 10h
mov ah,09h
lea dx,username1
int 21h

;;;;SECOND ONE
mov ah,02h
mov dl, 23D ;Column
mov bh,0h
mov dh, 22D  ;Row
int 10h
mov ah,09h
lea dx,username2
int 21h

mov ah,0h
int 16h

ret
design endp
end