extrn Current_Y:WORD
extrn Current_X:WORD
extrn Track_color:BYTE
extrn Draw_Request:BYTE
public draw
.model small
.code
draw PROC far

    ; cmp Draw_Request,1h
    ; je Start
    ;  ;; Checking for not writing outside the Track

    ;  ; Check for upper left Corner
    ;  mov dx,Current_Y
    ;  mov cx,Current_X
    ;  mov ah,0Dh
    ;  int 10h
    ;  cmp al,Track_color
    ;  jnz L4

    ;  ; Check for upper right Corner
    ;  mov cx,Current_X[2]
    ;  mov ah,0Dh
    ;  int 10h
    ;  cmp al,Track_color
    ;  jnz L4

    ;  ; Check for down left Corner
    ;  mov dx,Current_Y[2]
    ;  mov ah,0Dh
    ;  int 10h
    ;  cmp al,Track_color
    ;  jnz L4

    ;  ; Check for down right Corner
    ;  mov cx,Current_X
    ;  mov ah,0Dh
    ;  int 10h
    ;  cmp al,Track_color
    ;  jnz L4

    ;  ; Check for middle point
    ;  sub dx,5d
    ;  add cx,5d
    ;  mov ah,0Dh
    ;  int 10h
    ;  cmp al,Track_color
    ;  jnz L4

    ; Start:

                          mov  bx,0
                          mov  dx,Current_Y
     L1:                  
                          mov  ah,0ch
                          mov  cx,Current_X
     L2:                  
                          inc  cx
                          push cx
                          push dx
                          mov  al,[si]
                          inc  si
                          int  10h
                          pop  dx
                          pop  cx
                          cmp  cx,Current_X[2]
                          je   L3
                          jmp  L2
     L3:                  
                          inc  dx
                          cmp  dx,Current_Y[2]
                          jb   L1
    ;  L4:
                          ret
draw ENDP
end