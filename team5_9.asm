extrn username:byte
extrn username1:byte
extrn username2:byte
extrn Blue_Timing:WORD
extrn Red_Timing:WORD
extrn InitialNumber:byte
extrn InitialNumber1:byte
extrn InitialNumber2:byte
extrn privsecond:byte
extrn Red_Current_X:WORD
extrn Red_Current_Y:WORD
extrn Blue_Current_X:WORD
extrn Blue_Current_Y:WORD
EXTRN Current_x:WORD
EXTRN Current_Y:WORD
EXTRN red_car_front:BYTE
EXTRN Blue_car_front:BYTE
extrn second:byte
extrn draw:far
extrn login:far
extrn choose:far
extrn CARBLUE:far
extrn CARRED:far
extrn design:far
extrn origInt9Offset:WORD
extrn origInt9Segment:WORD
extrn flag_blue:BYTE
extrn flag_red:BYTE
extrn PowerUp:far
extrn Red_Run_Power_Up:BYTE
extrn Blue_Run_Power_Up:BYTE
extrn power_ups:word
extrn index_power:byte
extrn curPowInd:byte
extrn power_col_sto: word 
extrn enablePowerUpRed:byte
extrn enablePowerUpBlue:byte
extrn first_time:byte
obstacle_wid equ 7d
obstacle_len equ 7d

extrn draw_track:far
extrn is_Blue_Win:byte
extrn is_Red_Win:byte
extrn no_one_win:byte
extrn player_win:byte
extrn F4_Pressed:BYTE
public submain
.model small
.stack 64h
.code
submain proc far

     mov  AX,@data
     mov  DS,AX
         mov bx,1d
         call login
         lea si,username[2]
         lea di,username1
         ;;;;;;;;;;;;;;UNTILL AHMED
         MOV CX,15D
         rep movsb

         MOV CX,15D
         lea di,username[2]
         mov al,'$'
         rep stosb 
        
        ;;;;;;;;;;;;;;;;;;;;;;;;
         mov cl,InitialNumber
         mov InitialNumber1,cl


;;;;player2
         mov bx,2d
         call login
         lea si,username[2]
         lea di,username2
         ;;;;UNTILL AHMED
          MOV CX,15D
         REP movsb
        ;;;;;;;;;;;;;;;;;;;
          mov cl,InitialNumber
          mov InitialNumber2,cl
          ;;;;;;;;;;;;;;;;
          mov  ah,0003h
          mov  cx,00h
          mov  dx,184fh
          int  10h
     chooselabel:     call choose

      ;;;;;;;;;;;;;;;;;;;;initialize
            ; mov  AX,@data                         ;initializing the data segemnt
                          ;mov  DS,AX
                          mov  ax,0003h
                          int  10h
                          mov  ax,0A000h                        ; to graphics screen
                          mov  es,ax
                          mov  ah,0                             ; 320 * 200
                          mov  al,13h
                          int  10h   
          call design
          mov si,00
          printBlackScreen:
          mov ax,si
          mov bx,320d
          mul bx
          mov di,ax
          mov ax,0000h
          mov cx,320d
          repe stosb
          add si,1d
          cmp si,200d
          jnz printBlackScreen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;initialize track variable for the second game
mov first_time,1
mov index_power ,0
mov curPowInd , 0
          ;;;;;;;;;;;;;;;;;;;;
             call draw_track
             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
              mov enablePowerUpRed,0D
                    mov enablePowerUpBlue,0D
                    mov Red_Run_Power_Up,0D
                    mov Blue_Run_Power_Up,0D
          MOV is_Blue_Win,0d
          MOV is_Red_Win,0d
          MOV F4_Pressed,0D
          MOV second,120D
          MOV Blue_Current_X[0], 286d
          MOV Blue_Current_X[2], 296d
          MOV Blue_Current_Y [0] ,  150d
          MOV     Blue_Current_Y [2] ,160d
               MOV Red_Current_X[0], 300d
          MOV Red_Current_X[2],310d
          MOV Red_Current_Y [0] ,  150d
          MOV     Red_Current_Y [2] ,160d
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;untill ahmed
          mov di,57600d ;180 row
          mov cx,320d
          mov al,0fh
          rep stosb
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;nesma
          
   

prev:
mov ah,2ch;;to sheck seconds
int 21h
mov privsecond,dh
;;;;nesma end now all screen is black
     ;; printing the shape first time
     ; Red Drawing the shape
                    mov  bx,Red_Current_X[0]
                    mov  Current_X[0],bx
                    mov  bx,Red_Current_X[2]
                    mov  Current_X[2],bx
                    mov  bx,Red_Current_Y[0]
                    mov  Current_Y[0],bx
                    mov  bx,Red_Current_Y[2]
                    mov  Current_Y[2],bx
                    lea  ax,red_car_front
                    mov  si,ax
                    xor  ax,ax
                    call draw
; Blue Drawing the shape
                    mov  bx,Blue_Current_X[0]
                    mov  Current_X[0],bx
                    mov  bx,Blue_Current_X[2]
                    mov  Current_X[2],bx
                    mov  bx,Blue_Current_Y[0]
                    mov  Current_Y[0],bx
                    mov  bx,Blue_Current_Y[2]
                    mov  Current_Y[2],bx
                    lea  ax,blue_car_front
                    mov  si,ax
                    xor  ax,ax
                    call draw

                    CLI
                    push  AX
                    push  BX
                    push  CX
                    push  DX
                    push  SI
                    push  DI
                    push  BP
                    push  SP
                    pushF
                    mov  ax, 3509h
                    int  21h
                    mov  origInt9Offset, bx
                    mov  origInt9Segment, es
                    popF
                    pop   SP
                    pop   BP
                    pop   DI
                    pop   SI
                    pop   DX
                    pop   CX
                    pop   BX
                    pop   AX
                    push ds
                    mov  ax, cs
                    mov  ds, ax
                    mov  ax, 2509h
                    lea  dx, overRide9H
                    int  21h
                    pop  ds
                    STI


                    ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;


          ;;;;;;;;;;;;;;;;;;;;;
          push di
          push si
          push ax
          call PowerUp;;11/12/2023


          pop AX
          pop si
          pop di
           
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          Time:;for timer
          mov ah,2ch;get time
          int 21h
          cmp dh,privsecond;still in the same second
          jz secondcheck;return to game
          dec second
          mov privsecond,dh
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POWER UP GENERTE;;;
          mov al,second
          mov ah,0
          mov bl,5
          div bl
          cmp ah,0
          jnz secondcheck
          call draw_stored
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          secondcheck:
          mov cx,Red_Timing
          makeRed:
          cmp F4_Pressed,1D
          jz FINISh_PROGRAM_GAME
               push cx
               CALL CARRED
                                              
                          pop cx
                            cmp is_Red_Win,1
                             jz   FINISh_PROGRAM_GAME   
               dec cx 
               jnz makeRed
               ;;;;;;;;;;;;;;;;;;;;;
              jmp after_braek_time
               time_break_jmp:
               jmp time
               after_braek_time:
               ;;;;;;;;;;;;;;;;;;;;;;
          mov cx,Blue_Timing
            cmp F4_Pressed,1D
          jz FINISh_PROGRAM_GAME
          makeblue:
               push cx
               CALL CARBLUE
               
                                   
                                            pop cx
                             cmp is_Blue_Win,1
                             jz   FINISh_PROGRAM_GAME                        

               dec cx 
               jnz makeblue
               

mov cx,0FFFFH
makeloop:
dec cx
jnz  makeloop
          ;;;;;;;;;;;
          push di
          push si
          push ax
          call PowerUp;;11/12/2023
          pop AX
          pop si
          pop di
          ;;;;;;;;;;;;;;;;;;;;
          cmp is_Red_Win,1
          jz FINISh_PROGRAM_GAME
          cmp second,0;the 2 minute finish
          jnz time_break_jmp;still not finish
          jmp FINISh_PROGRAM_GAME
               FINISh_PROGRAM_GAME:;;show page
                   mov  ax,0003h;clear screen
                   int  10h
               mov ah,2ch;;to sheck seconds
               int 21h
               mov privsecond,dh  
               mov second,5d
                   timeshow:
                    mov ah,02h
                    mov dl, 24D ;Column
                    mov bh,0h
                    mov dh, 10D  ;Row
                    int 10h
                    mov ah,09h
                    lea dx,player_win
                    int 21h
                    mov ah,02h
                    mov dl, 24D ;Column
                    mov bh,0h
                    mov dh, 13D  ;Row
                    int 10h
                     cmp is_Blue_Win,1D
                    jz playerBlue
                    cmp is_Red_Win,1
                    jz playerRed
                    jmp no_pal
                    playerBlue:
                    lea dx,username1
                    jmp printwiner
                    playerRed:
                    lea dx,username2
                    jmp printwiner
                    no_pal:
                    lea dx,no_one_win

                    printwiner:
                    mov ah,09 
                    int 21h



                    mov ah,2ch;get time
                    int 21h
                    cmp dh,privsecond;still in the same second
                    jz timeshow;return to game
                    dec second
                   mov privsecond,dh

                    cmp second,0D
                    jnz timeshow
                   
                    CLI
                    mov ax, origInt9Segment
                    mov dx, origInt9Offset
                    
                    push ds
                    mov ds, ax

                    mov ax, 2509h
                    int 21h
                    ; Re-enable interrupts
                    pop ds
                    STI

                     ;; الكطلوب تصفير كل شي


                    jmp far ptr chooselabel
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POWER UP GENERTE;;;
         
                   ; mov ah,4ch
                    ;int 21h
                    ret
submain endp



overRide9H PROC
                 in   al, 60h                ; read scan code
    ; For RED
    ; Checking for pressing UP RED
                 cmp  al, 48h
                 jnz  not_pressed
                 mov  flag_red,48h
    not_pressed: 
                 cmp  al, 48h + 80h
                 jnz  not_release
                 mov  flag_red,8
    not_release: 
    ; Checking for pressing DOWN RED
                 cmp  al, 50h
                 jnz  not_pressed1
                 mov  flag_red,50h
    not_pressed1:
                 cmp  al, 50h + 80h
                 jnz  not_release1
                 mov  flag_red,8
    not_release1:
    ; Checking for pressing LEFT RED
                 cmp  al, 4bh
                 jnz  not_pressed2
                 mov  flag_red,4bh
    not_pressed2:
                 cmp  al, 4bh + 80h
                 jnz  not_release2
                 mov  flag_red,8
    not_release2:
    ; Checking for pressing RIGHT RED
                 cmp  al, 4dh
                 jnz  not_pressed3
                 mov  flag_red,4dh
    not_pressed3:
                 cmp  al, 4dh + 80h
                 jnz  not_release3
                 mov  flag_red,8
    not_release3:
    ; For BLUE
    ; Checking for pressing UP BLUE
                 cmp  al, 11h
                 jnz  not_pressed4
                 mov  flag_blue, 11h
    not_pressed4:
                 cmp  al, 11h + 80h
                 jnz  not_release4
                 mov  flag_blue,8
    not_release4:
    ; Checking for pressing DOWN BLUE
                 cmp  al, 1fh
                 jnz  not_pressed5
                 mov  flag_blue, 1fh
    not_pressed5:
                 cmp  al, 1fh + 80h
                 jnz  not_release5
                 mov  flag_blue,8
    not_release5:
    ; Checking for pressing LEFT BLUE
                 cmp  al, 1eh
                 jnz  not_pressed6
                 mov  flag_blue,1eh
    not_pressed6:
                 cmp  al, 1eh + 80h
                 jnz  not_release6
                 mov  flag_blue,8
    not_release6:
    ; Checking for pressing RIGHT BLUE
                 cmp  al, 20h
                 jnz  not_pressed7
                 mov  flag_blue,20h
    not_pressed7:
                 cmp  al, 20h + 80h
                 jnz  not_release7
                 mov  flag_blue,8
                 jmp  not_release7
    not_release7:

    
     ;; I need to add F1,F2,and ESC
     ; CHECK FOR ESC with SCAN CODE 01h
                 cmp  al, 01h
                 jne  Get_Power_UPs_Red
                 mov  flag_blue, 01h

     Get_Power_UPs_Red:
                 cmp al,36h
                 jne Get_Power_UPs_Blue
                 cmp enablePowerUpRed,0h
                 je Get_Power_UPs_Blue
                 mov Red_Run_Power_Up,1h
     Get_Power_UPs_Blue:
                 cmp al,2ah
                 jne Check_F4
                 cmp enablePowerUpBlue,0h
                 je Check_F4
                 mov Blue_Run_Power_Up,1h
     Check_F4:
                 cmp al,3eh
                 jne END_Of_Inter
                 mov F4_Pressed,1h
    END_Of_Inter:
                 mov  al, 20h                ; The non specific EOI (End Of Interrupt)
                 out  20h, al
                 iret
overRide9H endp
draw_stored proc 
mov ax,0A000h
mov es,ax
mov al,curPowInd
cmp al,index_power
jge ret_sto
mov bh,0
mov bl,curPowInd
mov cx, word ptr [power_ups+bx]
add bx,2
mov dx , word ptr[power_ups+bx]
add bx,2
mov ax,word ptr [power_ups+bx]
mov power_col_sto,ax
mov di,obstacle_len
vertical_sto:
mov si,obstacle_wid
push di
horizontal_sto:
mov ax,dx
mov bx,320d
push dx
mul bx
pop dx
add ax,cx
mov di,ax
mov ax,power_col_sto
stosb
inc cx
dec si
jnz horizontal_sto
sub cx,obstacle_wid
dec dx
pop di
dec di
jnz vertical_sto
add curPowInd,6
ret_sto:
ret
draw_stored endp
end