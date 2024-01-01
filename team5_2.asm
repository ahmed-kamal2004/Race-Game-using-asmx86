extrn rand:byte
extrn Track_col:byte
extrn draw_or_store:byte
extrn index_power:byte
extrn isBorder:byte
extrn coming_from:byte
extrn canDraw:byte
extrn finish_color:byte
extrn can_obstacle:byte
extrn powColors:byte
extrn curX:word
extrn curY:word
extrn first_time:byte
extrn drawn_len:word
extrn power_col_sto: word 
extrn power_ups:word
wid equ 30d
len equ 65d
obstacle_wid equ 7d
obstacle_len equ 7d
obstacle_col equ 0fh
border_col equ 0h
obstacle_gap equ 3d
obs_range equ 6
chat_width equ 30d
finish_width equ 5d
.model small
.code
public draw_track
draw_track proc far
mov ax,0A000h
mov es,ax
mov ah,0
mov al,13h
int 10h
mov ah,2ch;get system time to get random value
int 21h
mov dh,00h
mov ax,dx
mov bl,4
div bl
mov coming_from,0D
mov cx ,285
mov dx ,160
mov si,10000
main_func:
push si
push cx
push dx
mov ah,2ch;get system time to get random value
int 21h
mov dh,00h
mov ax,dx
mov bl,4
div bl
mov bh,ah
pop dx
pop cx
cmp first_time,1
jnz up
mov bh,0
mov first_time,0
;------------------>get random value in bh
up:
cmp bh,0h
jnz down ;jump if the random val doesn't match
TryUp:
cmp coming_from ,1d ; 0->up 1-> down 2-> right 3-> left
jz jumpD
mov curX,cx
mov curY,dx
cmp coming_from ,0
jnz right_up
dec dx
right_up:
cmp coming_from,02
jnz left_up
sub cx,wid-1
add dx,wid-1
jmp check_up
left_up:
cmp coming_from ,03
jnz check_up
add dx,wid-1
check_up:
push ax
push bx
push cx
push dx
call checkUp
pop dx
pop cx
pop bx
pop ax
cmp canDraw,0
jnz drawUP
mov cx,curX
mov dx,curY
jmp jumpD
drawUP:
call draw_up
mov coming_from , 0d
mov canDraw,1
push cx
push dx
mov ah,2ch;get system time to get random value
int 21h
mov dh,00h
mov ax,dx
mov bl,2
div bl
mov bh,ah
pop dx
pop cx
cmp bh,0
jz JTryLeft
jmp TryRight
JTryLeft:
jmp TryLeft
jumpD:
jmp decrement
;try to draw down
down:
cmp bh,01h
jnz right
TryDown:
cmp coming_from ,0d ; 0->up 1-> down 2-> right 3-> left
jz jumpD
mov curX,cx
mov curY,dx
cmp coming_from , 1d
jnz right_down
inc dx
right_down:
cmp coming_from ,2d
jnz left_down
sub cx,wid-1
left_down:
cmp coming_from , 3d
jz check_down
check_down:
push ax
push bx
push cx
push dx
call checkDown
pop dx
pop cx
pop bx
pop ax
cmp canDraw,0
jnz drawDown
mov cx,curX
mov dx,curY
jmp jumpD
drawDown:
call draw_down
mov coming_from , 1d
mov canDraw,1
push cx
push dx
mov ah,2ch;get system time to get random value
int 21h
mov dh,00h
mov ax,dx
mov bl,2
div bl
mov bh,ah
pop dx
pop cx
cmp bh,0
jz JTryRight1
jmp TryLeft
JTryRight1:
jmp TryRight
jumpMain:
jmp main_func
;try to draw right
right:
cmp bh,02h
jnz left
TryRight:
cmp coming_from ,3d ; 0->up 1-> down 2-> right 3-> left
jz jumpDec
mov curX,cx
mov curY,dx
cmp coming_from ,2d
jnz up_right
inc cx
up_right:
cmp coming_from , 00d
jz down_right
down_right:
cmp coming_from ,1d
jnz check_right
sub dx,wid-1
check_right:
push ax
push bx
push cx
push dx
call checkRight
pop dx
pop cx
pop bx
pop ax
cmp canDraw,0
jnz drawRight
mov cx,curX
mov dx,curY
jmp jumpDec
drawRight:
call draw_right
mov coming_from , 2d
jumpDec:
jmp decrement
jumpjumpMain:
jmp jumpMain
;try to draw left
left:
cmp bh,03h
jnz decrement
TryLeft:
cmp coming_from ,2d ; 0->up 1-> down 2-> right 3-> left
jz decrement
mov curX,cx
mov curY,dx
cmp coming_from,3
jnz up_left
dec cx
up_left:
cmp coming_from,00d
jnz down_left
add cx,wid-1
jmp check_left
down_left:
cmp coming_from,1d
jnz check_left
add cx,wid-1
sub dx,wid-1
check_left:
push ax
push bx
push cx
push dx
call checkLeft
pop dx
pop cx
pop bx
pop ax
cmp canDraw,0
jnz drawLeft
mov cx,curX
mov dx,curY
jmp decrement
drawLeft:
call draw_left
mov coming_from ,3d
decrement:
pop si
dec si
mov canDraw,1
jz MainReturn
jmp jumpjumpMain
MainReturn:
cmp coming_from ,0
jne down_end
call rl_finish
jmp mega_return
down_end:
cmp coming_from , 1
jne right_end
add dx,finish_width
call rl_finish
jmp mega_return
right_end:
cmp coming_from,2
jne left_end
add dx,wid
call du_finish
jmp mega_return
left_end:
cmp coming_from,3
jne mega_return
add dx,wid
sub cx,finish_width
call du_finish
mega_return:
ret 
draw_track endp


;-------------------------------------------------------------------------------------
;function to draw up
draw_up proc
mov di,len
mov drawn_len,0
vertical:
mov si,wid
push di
cmp drawn_len,obstacle_len
jg checkWidth
mov can_obstacle,0
jmp horizontal
checkWidth:
mov ax,len
sub ax,drawn_len
cmp ax,wid
jg check10
mov can_obstacle,0
jmp horizontal
check10:
mov ax,drawn_len
mov bl ,3*obstacle_len;try to draw an obstacle every 3*obstacle_len to prevent stacking obstacles
div bl
cmp ah,0
jz random_obs
mov can_obstacle,0
jmp horizontal
random_obs:
call getRand
dec bh
cmp bh,obs_range
jge normal_track
mov can_obstacle,bh
horizontal:
cmp can_obstacle , 00d
je normal_track
mov ax,wid
sub ax,si
cmp ax,obstacle_gap
jl normal_track
cmp si , obstacle_wid ; not to draw the obstacle out of track width
jl normal_track
call getRand
mov ax , cx
div bh
cmp ah,0 
jnz normal_track
push cx
push dx
push di
push si
add dx,obstacle_len ;so that we don't draw the track over the obstacle
call draw_obstacle
pop si
pop di
pop dx
pop cx
mov can_obstacle,0d
normal_track:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,Track_col
stosb
inc cx
dec si
jnz horizontal
sub cx,wid
dec dx
inc drawn_len
pop di
dec di
jnz jmpvertical
inc dx
jmp returnDrawUP
jmpvertical:
jmp far ptr vertical
returnDrawUP:
ret
draw_up endp
;function to draw right
draw_right proc
mov di,len
mov drawn_len,0
horizontal_r:
mov si,wid
push di
cmp drawn_len,obstacle_len;not to draw an obstacle outside the track
jg check_wid_r
mov can_obstacle,0
jmp normal_trackR
check_wid_r:
cmp di,wid
jle normal_trackR
check10R:
mov ax,drawn_len
mov bl,3*obstacle_len
div bl
cmp ah,0
jnz normal_trackR
call getRand
dec bh
cmp bh,obs_range
jge normal_trackR
mov can_obstacle,bh
vertical_r:
cmp can_obstacle,0
je normal_trackR
mov ax,wid
sub ax,si
cmp ax,obstacle_wid+obstacle_gap
jl normal_trackR
call getRand
mov ax,dx
div bh
cmp ah,0
jne normal_trackR
push cx
push dx
push di
push si
sub cx,obstacle_len;so that we don't draw the track over the obstacle
call draw_obstacle
pop si
pop di
pop dx
pop cx
mov can_obstacle,0d
normal_trackR:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,Track_col
stosb
inc dx
dec si
jnz vertical_r
sub dx,wid
inc cx
inc drawn_len
pop di
dec di
jnz jmpHorizontalr
jmp dec_cx
jmpHorizontalr:
jmp far ptr horizontal_r
dec_cx:
dec cx
ret 
draw_right endp
;function to draw down
draw_down proc
mov di,len
mov drawn_len,0
verticalD:
mov si,wid
push di
cmp drawn_len,obstacle_len;to check if the drawn length is less than the obstacle length
jg check_wid_D
mov can_obstacle,0
jmp horizontalD
check_wid_D: ;check 
cmp di,wid
jl normal_trackD
check10d:
mov ax,drawn_len
mov bl ,3*obstacle_len;try to draw an obstacle every 3*obstacle_len to prevent stacking obstacles
div bl
cmp ah,0
jz random_obsD
mov can_obstacle,0
jmp horizontalD
random_obsD:
call getRand
dec bh
cmp bh,obs_range
jge normal_trackD
mov can_obstacle,bh
horizontalD:
cmp can_obstacle , 00d
je normal_trackD
mov ax,wid
sub ax,si
cmp ax,obstacle_gap
jl normal_trackD
cmp si , obstacle_wid ; not to draw the obstacle out of track width
jl normal_trackD
call getRand
mov ax , cx
div bh
cmp ah,0 
jnz normal_trackD
push cx
push dx
push di
push si
dec dx
call draw_obstacle
pop si
pop di
pop dx
pop cx
mov can_obstacle,0d
normal_trackD:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,Track_col
stosb
inc cx
dec si
jnz horizontalD
sub cx,wid
inc dx
inc drawn_len
pop di
dec di
jnz jmpverticalD
dec dx
jmp returnDrawD
jmpverticalD:
jmp far ptr verticalD
returnDrawD:
ret
draw_down endp

;function to draw left
draw_left proc
mov di,len
mov drawn_len,0
horizontalL:
mov si,wid
push di
cmp drawn_len,obstacle_len
jl normal_trackL
mov bl,3*obstacle_len
mov ax,drawn_len
div bl
cmp ah,0
jnz normal_trackL
cmp di,wid 
jl normal_trackL
call getRand
dec bh
cmp bh,obs_range
jge normal_trackL
mov can_obstacle,bh
VerticalL:
cmp can_obstacle,0
je normal_trackL
cmp si,obstacle_gap
jl normal_trackL
mov ax,wid
sub ax ,si
cmp ax,obstacle_wid+obstacle_gap
jl normal_trackL
call getRand
mov ax,dx
div bh
cmp ah,0
jne normal_trackL
push cx
push dx
push di
push si
add cx,1
call draw_obstacle
pop si
pop di
pop dx
pop cx
mov can_obstacle,0d
normal_trackL:
mov ax,dx
push dx
mov bx,320d
mul bx
add ax,cx
mov di,ax
mov al,Track_col
stosb
pop dx
inc dx
dec si
jnz VerticalL
sub dx,wid
dec cx
inc drawn_len
pop di
dec di
jnz horizontalL
inc cx
ret
draw_left endp

;function to check the path to be drawn up
checkUp proc
mov ax,dx
sub ax,len  
cmp ax,00h
jl falseU ; jmp to return if dx  is out of borders
;check the path to be drawn
mov di,len
sub dx,wid+1
sub cx,5
vertical_up_check:
mov si,wid+10
push di
horizontal_up_check:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,Track_col
scasb
je popU
inc cx
dec si
jnz horizontal_up_check
sub cx,wid+10
dec dx
pop di
dec di
jnz vertical_up_check
jmp returnU
popU:
pop di
falseU:
mov canDraw,0
returnU:
ret
checkUp endp

;function to check the path to be drawn down

checkDown proc
mov ax,dx
add ax,len  
cmp ax,199d-chat_width
jg falseD ; jmp to return if dx  is out of borders
add dx,wid+1
sub cx,5
mov di,len
verticalD_check:
mov si,wid+10
push di
horizontalD_check:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,Track_col
scasb
je popD
inc cx
dec si
jnz horizontalD_check
sub cx,wid+10
inc dx
pop di
dec di
jnz verticalD_check
jmp returnD
popD:
pop di
falseD:
mov canDraw,0
returnD:
ret
checkDown endp
;function to check the path to be drawn right
checkRight proc
mov ax,cx
add ax,len  
cmp ax,319d
jg falseR ; jmp to return if it is out of borders
add cx,wid+1
sub dx,5
mov di,len
horizontal_r_check:
mov si,wid+10
push di
vertical_r_check:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,Track_col
scasb
je popR
inc dx
dec si
jnz vertical_r_check
sub dx,wid+10
inc cx
pop di
dec di
jnz horizontal_r_check
jmp ReturnR
popR:
pop di
falseR:
mov canDraw,0
ReturnR:
ret
checkRight endp
;function to check the path to be drawn left
checkLeft proc
mov ax,cx
sub ax,len  
cmp ax,00d
jl falseL ; jmp to return if it is out of borders
sub cx,wid+1
sub dx,5
mov di,len
horizontalL_check:
mov si,wid+10
push di
VerticalL_check:
mov ax,dx
push dx
mov bx,320d
mul bx
pop dx
add ax,cx
mov di,ax
mov al,Track_col
scasb
je popL
inc dx
dec si
jnz VerticalL_check
sub dx,wid+10
dec cx
pop di
dec di
jnz horizontalL_check
jmp returnL
popL:
pop di
falseL:
mov canDraw,0
returnL:
ret
checkLeft endp
;------------function to draw an obstacle or a power up
draw_obstacle proc
mov di,obstacle_len
cmp can_obstacle,1
je vertical_ob
call getRand
cmp bh,6d
jl vertical_ob
mov bl,index_power
mov bh ,0
mov word ptr [power_ups+bx],cx
add bx,2
mov word ptr [power_ups+bx],dx
push bx
mov bh,0
mov bl,can_obstacle
dec bx
mov al,byte ptr[powColors+bx]
pop bx
add bx,2
mov ah,0
mov word ptr [power_ups+bx],ax
add index_power,6
jmp returnObs
vertical_ob:
mov si,obstacle_wid
push di
horizontal_ob:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov bh,0
mov bl,can_obstacle
dec bx
mov al,byte ptr[powColors+bx]
drawObs:
stosb
inc cx
dec si
jnz horizontal_ob
sub cx,obstacle_wid
dec dx
mov isBorder,0
pop di
dec di
jnz vertical_ob
inc dx
cmp can_obstacle,1
jne returnObs
call drawX
returnObs:
ret
draw_obstacle endp 
getRand proc
push cx
push dx
mov ah,2ch;get system time to get random value
int 21h
mov dh,00h
mov ax,dx
add rand,1
mov bl,rand
div bl
mov bh,ah
pop dx
pop cx
cmp rand,20
jl returnRand
mov rand,2
returnRand:
add bh,2
ret
getRand endp
; function to draw X
drawX proc
push cx
push dx
mov di,7
line1:
push di
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,border_col
stosb
inc cx
inc dx
pop di
dec di
jnz line1
dec cx
dec dx
sub cx,6
mov di,7
line2:
push di
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,border_col
stosb
inc cx
dec dx
pop di
dec di
jnz line2
pop dx
pop cx
ret
drawX endp
finish_square proc
dec dx
mov di,finish_width
vertical_finish:
mov si, finish_width
push di
horizontal_finish:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov al,finish_color
stosb 
inc cx
dec si
jnz horizontal_finish
sub cx,finish_width
dec dx
pop di
dec di
jnz vertical_finish
add cx ,finish_width
add dx,finish_width
inc dx
ret
finish_square endp
rl_finish proc
mov di,6d
repea_:
push di
cmp finish_color , 0ch
jne change_col
mov finish_color,3h
jmp draw
change_col:
mov finish_color,0ch
draw:
call finish_square
pop di
dec di
jnz repea_
ret
rl_finish endp
du_finish proc
mov di,6d
repa:
push di
cmp finish_color,0ch
jne change_color_u
mov finish_color,3h
jmp draw_
change_color_u:
mov finish_color,0ch
draw_:
call finish_square
sub cx,finish_width
sub dx,finish_width
pop di
dec di
jnz repa
ret
du_finish endp
end











