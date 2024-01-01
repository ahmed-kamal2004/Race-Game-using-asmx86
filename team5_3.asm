     Extrn draw:far
     EXTRN outKey:BYTE
     EXTRN  blue_car_back  :BYTE
     EXTRN  blue_car_front :BYTE
     EXTRN  blue_car_left  :BYTE
     EXTRN  blue_car_right :BYTE
     EXTRN   Blue_velocity  :WORD;;; 0 decrease , 1 normal , 2 increase
     EXTRN   Blue_Current_X :WORD                                                                                                                                                                                            ;; columns
     EXTRN  Blue_Current_Y:WORD
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;
     ;; ALL DATA RELATED TO RED CAR
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;
     EXTRN   red_car_back   :BYTE
     EXTRN  red_car_front  :BYTE
     EXTRN red_car_left  :BYTE
     EXTRN red_car_right  :BYTE
     EXTRN  Red_velocity  :WORD
     EXTRN  Red_Current_X  :WORD                                                                                                                                                                                       ; column horizontal
     EXTRN  Red_Current_Y :WORD                                                                                                                                                                                          ; row vertical
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     EXTRN  img_black      :BYTE
     EXTRN Current_X    :WORD
     EXTRN Current_Y    :WORD
     ;;; Data Added by Nesma
     EXTRN Current_X_Check:WORD
     EXTRN Current_y_Check :WORD
     EXTRN  pixelScreen :WORD
     ;;;;;;;;;;;;;;;;;;;;;;PowerUp Data;;;

     extrn enablePowerUpBlue :byte
     extrn enablePowerUpRed :byte
     extrn powerUpBlue:byte
     extrn powerUpRed:byte
     extrn obstacleColor:byte
     extrn usedPowerUp:byte
     extrn anyonePowerUp:byte
     extrn obstacleSize : WORD
     EXTRN positionX:WORD
     EXTRN positionY:WORD
     extrn CanOverObstacle:byte
     ;;;;;;;;;;;;;;;;;;;
     EXTRN  Track_color  :BYTE
     ; EXTRN  candrow :byte
     ;; Data for Red car
     ;; Data for Blue car

     ;; Data overall
     extrn is_Blue_Win:byte
     extrn is_Red_Win:byte
     EXTRN Track_color  : BYTE
     EXTRN flag_red : BYTE
     EXTRN flag_blue :BYTE
     Extrn  Draw_Request:BYTE 
     EXTRN Red_Start_Time:WORD
     EXTRN Blue_Start_Time:WORD
     EXTRN Red_Timing:WORD
     EXTRN Blue_Timing:WORD
     EXTRN Blue_Run_Power_Up:BYTE
     EXTRN Red_Run_Power_Up:BYTE
     EXTRN Power_UP_Start_point:WORD
     EXTRN Power_UP_X:WORD
     EXTRN Power_UP_Y:WORD

     EXTRN first_power_color:BYTE
     EXTRN second_power_color:BYTE
     EXTRN third_power_color:BYTE
     EXTRN forth_power_color:BYTE
     EXTRN direction:BYTE
     PUBLIC CARRED,CARBLUE
.MODEL SMALL 
.stack 64h
.CODE
CARBLUE PROC far
                    MOV AH,2CH 
                    INT 21H
                    Mov AH,0h
                    Mov AL,60d
                    IMUL CL
                    mov dl,dh
                    mov dh,0
                    Add Ax,dx
                    Mov BX,AX
                    sub Bx,5d
                    CMP BX,Blue_Start_Time
                    jl Continue_check_blue
                    mov Blue_Timing,3h

                    ;; Code for enabling Power UP'
                    Continue_check_blue:
                    cmp Blue_Run_Power_Up,1h
                    je CHECK_FAST_Blue
                    jmp Blue_Start

                              ;; Code for making  Speed Fast or Slow
                         CHECK_FAST_BLUE:
                                   cmp enablePowerUpBlue,1h
                                   jne CHECK_SLOW_BLUE
                                   MOV AH,2CH    ; To get System Time
                                   INT 21H
                                   Mov AH,0h
                                   Mov AL,60d
                                   IMUL CL
                                   mov dl,dh
                                   mov dh,0
                                   Add Ax,dx
                                   mov Blue_Start_Time,AX
                                   mov Blue_Timing,5H
                                   mov enablePowerUpBlue,0h
                                   mov Blue_Run_Power_Up,0h
                                   jmp Blue_Start
                                   
                         CHECK_SLOW_BLUE:
                                   cmp enablePowerUpBlue,2h
                                   jne Blue_Start
                                   MOV AH,2CH    ; To get System Time
                                   INT 21H
                                   Mov AH,0h
                                   Mov AL,60d
                                   IMUL CL
                                   mov dl,dh
                                   mov dh,0
                                   Add Ax,dx
                                   mov Red_Start_Time,AX
                                   mov Red_Timing,1h
                                   mov enablePowerUpBlue,0h
                                   mov Blue_Run_Power_Up,0h
                                   jmp Blue_Start



               Blue_Start:
                          cmp  flag_blue,11h
                          je   JUMP_BLUE_UP
                          cmp  flag_blue,1fh
                          je   JUMP_BLUE_DOWN
                          cmp  flag_blue,1eh
                          je   JUMP_BLUE_LEFT
                          cmp  flag_blue,20h
                          je   JUMP_BLUE_RIGHT
                          jmp far ptr FINISH_BLUE

                         JUMP_BLUE_RIGHT:
                         jmp far ptr Blue_Move_Right
                         JUMP_BLUE_DOWN:
                         jmp far ptr Blue_Move_DOWN
                         JUMP_BLUE_LEFT:
                         jmp far ptr Blue_Move_LEFT
                         JUMP_BLUE_UP:
                         jmp far ptr Blue_Move_UP
                         Blue_Move_UP:
                              mov direction,0h
                              mov cx,Blue_Current_X[0]
                              mov dx,Blue_Current_Y[0]
                              sub dx,1d
                              cmp dx,0d;for the edges 
                              je FINISH_Blue_Move_UP_Break
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                             call Check_power_up_blue
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; above obstacle
                              cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_UP_FIRST
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_UP_FIRST
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_UP_FIRST
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_Y[0];FOR CHECK 
                              SUB SI,1d
                              SUB SI,obstacleSize
                              CMP SI,11D;CAR SIZE +1
                              JBE CHECK_TRACK_BLUE_UP_FIRST
                              DEC SI
                              MOV positionY[2],SI;THE NEW POSITIONS
                              SUB SI,11d;;FOR CHECK
                              MOV positionY[0],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Up
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_UP_FIRST
                              call clear_blue
                              MOV SI,positionY[0];NEW POSITION
                              INC SI;I SUB 1 BEFORE SO ADD IT AGAIN
                              mov Blue_Current_Y[0],SI
                              MOV SI,positionY[2]
                              mov Blue_Current_Y[2],SI
                              
                              jmp CALL_Blue_Move_UP;draw it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             CHECK_TRACK_BLUE_UP_FIRST: cmp bl,Track_color
                             jne FINISH_Blue_Move_UP_Break
                             jmp continue_blue_up
FINISH_Blue_Move_UP_Break: jmp far ptr FINISH_Blue_Move_UP
continue_blue_up:
                              mov cx,Blue_Current_X[2]
                              mov dx,Blue_Current_Y[0]
                              sub dx,1d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_UP_Second
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_UP_Second
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_UP_Second
                              mov Blue_Run_Power_Up,0h;find obstacle
                             mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_Y[0];FOR CHECK 
                              SUB SI,1d
                              jz CHECK_TRACK_BLUE_UP_Second
                              SUB SI,obstacleSize
                              jz CHECK_TRACK_BLUE_UP_Second
                              CMP SI,11D;CAR SIZE +1
                              JBE CHECK_TRACK_BLUE_UP_Second
                              DEC SI
                              MOV positionY[2],SI;THE NEW POSITIONS
                              SUB SI,11d;;FOR CHECK
                              MOV positionY[0],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Up
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_UP_Second
                              call clear_blue

                              MOV SI,positionY[0];NEW POSITION
                              INC SI;I SUB 1 BEFORE SO ADD IT AGAIN
                              mov Blue_Current_Y[0],SI
                              MOV SI,positionY[2]
                              mov Blue_Current_Y[2],SI
                              
                              jmp CALL_Blue_Move_UP;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                          CHECK_TRACK_BLUE_UP_Second:      cmp bl,Track_color
                              jne FINISH_Blue_Move_UP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              mov cx,Blue_Current_X[0]
                              mov dx,Blue_Current_Y[0]
                              sub dx,1d
                              add cx,5d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_UP_Middel
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_UP_Middel
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_UP_Middel
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_Y[0];FOR CHECK 
                              SUB SI,1d
                              SUB SI,obstacleSize
                              CMP SI,11D;CAR SIZE +1
                              JBE CHECK_TRACK_BLUE_UP_Middel
                              DEC SI
                              MOV positionY[2],SI;THE NEW POSITIONS
                              SUB SI,11d;;FOR CHECK
                              MOV positionY[0],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Up
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_UP_Middel
                              call clear_blue

                              MOV SI,positionY[0];NEW POSITION
                              INC SI;I SUB 1 BEFORE SO ADD IT AGAIN
                              mov Blue_Current_Y[0],SI
                              MOV SI,positionY[2]
                              mov Blue_Current_Y[2],SI
                              
                              jmp CALL_Blue_Move_UP;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                           CHECK_TRACK_BLUE_UP_Middel:   cmp bl,Track_color
                              jne FINISH_Blue_Move_UP

                              jmp  far ptr CALL_Blue_Move_UP
                              FINISH_Blue_Move_UP:
                                   jmp far ptr FINISH_BLUE
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                         Blue_Move_DOWN: 
                              mov direction,1h
                              mov cx,Blue_Current_X[0]
                              mov dx,Blue_Current_Y[2]
                              add dx,1d
                              cmp dx,199d;for the edges 
                              je FINISH_Blue_Move_Down_Break
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;POWER4
                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; above obstacle
                              cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Down_FIRST
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Down_FIRST
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Down_FIRST
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_Y[2];FOR CHECK 
                              add SI,1d
                              add SI,obstacleSize
                              ;CMP SI,11D;CAR SIZE +1
                              ;JBE CHECK_TRACK_BLUE_Down_FIRST
                              inc SI
                              MOV positionY[0],SI;THE NEW POSITIONS
                              add SI,11d;;FOR CHECK
                              MOV positionY[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Down
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_Down_FIRST
                              call clear_blue

                              MOV SI,positionY[0];NEW POSITION back
                              mov Blue_Current_Y[0],SI
                              MOV SI,positionY[2]
                           dec SI;I add 1 BEFORE SO dec IT AGAIN

                              mov Blue_Current_Y[2],SI
                              
                              jmp CALL_Blue_Move_Down;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                         CHECK_TRACK_BLUE_Down_FIRST:     cmp bl,Track_color
                              jne FINISH_Blue_Move_Down_Break
                              jmp continue_blue_Down
FINISH_Blue_Move_Down_Break:
jmp far ptr FINISH_Blue_Move_DOWN
continue_blue_Down:
                              mov cx,Blue_Current_X[2]
                              mov dx,Blue_Current_Y[2]
                              add dx,1d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Down_Second
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Down_Second
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Down_Second
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_Y[2];FOR CHECK 
                              add SI,1d
                              add SI,obstacleSize
                              inc SI
                              MOV positionY[0],SI;THE NEW POSITIONS
                              add SI,11d;;FOR CHECK car size and 1 for check the last pixel
                              MOV positionY[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Down
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_Down_Second
                              call clear_blue

                              MOV SI,positionY[0];NEW POSITION
                              mov Blue_Current_Y[0],SI
                              MOV SI,positionY[2]
                              dec SI;I add 1 BEFORE SO sub IT AGAIN

                              mov Blue_Current_Y[2],SI
                              
                              jmp CALL_Blue_Move_Down;draw it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                  CHECK_TRACK_BLUE_Down_Second:            cmp bl,Track_color
                              jne FINISH_Blue_Move_DOWN

                              mov cx,Blue_Current_X[0]
                              mov dx,Blue_Current_Y[2]
                              add dx,1d
                              add cx,5d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Down_Middel
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Down_Middel
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Down_Middel
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_Y[2];FOR CHECK 
                              add SI,1d
                              add SI,obstacleSize
                              inc SI
                              MOV positionY[0],SI;THE NEW POSITIONS
                              add SI,11d;;FOR CHECK
                              MOV positionY[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Down
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_Down_Middel
                              call clear_blue

                              MOV SI,positionY[0];NEW POSITION
                              mov Blue_Current_Y[0],SI
                              MOV SI,positionY[2]
                              dec SI;I add 1 BEFORE SO sub IT AGAIN

                              mov Blue_Current_Y[2],SI
                         
                              jmp CALL_Blue_Move_Down;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                      CHECK_TRACK_BLUE_Down_Middel:   
                           cmp bl,Track_color
                              jne FINISH_Blue_Move_DOWN

                              jmp  far ptr CALL_Blue_Move_Down
                              FINISH_Blue_Move_DOWN:
                                   jmp far ptr FINISH_BLUE
                         Blue_Move_LEFT: 

                              mov direction,2h
                              mov cx,Blue_Current_X[0]
                              mov dx,Blue_Current_Y[0]
                              sub cx,1d
                              cmp cx,0d
                              je FINISH_Blue_Move_Left_Break

                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Left_First
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Left_First
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Left_First
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_X[0];FOR CHECK 
                              cmp si,1d
                              jbe CHECK_TRACK_BLUE_Left_First
                              DEC SI
                              SUB SI,obstacleSize ;SUB THE OBST SIZE
                              jz CHECK_TRACK_BLUE_Left_First
                              DEC SI
                              jz CHECK_TRACK_BLUE_Left_First
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              cmp si,11d
                              jbe CHECK_TRACK_BLUE_Left_First
                              SUB SI,11d;;FOR CHECK CAR SIZE +1 
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Left
                              cmp CanOverObstacle,1
                              ;
                              jnz    CHECK_TRACK_BLUE_Left_First
                              call clear_blue

                              MOV SI,positionX[0];NEW POSITION
                              mov Blue_Current_X[2],SI
                              MOV SI,positionX[2]
                              INC SI;I add 1 BEFORE SO sub IT AGAIN

                              mov Blue_Current_X[0],SI
                         
                              jmp CALL_Blue_Move_Left;draw it



                  CHECK_TRACK_BLUE_Left_First:            cmp bl,Track_color
                              jne FINISH_Blue_Move_Left_Break

                              jmp continue_blue_Left
FINISH_Blue_Move_Left_Break:
jmp far ptr FINISH_Blue_Move_LEFT
continue_blue_Left:
                              mov cx,Blue_Current_X[0]
                              mov dx,Blue_Current_Y[2]
                              sub cx,1d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Left_Second
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Left_Second
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Left_Second
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_X[0];FOR CHECK 
                             
                              DEC SI
                              SUB SI,obstacleSize ;SUB THE OBST SIZE
                              jz CHECK_TRACK_BLUE_Left_Second
                              DEC SI
                              jz CHECK_TRACK_BLUE_Left_Second
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              SUB SI,11d;;FOR CHECK CAR SIZE +1 
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Left
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_Left_Second
                              call clear_blue

                              MOV SI,positionX[0];NEW POSITION
                              mov Blue_Current_X[2],SI
                              MOV SI,positionX[2]
                              INC SI;I add 1 BEFORE SO sub IT AGAIN

                              mov Blue_Current_X[0],SI
                         
                              jmp CALL_Blue_Move_Left;draw it


                          CHECK_TRACK_BLUE_Left_Second:    cmp bl,Track_color
                              jne FINISH_Blue_Move_LEFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              mov cx,Blue_Current_X[0]
                              mov dx,Blue_Current_Y[2]
                              sub cx,1d
                              sub dx,5d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                                           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Left_Middel
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Left_Middel
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Left_Middel
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_X[0];FOR CHECK 
                              DEC SI
                              SUB SI,obstacleSize ;SUB THE OBST SIZE
                              DEC SI
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              SUB SI,11d;;FOR CHECK CAR SIZE +1 
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Left
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_Left_Middel
                              call clear_blue

                              MOV SI,positionX[0];NEW POSITION
                              mov Blue_Current_X[2],SI
                              MOV SI,positionX[2]
                              INC SI;I add 1 BEFORE SO sub IT AGAIN

                              mov Blue_Current_X[0],SI
                              jmp CALL_Blue_Move_Left;draw it

                       CHECK_TRACK_BLUE_Left_Middel:       cmp bl,Track_color
                              jne FINISH_Blue_Move_LEFT

                              jmp far ptr CALL_Blue_Move_Left

                              FINISH_Blue_Move_LEFT:
                                   jmp far ptr FINISH_BLUE
                                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                         Blue_Move_Right:  
                              mov direction,3h  
                              mov cx,Blue_Current_X[2]
                              mov dx,Blue_Current_Y[0]
                              add cx,1d
                               cmp cx,319d
                              je FINISH_Blue_Move_Right_Break_break
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Right_First
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Right_First
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Right_First
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_X[2];FOR CHECK 
                              cmp si,319d
                              jae CHECK_TRACK_BLUE_Right_First
                              inc SI;right inc current[2] is front back [0]
                              add SI,obstacleSize ;SUB THE OBST SIZE
                              cmp si,319
                              jae CHECK_TRACK_BLUE_Right_First
                              inc SI
                              cmp si,319
                              je CHECK_TRACK_BLUE_Right_First
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              add SI,11d;;FOR CHECK CAR SIZE +1 
                              cmp si,319d
                              jae CHECK_TRACK_BLUE_Right_First
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Right
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_BLUE_Right_First
                              call clear_blue
                              MOV SI,positionX[0];NEW POSITION
                              mov Blue_Current_X[0],SI;back
                              MOV SI,positionX[2]
                              dec SI;I add 1 BEFORE SO sub IT AGAIN
                              mov Blue_Current_X[2],SI
                           jmp CALL_Blue_Move_Right;draw it
                           FINISH_Blue_Move_Right_Break_break:jmp FINISH_Blue_Move_Right_Break
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                       CHECK_TRACK_BLUE_Right_First:       cmp bl,Track_color
                              jne FINISH_Blue_Move_Right_Break
                              jmp continue_blue_Right
FINISH_Blue_Move_Right_Break:
jmp far ptr FINISH_Blue_Move_RIGHT
continue_blue_Right:
                              mov cx,Blue_Current_X[2]
                              mov dx,Blue_Current_Y[2]
                              add cx,1d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Right_Second
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Right_Second
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Right_Second
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_X[2];FOR CHECK 
                              cmp si,319d
                              jae CHECK_TRACK_BLUE_Right_Second
                              inc SI;right inc current[2] is front back [0]
                              add SI,obstacleSize ;SUB THE OBST SIZE
                              cmp si,319
                              jae CHECK_TRACK_BLUE_Right_Second
                              inc SI
                              cmp si,319
                              je CHECK_TRACK_BLUE_Right_Second
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              
                              add SI,11d;;FOR CHECK CAR SIZE +1 
                              cmp si,319d
                              jae CHECK_TRACK_BLUE_Right_Second
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Right
                              cmp CanOverObstacle,1

                              jnz    CHECK_TRACK_BLUE_Right_Second
                              call clear_blue

                              MOV SI,positionX[0];NEW POSITION
                              mov Blue_Current_X[0],SI;back
                              MOV SI,positionX[2]
                              dec SI;I add 1 BEFORE SO sub IT AGAIN
                              mov Blue_Current_X[2],SI
                         
                              jmp CALL_Blue_Move_Right;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CHECK_TRACK_BLUE_Right_Second:      cmp bl,Track_color
                              jne FINISH_Blue_Move_Right_Break_2
                              jmp continue_Blue_Right_Right
     FINISH_Blue_Move_Right_Break_2:
     jmp far ptr  FINISH_Blue_Move_RIGHT                        
continue_Blue_Right_Right:

                              mov cx,Blue_Current_X[2]
                              mov dx,Blue_Current_Y[2]
                              add cx,1d
                              sub dx,5d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Blue_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_BLUE_Right_Middel
                              CMP enablePowerUpBlue,4d 
                              jnz CHECK_TRACK_BLUE_Right_Middel
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_BLUE_Right_Middel
                              mov Blue_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpBlue,0d ;used it
                              MOV SI,Blue_Current_X[2];FOR CHECK 
                              cmp si,319d
                              jae CHECK_TRACK_BLUE_Right_Middel
                              inc SI;right inc current[2] is front back [0]
                              add SI,obstacleSize ;SUB THE OBST SIZE
                              cmp si,319
                              jae CHECK_TRACK_BLUE_Right_Middel
                              inc SI
                              cmp si,319
                              je CHECK_TRACK_BLUE_Right_Middel
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRO
                              add SI,11d;;FOR CHECK CAR SIZE +1 
                              cmp si,319d
                              jae CHECK_TRACK_BLUE_Right_Middel
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Blue_Right
                              cmp CanOverObstacle,1

                              jnz    CHECK_TRACK_BLUE_Right_Middel
                              call clear_blue

                              MOV SI,positionX[0];NEW POSITION
                              mov Blue_Current_X[0],SI;back
                              MOV SI,positionX[2]
                              dec SI;I add 1 BEFORE SO sub IT AGAIN
                              mov Blue_Current_X[2],SI
                         
                              jmp CALL_Blue_Move_Right;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                             CHECK_TRACK_BLUE_Right_Middel: cmp bl,Track_color
                              jne FINISH_Blue_Move_RIGHT

                              jmp  far ptr CALL_Blue_Move_Right
                              FINISH_Blue_Move_RIGHT:
                                   jmp far ptr FINISH_BLUE
                         FINISH_BLUE:
                              jmp far ptr FINAL_BLUE
                         CALL_Blue_Move_Down: 
                                             call clear_blue
                                             mov cx,Blue_Current_X[0];endpoint
                                             mov Dx,Blue_Current_Y[2];endpoint
                                             add dx,2;ENDPOINT
                                              mov ah,0Dh;ENDPOINT
                                              mov al,0h
                                               int 10h
                                               mov bl,al
                                               cmp bl,3h
                                               jnz check_second_blue_down
                                               mov is_Red_Win,1D
                                               jmp continue_Blue_down_end
                                               check_second_blue_down:
                                                cmp bl,0ch
                                               jnz continue_Blue_down_end
                                               mov is_Red_Win,1D
                                               continue_Blue_down_end:
                                             mov  bx,Blue_Current_X[0]
                                             mov  Current_X[0],bx
                                             mov  bx,Blue_Current_X[2]
                                             mov  Current_X[2],bx
                                             mov  bx,Blue_Current_Y[0]
                                             add  bx,Blue_velocity
                                             mov  Blue_Current_Y[0],bx
                                             mov  Current_Y[0],bx
                                             mov  bx,Blue_Current_Y[2]
                                             add  bx,Blue_velocity
                                             mov  Blue_Current_Y[2],bx
                                             mov  Current_Y[2],bx
                                             lea  bx,blue_car_back
                                             mov  si,bx
                                             call draw
                                                 ;;;;;Nesma for obstacle
                                             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;obstacle;;untill ahmed send
                                            cmp Blue_Run_Power_Up,1h
                                            jnz FINISH_Blue_Move_Down_Obstacle_Break_Jmp      

                                             cmp enablePowerUpBlue,3d
                                                  jnz FINISH_Blue_Move_Down_Obstacle_Break_Jmp  
                                                  mov enablePowerUpBlue,0d    
                                                   mov Blue_Run_Power_Up,0d    

                                             mov cx,Blue_Current_X[0];;x position
                                             mov dx,Blue_Current_Y[0];y position
                                             sub dx,1d;sub by 1 to go the pixel back
                                             cmp dx,obstacleSize;;if smaller than the size 
                                             jb FINISH_Blue_Move_Down_Obstacle_Break_Jmp
                                             sub dx,obstacleSize;to draw obst
                                             
                                             Power_Up_Blue_Down_First:;loop
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Blue_Move_Down_Obstacle_Break_Jmp
                                             inc dx     ;
                                             cmp dx,Blue_Current_Y[0]
                                             jne  Power_Up_Blue_Down_First;;stille check
                                             ;;;;;second check
                                             mov cx,Blue_Current_X[2]
                                             mov dx,Blue_Current_Y[0]
                                             sub dx,1
                                             sub dx,obstacleSize;to draw obst
                                             Power_Up_Blue_Down_Second:;loop
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Blue_Move_Down_Obstacle_Break_Jmp
                                             inc dx     ;
                                             cmp dx,Blue_Current_Y[0]
                                             jne  Power_Up_Blue_Down_Second;;stille check
          ;;;;;;;;;;;;;;;;;;;;;middel check
                                             jmp Draw_Blue_Obs_Down
                                             FINISH_Blue_Move_Down_Obstacle_Break_Jmp: jmp FINISH_Blue_Move_Down_Obstacle
                                             Draw_Blue_Obs_Down:
                                            ;jne  Power_Up_Red_Down_Middel;;stille check
                                             ;;;;;;drow obstacle
                                             mov cx,Blue_Current_X[0];;x position
                                             mov si,Blue_Current_X[0]
                                             add si,obstacleSize
                                             mov dx,Blue_Current_Y[0];y position
                                             sub dx,1d;sub by 1 to go the pixel back
                                             sub dx,obstacleSize;;if smaller than the size 
                                             Draw_Obstacle_For_Down_Blue_Outer:;outerloop
                                             mov dx,Blue_Current_Y[0];y position
                                             sub dx,1d;sub by 1 to go the pixel back
                                             sub dx,obstacleSize;;if smaller than the size 
                                             Draw_Obstacle_For_Down_Blue_Inner:;inner loop
                                             mov ah,0ch
                                             mov al,obstacleColor
                                             int 10h
                                             inc dx
                                             cmp dx,Blue_Current_Y[0]
                                             jnz Draw_Obstacle_For_Down_Blue_Inner
                                             inc cx
                                             cmp cx,si
                                             jnz Draw_Obstacle_For_Down_Blue_Outer
                                             FINISH_Blue_Move_Down_Obstacle: jmp far ptr FINAL_BLUE
                                                  
                                   CALL_Blue_Move_UP:   
                                                       call clear_blue
                                                        mov cx,Blue_Current_X[0]
                                             mov dx,Blue_Current_Y[0]
                                             sub dx,2d
                                             mov ah,0Dh
                                             mov al,0h
                                             int 10h
                                             mov bl,al
                                             cmp bl,3h
                                             jnz check_second_Blue_color_up
                                             mov is_Blue_Win,1d
                                             jmp continue_up_Blue_end_submain
                                             check_second_Blue_color_up:
                                             cmp bl,0ch
                                            jnz continue_up_Blue_end_submain
                                             mov is_Blue_Win,1d


              continue_up_Blue_end_submain:
                                                       mov  bx,Blue_Current_X[0]
                                                       mov  Current_X[0],bx
                                                       mov  bx,Blue_Current_X[2]
                                                       mov  Current_X[2],bx
                                                       mov  bx,Blue_Current_Y[0]
                                                       sub  bx,Blue_velocity
                                                       mov  Blue_Current_Y[0],bx
                                                       mov  Current_Y[0],bx
                                                       mov  bx,Blue_Current_Y[2]
                                                       sub  bx,Blue_velocity
                                                       mov  Blue_Current_Y[2],bx
                                                       mov  Current_Y[2],bx
                                                       lea  bx,blue_car_front
                                                       mov  si,bx
                                                       call draw
                                                       cmp Blue_Run_Power_Up,1h
                                                       jnz FINISH_Blue_Move_UP_Obstacle_Break_Jmp      

                                                       cmp enablePowerUpBlue,3d
                                                       jnz FINISH_Blue_Move_UP_Obstacle_Break_Jmp   
                                                       mov enablePowerUpBlue,0d  
                                                      mov Blue_Run_Power_Up,0d  

                                                       mov cx,Blue_Current_X[0];;x position
                                                       mov dx,Blue_Current_Y[2];y position
                                                       inc dx;sub by 1 to go the pixel bac
                                                       add dx,obstacleSize;to draw obst
                                                       CMP DX,200d
                                                       JZ FINISH_Blue_Move_UP_Obstacle_Break_Jmp
                                                       Power_Up_Blue_UP_First:;loop
                                                       mov ah,0dh
                                                       mov al,0h
                                                       int 10h
                                                       cmp al,Track_color
                                                       jne FINISH_Blue_Move_UP_Obstacle_Break_Jmp
                                                       DEC dx     ;
                                                       cmp dx,Blue_Current_Y[2]
                                                       jne  Power_Up_Blue_UP_First;;stille check
                                                       ;;;;;second check
                                                       mov cx,Blue_Current_X[2]
                                                       mov dx,Blue_Current_Y[2]
                                                       ADD dx,1
                                                       ADD dx,obstacleSize;to draw obst
                                                       Power_Up_Blue_UP_Second:;loop
                                                            mov ah,0dh
                                                            mov al,0h
                                                            int 10h
                                                            cmp al,Track_color
                                                            jne FINISH_Blue_Move_UP_Obstacle
                                                            DEC dx     ;
                                                            cmp dx,Blue_Current_Y[2]
                                                            jne  Power_Up_Blue_UP_Second;;stille check
               ;;;;;;;;;;;;;;;;;;;;;middel check
                              jmp Draw_Blue_Obs_UP
                              FINISH_Blue_Move_UP_Obstacle_Break_Jmp:
                               jmp FINISH_Blue_Move_UP_Obstacle
                              Draw_Blue_Obs_UP:
                              ;jne  Power_Up_Red_Down_Middel;;stille check
                              ;;;;;;drow obstacle
                                   mov cx,Blue_Current_X[0];;x position
                                   mov si,Blue_Current_X[0]
                                   add si,obstacleSize
                                   mov dx,Blue_Current_Y[2];y position
                                   ADD dx,1d;ADD by 1 to go the pixel back
                                   ADD dx,obstacleSize;;
                                   Draw_Obstacle_For_UP_Blue_Outer:;outerloop
                                   mov dx,Blue_Current_Y[2];y position
                                   ADD dx,1d;sub by 1 to go the pixel back
                                   ADD dx,obstacleSize;;if smaller than the size 
                                   Draw_Obstacle_For_UP_Blue_Inner:;inner loop
                                   mov ah,0ch
                                   mov al,obstacleColor
                                   int 10h
                                   DEC dx
                                   cmp dx,Blue_Current_Y[2]
                                   jnz Draw_Obstacle_For_UP_Blue_Inner
                                   inc cx
                                   cmp cx,si
                                   jnz Draw_Obstacle_For_UP_Blue_Outer
                                   jmp FINISH_Blue_Move_UP_Obstacle
                                   FINISH_Blue_Move_UP_Obstacle:
                                    jmp  far ptr FINAL_BLUE
                                          
                         CALL_Blue_Move_Left: 
                                             call clear_blue
                                             mov cx,Blue_Current_X[0]
                                             mov dx,Blue_Current_Y[0]
                                             sub cx,2d
                                             mov ah,0Dh
                                             mov al,0h
                                             int 10h
                                             mov bl,al
                                             cmp bl,3h
                                             jnz check_second_Blue_color_left
                                             mov is_Blue_Win,1d
                                             jmp continue_Left_Blue_end_submain
                                             check_second_Blue_color_left:
                                             cmp bl,0ch
                                            jnz continue_Left_Blue_end_submain
                                             mov is_Blue_Win,1d


              continue_Left_Blue_end_submain:
                                             mov  bx,Blue_Current_X[0]
                                             sub  bx,Blue_velocity
                                             mov  Blue_Current_X[0],bx
                                             mov  Current_X[0],bx
                                             mov  bx,Blue_Current_X[2]
                                             sub  bx,Blue_velocity
                                             mov  Blue_Current_X[2],bx
                                             mov  Current_X[2],bx

                                             mov  bx,Blue_Current_Y[0]
                                             mov  Blue_Current_Y[0],bx
                                             mov  Current_Y[0],bx
                                             mov  bx,Blue_Current_Y[2]
                                             mov  Blue_Current_Y[2],bx
                                             mov  Current_Y[2],bx
                                             lea  bx,blue_car_left
                                             mov  si,bx
                                             call draw
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;obstacle;;untill ahmed send
                                              cmp Blue_Run_Power_Up,1h
                                             jnz FINISH_Blue_Move_Left_Obstacle_Break_Jmp      

                                             cmp enablePowerUpBlue,3d
                                             jnz FINISH_Blue_Move_Left_Obstacle_Break_Jmp   
                                             mov enablePowerUpBlue,0d   
                                            mov Blue_Run_Power_Up,0d  

                                             mov cx,Blue_Current_X[2];;x position
                                             mov dx,Blue_Current_Y[0];y position
                                             inc cx;INC  by 1 to go the pixel bacK
                                             add cx,obstacleSize;to draw obst
                                             CMP cx,320d;FOR CHECK
                                             JAE FINISH_Blue_Move_Left_Obstacle_Break_Jmp
                                             Power_Up_Blue_Left_First:;loop CHECK
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Blue_Move_Left_Obstacle_Break_Jmp
                                             dec cx     ;
                                             cmp cx,Blue_Current_X[2]
                                             jne  Power_Up_Blue_Left_First;;stile check
                                             ;;;;;second check
                                             mov cx,Blue_Current_X[2]
                                             mov dx,Blue_Current_Y[2]
                                             ADD cx,1
                                             ADD cx,obstacleSize;to draw obst
                                        Power_Up_Blue_Left_Second:;loop
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Blue_Move_Left_Obstacle
                                             DEC cx     ;
                                             cmp cx,Blue_Current_X[2]
                                             jne  Power_Up_Blue_Left_Second;;stille check
               ;;;;;;;;;;;;;;;;;;;;;middel check
                                        jmp Draw_Blue_Obs_Left
                                        FINISH_Blue_Move_Left_Obstacle_Break_Jmp: jmp FINISH_Blue_Move_Left_Obstacle
                                        Draw_Blue_Obs_Left:
                                        ;;;;;;drow obstacle
                                             mov Dx,Blue_Current_Y[0];;Y position
                                             mov si,Blue_Current_Y[0]
                                             add si,obstacleSize
                                             mov Cx,Blue_Current_X[2];X position
                                             ADD cx,1d;ADD by 1 to go the pixel back
                                             ADD CX,obstacleSize;;
                                             Draw_Obstacle_For_Left_Blue_Outer:;outerloop
                                             mov Cx,Blue_Current_X[2];y position
                                             ADD Cx,1d;sub by 1 to go the pixel back
                                             ADD Cx,obstacleSize;;if smaller than the size 
                                             Draw_Obstacle_For_Left_Blue_Inner:;inner loop
                                             mov ah,0ch;;DRAW
                                             mov al,obstacleColor
                                             int 10h
                                             DEC Cx
                                             cmp Cx,Blue_Current_X[2];COMPLETE THE WIDTH
                                             jnz Draw_Obstacle_For_Left_Blue_Inner
                                             inc DX;FOR HEIGHT
                                             cmp Dx,si
                                             jnz Draw_Obstacle_For_Left_Blue_Outer
                                             jmp FINISH_Blue_Move_Left_Obstacle
                                             FINISH_Blue_Move_Left_Obstacle:
                                             jmp  far ptr FINAL_BLUE
                         CALL_Blue_Move_Right:
                                             call clear_blue
                                              mov cx,Blue_Current_X[2]
                                             mov dx,Blue_Current_Y[0]
                                             add cx,2d
                                             mov ah,0Dh
                                             mov al,0h
                                             int 10h
                                             mov bl,al
                                             cmp bl,3h
                                             jnz check_second_blue_color_
                                             mov is_Blue_Win,1d
                                             jmp continue_Blue_Right_end_submain
                                            check_second_blue_color_:
                                             cmp bl,0ch
                                             jnz continue_Blue_Right_end_submain

                                              mov is_Blue_Win,1d

                                              continue_Blue_Right_end_submain:  
                                             mov  bx,Blue_Current_X[0]
                                             add  bx,Blue_velocity
                                             mov  Blue_Current_X[0],bx
                                             mov  Current_X[0],bx
                                             mov  bx,Blue_Current_X[2]
                                             add  bx,Blue_velocity
                                             mov  Blue_Current_X[2],bx
                                             mov  Current_X[2],bx
                                             mov  bx,Blue_Current_Y[0]
                                             mov  Blue_Current_Y[0],bx
                                             mov  Current_Y[0],bx
                                             mov  bx,Blue_Current_Y[2]
                                             mov  Blue_Current_Y[2],bx
                                             mov  Current_Y[2],bx
                                             lea  bx,blue_car_right
                                             mov  si,bx
                                             call draw
                                               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                cmp Blue_Run_Power_Up,1h
                                             jnz FINISH_Blue_Move_Right_Obstacle_Break_Jmp      

                                                  cmp enablePowerUpBlue,3d
                                             jnz FINISH_Blue_Move_Right_Obstacle_Break_Jmp   
                                             mov enablePowerUpBlue,0d  
                                               mov Blue_Run_Power_Up,0d  
 
                                             mov cx,Blue_Current_X[0];;x position
                                             mov dx,Blue_Current_Y[0];y position
                                             CMP CX,1D
                                             JBE FINISH_Blue_Move_Right_Obstacle_Break_Jmp
                                             dec cx;INC  by 1 to go the pixel bacK
                                             CMP cx,obstacleSize;FOR CHECK
                                             JbE FINISH_Blue_Move_Right_Obstacle_Break_Jmp
                                             sub cx,obstacleSize;to draw obst

                                             Power_Up_Blue_Right_First:;loop CHECK
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Blue_Move_Right_Obstacle_Break_Jmp
                                             inc cx     ;
                                             cmp cx,Blue_Current_X[0]
                                             jne  Power_Up_Blue_Right_First;;stile check
                                             ;;;;;second check
                                             mov cx,Blue_Current_X[0]
                                             mov dx,Blue_Current_Y[2]
                                             sub cx,1
                                             sub cx,obstacleSize;to draw obst
                                        Power_Up_Blue_Right_Second:;loop
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Blue_Right_Obstacles
                                             inc cx     ;
                                             cmp cx,Blue_Current_X[0]
                                             jne  Power_Up_Blue_Right_Second;;stille check
               ;;;;;;;;;;;;;;;;;;;;;middel check
                                        jmp Draw_Blue_Obs_Right
                                        FINISH_Blue_Move_Right_Obstacle_Break_Jmp: jmp FINISH_Blue_Right_Obstacles
                                        Draw_Blue_Obs_Right:
                                        ;;;;;;drow obstacle
                                             mov Dx,Blue_Current_Y[0];;Y position
                                             mov si,Blue_Current_Y[0]
                                             add si,obstacleSize
                                             mov Cx,Blue_Current_X[0];X position
                                             sub cx,1d;ADD by 1 to go the pixel back
                                             sub CX,obstacleSize;;
                                             Draw_Obstacle_For_Right_Blue_Outer:;outerloop
                                             mov Cx,Blue_Current_X[0];y position
                                             sub Cx,1d;sub by 1 to go the pixel back
                                             sub Cx,obstacleSize;;
                                             Draw_Obstacle_For_Right_Blue_Inner:;inner loop
                                             mov ah,0ch;;DRAW
                                             mov al,obstacleColor
                                             int 10h
                                             inc Cx
                                             cmp Cx,Blue_Current_X[0];COMPLETE THE WIDTH
                                             jnz Draw_Obstacle_For_Right_Blue_Inner
                                             inc DX;FOR HEIGHT
                                             cmp Dx,si
                                             jnz Draw_Obstacle_For_Right_Blue_Outer
                                             jmp FINISH_Blue_Right_Obstacles
                                             FINISH_Blue_Right_Obstacles:
                                             jmp far ptr FINAL_BLUE


clear_blue PROC
                          mov  bx,Blue_Current_X[0]
                          mov  Current_X[0],bx
                          mov  bx,Blue_Current_X[2]
                          mov  Current_X[2],bx
                          mov  bx,Blue_Current_Y[0]
                          mov  Current_Y[0],bx
                          mov  bx,Blue_Current_Y[2]
                          mov  Current_Y[2],bx
                          lea  Bx,img_black
                          mov  si,bx
                          mov Draw_Request,1h
                          call draw
                          mov Draw_Request,0h
                          ret
clear_blue ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;PowerUp 4
PowerUp_4_Blue_Up Proc
mov CanOverObstacle,0d;CHECK CAN OVER OBSTACLE

                              mov direction,0h
                              mov cx,Blue_Current_X[0]
                              mov dx,positionY[2]
                              First_Power_UP_Blue_Check_Up:;;LOOP 
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_BLUE_UP_POWER_UP_CHECK
                              DEC Dx 
                              CMP DX,positionY[0]
                              JNZ First_Power_UP_Blue_Check_Up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;second check
                              mov cx,Blue_Current_X[2]
                              mov dx,positionY[2]
                              Second_Power_UP_Blue_Check_Up:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_BLUE_UP_POWER_UP_CHECK
                              DEC DX
                              CMP DX,positionY[0]
                              JNZ Second_Power_UP_Blue_Check_Up
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; middel check
                              mov cx,Blue_Current_X[0]
                              add cx,5d
                              mov dx,positionY[2]

                              Middel_Power_UP_Blue_Check_Up:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_BLUE
                              cmp bl,Track_color
                              jne FINSH_BLUE_UP_POWER_UP_CHECK
                               DEC DX
                              CMP DX,positionY[0]
                              JNZ Middel_Power_UP_Blue_Check_Up
                              mov CanOverObstacle,1d
FINSH_BLUE_UP_POWER_UP_CHECK:
RET

PowerUp_4_Blue_Up ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;down 
PowerUp_4_Blue_Down Proc
mov CanOverObstacle,0d;CHECK CAN OVER OBSTACLE

mov direction,0h
                              mov cx,Blue_Current_X[0]
                              mov dx,positionY[0];position [0] will be the back of car [2]front 
                              First_Power_UP_Blue_Check_Down:;;LOOP 
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_BLUE_Down_POWER_UP_CHECK
                              inc Dx ;down add not sub
                              CMP DX,positionY[2]
                              JNZ First_Power_UP_Blue_Check_Down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;second check
                              mov cx,Blue_Current_X[2]
                              mov dx,positionY[0]
                              Second_Power_UP_Blue_Check_Down:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_BLUE_Down_POWER_UP_CHECK
                              inc DX
                              CMP DX,positionY[2]
                              JNZ Second_Power_UP_Blue_Check_Down
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; middel check
                              mov cx,Blue_Current_X[0]
                              add cx,5d
                              mov dx,positionY[0]

                              Middel_Power_UP_Blue_Check_Down:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_BLUE
                              cmp bl,Track_color
                              jne FINSH_BLUE_Down_POWER_UP_CHECK
                               inc DX
                              CMP DX,positionY[2]
                              JNZ Middel_Power_UP_Blue_Check_Down
                              mov CanOverObstacle,1d
FINSH_BLUE_Down_POWER_UP_CHECK:
RET

PowerUp_4_Blue_Down ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PowerUp_4_Blue_Left Proc
mov CanOverObstacle,0d;CHECK CAN OVER OBSTACLE

mov direction,0h
                              mov cx,positionX[0]
                              mov dx,Blue_Current_Y[0];position [0] will be the back of car [2]front 
                              First_Power_UP_Blue_Check_Left:;;LOOP 
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_BLUE_Left_POWER_UP_CHECK
                              dec cx ;down add not sub
                              CMP cx,positionX[2]
                              JNZ First_Power_UP_Blue_Check_Left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;second check
                              mov cx,positionX[0]
                              mov dx,Blue_Current_Y[2]
                              Second_Power_UP_Blue_Check_Left:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_BLUE_Left_POWER_UP_CHECK
                              dec cx
                              CMP cX,positionX[2]
                              JNZ Second_Power_UP_Blue_Check_Left
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; middel check
                              mov cx,positionX[0]
                              mov dx,Blue_Current_Y[0]
                              add dx,5d

                              Middel_Power_UP_Blue_Check_Left:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_BLUE
                              cmp bl,Track_color
                              jne FINSH_BLUE_Left_POWER_UP_CHECK
                              dec CX
                              CMP CX,positionX[2]
                              JNZ Middel_Power_UP_Blue_Check_Left
                              mov CanOverObstacle,1d
FINSH_BLUE_Left_POWER_UP_CHECK:
RET

PowerUp_4_Blue_Left ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PowerUp_4_Blue_Right Proc
mov CanOverObstacle,0d;CHECK CAN OVER OBSTACLE

mov direction,0h
                              mov cx,positionX[0]
                              mov dx,Blue_Current_Y[0];position [0] will be the back of car [2]front 
                              First_Power_UP_Blue_Check_Right:;;LOOP 
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_BLUE_Right_POWER_UP_CHECK
                              inc cx ;down add not sub
                              CMP cx,positionX[2]
                              JNZ First_Power_UP_Blue_Check_Right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;second check
                              mov cx,positionX[0]
                              mov dx,Blue_Current_Y[2]
                              Second_Power_UP_Blue_Check_Right:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_BLUE_Right_POWER_UP_CHECK
                              inc cx
                              CMP cX,positionX[2]
                              JNZ Second_Power_UP_Blue_Check_Right
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; middel check
                              mov cx,positionX[0]
                              mov dx,Blue_Current_Y[0]
                              add dx,5d

                              Middel_Power_UP_Blue_Check_Right:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_BLUE
                              cmp bl,Track_color
                              jne FINSH_BLUE_Right_POWER_UP_CHECK
                              inc CX
                              CMP CX,positionX[2]
                              JNZ Middel_Power_UP_Blue_Check_Right
                              mov CanOverObstacle,1d
FINSH_BLUE_Right_POWER_UP_CHECK:
RET

PowerUp_4_Blue_Right ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Check_power_up_blue PROC
                              cmp bl,first_power_color
                              jne check_1B
                              mov enablePowerUpBlue,1h
                              mov Power_UP_Start_point[0],cx
                              mov Power_UP_Start_point[2],dx
                              call clearPower
                              jmp continue_B

                              check_1B:
                              cmp bl,second_power_color
                              jne check_2B
                              mov enablePowerUpBlue,2h
                              mov Power_UP_Start_point[0],cx
                              mov Power_UP_Start_point[2],dx
                              call clearPower
                              jmp continue_B

                              check_2B:
                              cmp bl,third_power_color
                              jne check_3B
                              mov enablePowerUpBlue,3h
                              mov Power_UP_Start_point[0],cx
                              mov Power_UP_Start_point[2],dx
                              call clearPower
                              jmp continue_B


                              check_3B:
                              cmp bl,forth_power_color
                              jne continue_B
                              mov enablePowerUpBlue,4h
                              mov Power_UP_Start_point[0],cx
                              mov Power_UP_Start_point[2],dx
                              call clearPower
                              jmp continue_B
                           
                              continue_B:
                              ret

Check_power_up_blue ENDP



     ;description

     FINAL_BLUE:
     ret
CARBLUE ENDP































CARRED PROC FAR
                    MOV AH,2CH 
                    INT 21H
                    Mov AH,0h
                    Mov AL,60d
                    IMUL CL
                    mov dl,dh
                    mov dh,0
                    Add Ax,dx
                    Mov BX,AX
                    sub Bx,5d
                    CMP BX,Red_Start_Time
                    jl Continue_check_red
                    mov Red_Timing,3h

                    ;; Code for enabling Power UP
                    Continue_check_red:
                    cmp Red_Run_Power_Up,1h
                    je CHECK_FAST_RED
                    jmp Red_Start

                              ;; Code for making  Speed Fast or Slow
                         CHECK_FAST_RED:
                                   cmp enablePowerUpRed,1h
                                   jne CHECK_SLOW_RED
                                   MOV AH,2CH    ; To get System Time
                                   INT 21H
                                   Mov AH,0h
                                   Mov AL,60d
                                   IMUL CL
                                   mov dl,dh
                                   mov dh,0
                                   Add Ax,dx
                                   mov Red_Start_Time,AX
                                   mov Red_Timing,5H
                                   mov enablePowerUpRed,0h
                                   mov Red_Run_Power_Up,0h
                                   jmp Red_Start
                                   
                         CHECK_SLOW_RED:
                                   cmp enablePowerUpRed,2h
                                   jne Red_Start
                                   MOV AH,2CH    ; To get System Time
                                   INT 21H
                                   Mov AH,0h
                                   Mov AL,60d
                                   IMUL CL
                                   mov dl,dh
                                   mov dh,0
                                   Add Ax,dx
                                   mov Blue_Start_Time,AX
                                   mov Blue_Timing,1h
                                   mov enablePowerUpRed,0h
                                   mov Red_Run_Power_Up,0h
                                   jmp Red_Start

                    Red_Start:
                              cmp  flag_red,48h
                              je   JUMP_Red_UP
                              cmp  flag_red,50h
                              je   JUMP_Red_DOWN
                              cmp  flag_red,4bh
                              je   JUMP_Red_LEFT
                              cmp  flag_red,4dh
                              je   JUMP_Red_Right
                              jmp far ptr FINISH_RED

                              jmp far ptr FINISH_RED
                              JUMP_Red_Right:
                              jmp far ptr Red_Move_Right
                              JUMP_Red_DOWN:
                              jmp far ptr Red_Move_DOWN
                              JUMP_Red_LEFT:
                              jmp far ptr Red_Move_LEFT
                              JUMP_Red_UP:
                              jmp far ptr Red_Move_UP





                         Red_Move_UP:     
                              mov direction,0h
                              mov cx,Red_Current_X[0]
                              mov dx,Red_Current_Y[0]
                              sub dx,1
                              cmp dx,0d;for the edges 
                              je FINISH_Red_Move_UP_Break
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; above obstacle
                              cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_UP_FIRST
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_UP_FIRST
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_UP_FIRST
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_Y[0];FOR CHECK 
                              SUB SI,1d
                              jz CHECK_TRACK_Red_UP_FIRST
                              SUB SI,obstacleSize
                              jz CHECK_TRACK_Red_UP_FIRST
                              CMP SI,11D;CAR SIZE +1
                              JBE CHECK_TRACK_Red_UP_FIRST
                              DEC SI
                              MOV positionY[2],SI;THE NEW POSITIONS
                              SUB SI,11d;;FOR CHECK
                              MOV positionY[0],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Up
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_UP_FIRST
                              call clear_red
                              MOV SI,positionY[0];NEW POSITION
                              INC SI;I SUB 1 BEFORE SO ADD IT AGAIN
                              mov Red_Current_Y[0],SI
                              MOV SI,positionY[2]
                              mov Red_Current_Y[2],SI
                              
                              jmp CALL_Red_Move_UP;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                              
                     CHECK_TRACK_Red_UP_FIRST:         cmp bl,Track_color
                              jne FINISH_Red_Move_UP_Break
                              jmp continue_Red_up
FINISH_Red_Move_UP_Break:jmp far ptr FINISH_Red_Move_UP
continue_Red_up:

                              mov cx,Red_Current_X[2]
                              mov dx,Red_Current_Y[0]
                              sub dx,1
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_UP_Second
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_UP_Second
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_UP_Second
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_Y[0];FOR CHECK 
                              SUB SI,1d
                              SUB SI,obstacleSize
                              CMP SI,11D;CAR SIZE +1
                              JBE CHECK_TRACK_Red_UP_Second
                              DEC SI
                              MOV positionY[2],SI;THE NEW POSITIONS
                              SUB SI,11d;;FOR CHECK
                              MOV positionY[0],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Up
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_UP_Second
                              call clear_red
                              MOV SI,positionY[0];NEW POSITION
                              INC SI;I SUB 1 BEFORE SO ADD IT AGAIN
                              mov Red_Current_Y[0],SI
                              MOV SI,positionY[2]
                              mov Red_Current_Y[2],SI
                              
                              jmp CALL_Red_Move_UP;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                          CHECK_TRACK_Red_UP_Second:    cmp bl,Track_color
                              jne FINISH_Red_Move_UP

                              mov cx,Red_Current_X[0]
                              mov dx,Red_Current_Y[0]
                              sub dx,1
                              add cx,5d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_UP_Middel
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_UP_Middel
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_UP_Middel
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_Y[0];FOR CHECK 
                              SUB SI,1d
                              SUB SI,obstacleSize
                              CMP SI,11D;CAR SIZE +1
                              JBE CHECK_TRACK_Red_UP_Middel
                              DEC SI
                              MOV positionY[2],SI;THE NEW POSITIONS
                              SUB SI,11d;;FOR CHECK
                              MOV positionY[0],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Up
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_UP_Middel
                              call clear_red
                              MOV SI,positionY[0];NEW POSITION
                              INC SI;I SUB 1 BEFORE SO ADD IT AGAIN
                              mov Red_Current_Y[0],SI
                              MOV SI,positionY[2]
                              mov Red_Current_Y[2],SI
                              
                              jmp CALL_Red_Move_UP;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    CHECK_TRACK_Red_UP_Middel:          cmp bl,Track_color
                              jne FINISH_Red_Move_UP

                              jmp  far ptr CALL_Red_Move_UP

                              FINISH_Red_Move_UP:
                                   jmp far ptr FINISH_RED
                         Red_Move_DOWN: 
                              mov direction,1h
                              mov cx,Red_Current_X[0]
                              mov dx,Red_Current_Y[2]
                              add dx,1d
                              cmp dx,199d;for the edges 
                              je FINISH_red_Move_Down_Break
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ;;;;;;;;;;;;;;;;;;;;;;;;;;POWER4
                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; above obstacle
                              cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Down_FIRST
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Down_FIRST
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Down_FIRST
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_Y[2];FOR CHECK 
                              add SI,1d
                              add SI,obstacleSize
                              ;CMP SI,11D;CAR SIZE +1
                              ;JBE CHECK_TRACK_BLUE_Down_FIRST
                              inc SI
                              MOV positionY[0],SI;THE NEW POSITIONS
                              add SI,11d;;FOR CHECK
                              MOV positionY[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Down
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_Down_FIRST
                              call clear_Red

                              MOV SI,positionY[0];NEW POSITION back
                              mov Red_Current_Y[0],SI
                              MOV SI,positionY[2]
                           dec SI;I add 1 BEFORE SO dec IT AGAIN

                              mov Red_Current_Y[2],SI
                              
                              jmp CALL_Red_Move_Down;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                         CHECK_TRACK_Red_Down_FIRST:     cmp bl,Track_color
                              jne FINISH_red_Move_Down_Break
                              jmp continue_red_Down
                    FINISH_red_Move_Down_Break:jmp far ptr FINISH_Red_Move_DOWN
                    continue_red_Down:
                              mov cx,Red_Current_X[2]
                              mov dx,Red_Current_Y[2]
                              add dx,1d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                            cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Down_Second
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Down_Second
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Down_Second
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_Y[2];FOR CHECK 
                              add SI,1d
                              add SI,obstacleSize
                              ;CMP SI,11D;CAR SIZE +1
                              ;JBE CHECK_TRACK_BLUE_Down_FIRST
                              inc SI
                              MOV positionY[0],SI;THE NEW POSITIONS
                              add SI,11d;;FOR CHECK
                              MOV positionY[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Down
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_Down_Second
                              call clear_Red
                              MOV SI,positionY[0];NEW POSITION back
                              mov Red_Current_Y[0],SI
                              MOV SI,positionY[2]
                              dec SI;I add 1 BEFORE SO dec IT AGAIN
                              mov Red_Current_Y[2],SI
                              jmp CALL_Red_Move_Down;draw it

                        CHECK_TRACK_Red_Down_Second:      cmp bl,Track_color
                              jne FINISH_Red_Move_DOWN

                              mov cx,Red_Current_X[0]
                              mov dx,Red_Current_Y[2]
                              add dx,1d
                              add cx,5d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Down_Middel
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Down_Middel
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Down_Middel
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_Y[2];FOR CHECK 
                              add SI,1d
                              add SI,obstacleSize
                              ;CMP SI,11D;CAR SIZE +1
                              ;JBE CHECK_TRACK_BLUE_Down_FIRST
                              inc SI
                              MOV positionY[0],SI;THE NEW POSITIONS
                              add SI,11d;;FOR CHECK
                              MOV positionY[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Down
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_Down_Middel
                              call clear_Red
                              MOV SI,positionY[0];NEW POSITION back
                              mov Red_Current_Y[0],SI
                              MOV SI,positionY[2]
                              dec SI;I add 1 BEFORE SO dec IT AGAIN
                              mov Red_Current_Y[2],SI
                              jmp CALL_Red_Move_Down;draw it

                         CHECK_TRACK_Red_Down_Middel:     cmp bl,Track_color
                              jne FINISH_Red_Move_DOWN

                              jmp  far ptr CALL_Red_Move_Down

                              FINISH_Red_Move_DOWN:
                                   jmp far ptr FINISH_RED

                         Red_Move_LEFT:  
                              mov direction,2h
                              mov cx,Red_Current_X[0]
                              mov dx,Red_Current_Y[0]
                              sub cx,1d
                             cmp cx,0d
                              je FINISH_Red_Move_Left_Break
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Left_First
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Left_First
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Left_First
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_X[0];FOR CHECK 
                             cmp si,1d
                              jbe CHECK_TRACK_Red_Left_First
                              DEC SI
                              SUB SI,obstacleSize ;SUB THE OBST SIZE
                              jz CHECK_TRACK_Red_Left_First
                              DEC SI
                              jz CHECK_TRACK_Red_Left_First
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              cmp si,11d
                              jbe CHECK_TRACK_Red_Left_First
                              SUB SI,11d;;FOR CHECK CAR SIZE +1 
                              MOV positionX[2],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                               call PowerUp_4_Red_Left
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_Left_First
                              call clear_Red

                              MOV SI,positionX[0];NEW POSITION
                              mov Red_Current_X[2],SI
                              MOV SI,positionX[2]
                              INC SI;I add 1 BEFORE SO sub IT AGAIN

                              mov Red_Current_X[0],SI
                              jmp CALL_Red_Move_Left;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

           CHECK_TRACK_Red_Left_First:                   cmp bl,Track_color
                              jne FINISH_Red_Move_Left_Break
                              jmp continue_Red_Left
FINISH_Red_Move_Left_Break:
jmp far ptr FINISH_Red_Move_LEFT
continue_Red_Left:
                              mov cx,Red_Current_X[0]
                              mov dx,Red_Current_Y[2]
                              sub cx,1d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Left_Second
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Left_Second
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Left_Second
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_X[0];FOR CHECK 
                              DEC SI
                              SUB SI,obstacleSize ;SUB THE OBST SIZE
                              DEC SI
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              SUB SI,11d;;FOR CHECK CAR SIZE +1 
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Left
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_Left_Second
                              call clear_Red

                              MOV SI,positionX[0];NEW POSITION
                              mov Red_Current_X[2],SI
                              MOV SI,positionX[2]
                              INC SI;I add 1 BEFORE SO sub IT AGAIN

                              mov Red_Current_X[0],SI
                              jmp CALL_Red_Move_Left;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                   CHECK_TRACK_Red_Left_Second:           cmp bl,Track_color
                              jne FINISH_Red_Move_LEFT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              mov cx,Red_Current_X[0]
                              mov dx,Red_Current_Y[2]
                              sub cx,1d
                              sub dx,5d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Left_Middel
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Left_Middel
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Left_Middel
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_X[0];FOR CHECK 
                              DEC SI
                             
                              SUB SI,obstacleSize ;SUB THE OBST SIZE
                              DEC SI
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              SUB SI,11d;;FOR CHECK CAR SIZE +1 
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Left
                              cmp CanOverObstacle,1
                              jnz    CHECK_TRACK_Red_Left_Middel
                              call clear_Red

                              MOV SI,positionX[0];NEW POSITION
                              mov Red_Current_X[2],SI
                              MOV SI,positionX[2]
                              INC SI;I add 1 BEFORE SO sub IT AGAIN

                              mov Red_Current_X[0],SI
                              jmp CALL_Red_Move_Left;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                       CHECK_TRACK_Red_Left_Middel:       cmp bl,Track_color
                              jne FINISH_Red_Move_LEFT

                              jmp far ptr CALL_Red_Move_Left

                              FINISH_Red_Move_LEFT:
                                   jmp far ptr FINISH_RED
                         Red_Move_Right:  
                              mov direction,3h
                              mov cx,Red_Current_X[2]
                              mov dx,Red_Current_Y[0]
                              add cx,1d
                              cmp cx,319d
                              je FINISH_Red_Move_Right_Break_b

                              mov ah,0dh
                              mov al,0h
                              int 10h  
                              mov bl,al
                              call Check_power_up_red
                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Right_First
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Right_First
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Right_First
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_X[2];FOR CHECK 
                              cmp si,319d
                              jae CHECK_TRACK_Red_Right_First
                              inc SI;right inc current[2] is front back [0]
                              add SI,obstacleSize ;SUB THE OBST SIZE
                              cmp si,319
                              jae CHECK_TRACK_Red_Right_First
                              inc SI
                              cmp si,319
                              je CHECK_TRACK_Red_Right_First
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              
                              add SI,11d;;FOR CHECK CAR SIZE +1 
                              cmp si,319d
                              jae CHECK_TRACK_Red_Right_First
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Right
                              cmp CanOverObstacle,1

                              jnz    CHECK_TRACK_Red_Right_First
                              call clear_red;clear 
                              jmp contincode
                              FINISH_Red_Move_Right_Break_b:
                              jmp FINISH_Red_Move_Right_Break
contincode:
                              MOV SI,positionX[0];NEW POSITION
                              mov Red_Current_X[0],SI;back
                              MOV SI,positionX[2]
                              dec SI;I add 1 BEFORE SO sub IT AGAIN
                              mov Red_Current_X[2],SI
                              jmp CALL_Red_Move_Right;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    CHECK_TRACK_Red_Right_First:          cmp bl,Track_color
                              jne FINISH_Red_Move_Right_Break
jmp continue_Red_Right_Right2
FINISH_Red_Move_Right_Break:
jmp far ptr FINISH_Red_Move_Right
continue_Red_Right_Right2:

                              mov cx,Red_Current_X[2]
                              mov dx,Red_Current_Y[2]
                              add cx,1d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                                          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Right_Second
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Right_Second
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Right_Second
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_X[2];FOR CHECK 
                              cmp si,319d
                              jae CHECK_TRACK_Red_Right_Second
                              inc SI;right inc current[2] is front back [0]
                              add SI,obstacleSize ;SUB THE OBST SIZE
                              cmp si,319
                              jae CHECK_TRACK_Red_Right_Second
                              inc SI
                              cmp si,319
                              je CHECK_TRACK_Red_Right_Second
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              
                              add SI,11d;;FOR CHECK CAR SIZE +1 
                              cmp si,319d
                              jae CHECK_TRACK_Red_Right_Second
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Right
                              cmp CanOverObstacle,1

                              jnz    CHECK_TRACK_Red_Right_Second
                              call clear_red

                              MOV SI,positionX[0];NEW POSITION
                              mov Red_Current_X[0],SI;back
                              MOV SI,positionX[2]
                              dec SI;I add 1 BEFORE SO sub IT AGAIN
                              mov Red_Current_X[2],SI
                         
                              jmp CALL_Red_Move_Right;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CHECK_TRACK_Red_Right_Second:      cmp bl,Track_color
                              jne FINISH_Red_Move_Right_Break_break
                             jmp continue_Red_Right_Right
FINISH_Red_Move_Right_Break_break:
jmp far ptr FINISH_Red_Move_Right
continue_Red_Right_Right:
                              mov cx,Red_Current_X[2]
                              mov dx,Red_Current_Y[2]
                              add cx,1d
                              sub dx,5d
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                            call Check_power_up_red

                                      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             cmp Red_Run_Power_Up,1d;if enable power up 4
                              JNZ CHECK_TRACK_Red_Right_Middel
                              CMP enablePowerUpRed,4d 
                              jnz CHECK_TRACK_Red_Right_Middel
                              cmp bl,obstacleColor ;if it obstacle
                              jnz CHECK_TRACK_Red_Right_Middel
                              mov Red_Run_Power_Up,0h;find obstacle
                              mov enablePowerUpRed,0d ;used it
                              MOV SI,Red_Current_X[2];FOR CHECK 
                              cmp si,319d
                              jae CHECK_TRACK_Red_Right_Middel
                              inc SI;right inc current[2] is front back [0]
                              add SI,obstacleSize ;SUB THE OBST SIZE
                              cmp si,319
                              jae CHECK_TRACK_Red_Right_Middel
                              inc SI
                              cmp si,319
                              je CHECK_TRACK_Red_Right_Middel
                              MOV positionX[0],SI;THE NEW POSITIONS X[0] WILL BE THE BACK OF CAR [2] FRONT
                              
                              add SI,11d;;FOR CHECK CAR SIZE +1 
                              cmp si,319d
                              jae CHECK_TRACK_Red_Right_Middel
                              MOV positionX[2],SI;THE NEW POSITIONS
                              call PowerUp_4_Red_Right
                              cmp CanOverObstacle,1

                              jnz    CHECK_TRACK_Red_Right_Middel
                              call clear_red

                              MOV SI,positionX[0];NEW POSITION
                              mov Red_Current_X[0],SI;back
                              MOV SI,positionX[2]
                              dec SI;I add 1 BEFORE SO sub IT AGAIN
                              mov Red_Current_X[2],SI
                         
                              jmp CALL_Red_Move_Right;draw it
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                       CHECK_TRACK_Red_Right_Middel:       cmp bl,Track_color
                              jne FINISH_Red_Move_Right

                              jmp  far ptr CALL_Red_Move_Right
                              
                              FINISH_Red_Move_Right:
                                   jmp far ptr FINISH_RED


                         FINISH_RED:
                              jmp far ptr FINAL_RED




                         CALL_Red_Move_Down:  
                                             call clear_red
                                             mov cx,Red_Current_X[0];endpoint
                                             mov Dx,Red_Current_Y[2];endpoint
                                             add dx,2;ENDPOINT
                                              mov ah,0Dh;ENDPOINT
                                              mov al,0h
                                               int 10h
                                               mov bl,al
                                               cmp bl,03h
                                               jnz check_second_red_down
                                               mov is_Red_Win,1D
                                               jmp continue_RED_down_end
                                               check_second_red_down:
                                                cmp bl,0ch
                                               jnz continue_RED_down_end
                                               mov is_Red_Win,1D
                                               continue_RED_down_end:
                                             mov bx,Red_Current_X[0]

                                             mov  Current_X[0],bx
                                             mov  bx,Red_Current_X[2]
                                             mov  Current_X[2],bx
                                             mov  bx,Red_Current_Y[0]
                                             add  bx,Red_velocity
                                             mov  Red_Current_Y[0],bx
                                             mov  Current_Y[0],bx
                                             mov  bx,Red_Current_Y[2]
                                             add  bx,Red_velocity
                                             mov  Red_Current_Y[2],bx
                                             mov  Current_Y[2],bx
                                             lea  bx,red_car_back
                                             mov  si,bx
                                             call draw
                                              ;;;;;Nesma for obstacle
                                             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;obstacle;;untill ahmed send
                                           cmp Red_Run_Power_Up,1D
                                           jnz FINISH_Red_Move_Down_Obstacle_Break_Jmp
                                             cmp enablePowerUpRed,3d
                                             jnz FINISH_Red_Move_Down_Obstacle_Break_Jmp  
                                             mov enablePowerUpRed,0d    
                                             mov Red_Run_Power_Up,0d  

                                   mov cx,Red_Current_X[0];;x position
                                   mov dx,Red_Current_Y[0];y position
                                   sub dx,1d;sub by 1 to go the pixel back
                                   cmp dx,obstacleSize;;if smaller than the size 
                                   jb FINISH_Red_Move_Down_Obstacle_Break_Jmp
                                   sub dx,obstacleSize;to draw obst
                                   
                                   Power_Up_Red_Down_First:;loop
                                   mov ah,0dh
                                   mov al,0h
                                   int 10h
                                   cmp al,Track_color
                                   jne FINISH_Red_Move_Down_Obstacle_Break_Jmp
                                   inc dx     ;
                                   cmp dx,Red_Current_Y[0]
                                   jne  Power_Up_Red_Down_First;;stille check
     ;;;;;second check
                                   mov cx,Red_Current_X[2]
                                   mov dx,Red_Current_Y[0]
                                   sub dx,1
                                   sub dx,obstacleSize;to draw obst
                              Power_Up_Red_Down_Second:;loop
                                   mov ah,0dh
                                   mov al,0h
                                   int 10h
                                   cmp al,Track_color
                                   jne FINISH_Red_Move_Down_Obstacle
                                   inc dx     ;
                                   cmp dx,Red_Current_Y[0]
                                   jne  Power_Up_Red_Down_Second;;stille check
     ;;;;;;;;;;;;;;;;;;;;;middel check
                                   jmp Draw_Red_Obs_Down
                                   FINISH_Red_Move_Down_Obstacle_Break_Jmp: jmp FINISH_Red_Move_Down_Obstacle
                                   Draw_Red_Obs_Down:
                              ;jne  Power_Up_Red_Down_Middel;;stille check
                              ;;;;;;drow obstacle
                                   mov cx,Red_Current_X[0];;x position
                                   mov si,Red_Current_X[0]
                                   add si,obstacleSize
                                   mov dx,Red_Current_Y[0];y position
                                   sub dx,1d;sub by 1 to go the pixel back
                                   sub dx,obstacleSize;;if smaller than the size 
                                   Draw_Obstacle_For_Down_Red_Outer:;outerloop
                                   mov dx,Red_Current_Y[0];y position
                                   sub dx,1d;sub by 1 to go the pixel back
                                   sub dx,obstacleSize;;if smaller than the size 
                                   Draw_Obstacle_For_Down_Red_Inner:;inner loop
                                   mov ah,0ch
                                   mov al,obstacleColor
                                   int 10h
                                   inc dx
                                   cmp dx,Red_Current_Y[0]
                                   jnz Draw_Obstacle_For_Down_Red_Inner
                                   inc cx
                                   cmp cx,si
                                   jnz Draw_Obstacle_For_Down_Red_Outer
                                   jmp FINISH_Red_Move_Down_Obstacle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                              FINISH_Red_Move_Down_Obstacle:
                                   jmp far ptr FINISH_RED
               
                                             ;;;;;;;;;; ;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                             jmp  far ptr FINAL_RED
                         CALL_Red_Move_UP:    
                                             call clear_red
                                              mov cx,Red_Current_X[0];endpoint
                                             mov Dx,Red_Current_Y[0];endpoint
                                             dec dx;ENDPOINT
                                              mov ah,0Dh;ENDPOINT
                                              mov al,0h
                                               int 10h
                                               mov bl,al
                                               cmp bl,4h
                                               jnz check_second_color_red_up
                                               mov is_Red_Win,1D
                                               check_second_color_red_up:
                                                cmp bl,0ch
                                               jnz continue_RED_end_up
                                               mov is_Red_Win,1D
                                               continue_RED_end_up:

                                             mov  bx,Red_Current_X[0]
                                             mov  Current_X[0],bx
                                             mov  bx,Red_Current_X[2]
                                             mov  Current_X[2],bx
                                             mov  bx,Red_Current_Y[0]
                                             sub  bx,Red_velocity
                                             mov  Red_Current_Y[0],bx
                                             mov  Current_Y[0],bx
                                             mov  bx,Red_Current_Y[2]
                                             sub  bx,Red_velocity
                                             mov  Red_Current_Y[2],bx
                                             mov  Current_Y[2],bx
                                             lea  bx,red_car_front
                                             mov  si,bx
                                             call draw
;;;;;;;;;;;;;;;;;;;;obst power up;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;obstacle;;untill ahmed send
                                             cmp Red_Run_Power_Up,1d
                                             jnz FINISH_Red_Move_UP_Obstacle_Break_Jmp
                                             cmp enablePowerUpRed,3d
                                             jnz FINISH_Red_Move_UP_Obstacle_Break_Jmp  
                                             mov enablePowerUpRed,0d   
                                             mov Red_Run_Power_Up,0d  
 
                                             mov cx,Red_Current_X[0];;x position
                                             mov dx,Red_Current_Y[2];y position
                                             inc dx;sub by 1 to go the pixel bac
                                             add dx,obstacleSize;to draw obst
                                             CMP DX,200d
                                             JZ FINISH_Red_Move_UP_Obstacle_Break_Jmp
                                             Power_Up_Red_UP_First:;loop
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Red_Move_UP_Obstacle_Break_Jmp
                                             DEC dx     ;
                                             cmp dx,Red_Current_Y[2]
                                             jne  Power_Up_Red_UP_First;;stille check
                                             ;;;;;second check
                                             mov cx,Red_Current_X[2]
                                             mov dx,Red_Current_Y[2]
                                             ADD dx,1
                                             ADD dx,obstacleSize;to draw obst
                                        Power_Up_Red_UP_Second:;loop
                                        mov ah,0dh
                                        mov al,0h
                                        int 10h
                                        cmp al,Track_color
                                        jne FINISH_Red_Move_UP_Obstacle
                                        DEC dx     ;
                                        cmp dx,Red_Current_Y[2]
                                        jne  Power_Up_Red_UP_Second;;stille check
               ;;;;;;;;;;;;;;;;;;;;;middel check
                                        jmp Draw_Red_Obs_UP
                                        FINISH_Red_Move_UP_Obstacle_Break_Jmp:
                                        jmp FINISH_Red_Move_UP_Obstacle
                                        Draw_Red_Obs_UP:
                                        ;jne  Power_Up_Red_Down_Middel;;stille check
                                        ;;;;;;drow obstacle
                                             mov cx,Red_Current_X[0];;x position
                                             mov si,Red_Current_X[0]
                                             add si,obstacleSize
                                             mov dx,Red_Current_Y[2];y position
                                             ADD dx,1d;ADD by 1 to go the pixel back
                                             ADD dx,obstacleSize;;
                                             Draw_Obstacle_For_UP_Red_Outer:;outerloop
                                             mov dx,Red_Current_Y[2];y position
                                             ADD dx,1d;sub by 1 to go the pixel back
                                             ADD dx,obstacleSize;;if smaller than the size 
                                             Draw_Obstacle_For_UP_Red_Inner:;inner loop
                                             mov ah,0ch
                                             mov al,obstacleColor
                                             int 10h
                                             DEC dx
                                             cmp dx,Red_Current_Y[2]
                                             jnz Draw_Obstacle_For_UP_Red_Inner
                                             inc cx
                                             cmp cx,si
                                             jnz Draw_Obstacle_For_UP_Red_Outer
                                             jmp FINISH_Red_Move_UP_Obstacle
                                             FINISH_Red_Move_UP_Obstacle:

                                             jmp Jmp_Blue_Part
                                             Jmp_Blue_Part:   
                                                  jmp far ptr FINAL_RED


                                             
                         CALL_Red_Move_Left:
                                             call clear_red
                                             mov cx,Red_Current_X[0]
                                             mov dx,Red_Current_Y[0]
                                             sub cx,2d
                                             mov ah,0Dh
                                             mov al,0h
                                             int 10h
                                             mov bl,al
                                             cmp bl,3h
                                             jnz check_second_Red_color_left
                                             mov is_Red_Win,1d
                                             jmp continue_Left_Right_end_submain
                                             check_second_Red_color_left:
                                             cmp bl,0ch
                                            jnz continue_Left_Right_end_submain
                                             mov is_Red_Win,1d


              continue_Left_Right_end_submain:
                                             mov  bx,Red_Current_X[0]
                                             sub  bx,Red_velocity
                                             mov  Red_Current_X[0],bx
                                             mov  Current_X[0],bx
                                             mov  bx,Red_Current_X[2]
                                             sub  bx,Red_velocity
                                             mov  Red_Current_X[2],bx
                                             mov  Current_X[2],bx
                                             mov  bx,Red_Current_Y[0]
                                             mov  Red_Current_Y[0],bx
                                             mov  Current_Y[0],bx
                                             mov  bx,Red_Current_Y[2]
                                             mov  Red_Current_Y[2],bx
                                             mov  Current_Y[2],bx
                                             lea  bx,red_car_left
                                             mov  si,bx
                                             call draw
;;;;;;;;;;;;;;;;obst power up;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;obstacle;;untill ahmed send
                                              cmp Red_Run_Power_Up,1d
                                             jnz FINISH_Red_Move_Left_Obstacle_Break_Jmp
                                             cmp enablePowerUpRed,3d
                                             jnz FINISH_Red_Move_Left_Obstacle_Break_Jmp      
                                             mov enablePowerUpRed,0d
                                             mov Red_Run_Power_Up,0d  

                                             mov cx,Red_Current_X[2];;x position
                                             mov dx,Red_Current_Y[0];y position
                                             inc cx;INC  by 1 to go the pixel bacK
                                             add cx,obstacleSize;to draw obst
                                             CMP cx,320d;FOR CHECK
                                             JAE FINISH_Red_Move_Left_Obstacle_Break_Jmp
                                             Power_Up_Red_Left_First:;loop CHECK
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Red_Move_Left_Obstacle_Break_Jmp
                                             dec cx     ;
                                             cmp cx,Red_Current_X[2]
                                             jne  Power_Up_Red_Left_First;;stile check
                                             ;;;;;second check
                                             mov cx,Red_Current_X[2]
                                             mov dx,Red_Current_Y[2]
                                             ADD cx,1
                                             ADD cx,obstacleSize;to draw obst
                                        Power_Up_Red_Left_Second:;loop
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Red_Move_Left_Obstacle
                                             DEC cx     ;
                                             cmp cx,Red_Current_X[2]
                                             jne  Power_Up_Red_Left_Second;;stille check
               ;;;;;;;;;;;;;;;;;;;;;middel check
                                        jmp Draw_Red_Obs_Left
                                        FINISH_Red_Move_Left_Obstacle_Break_Jmp: jmp FINISH_Red_Move_Left_Obstacle
                                        Draw_Red_Obs_Left:
                                        ;;;;;;drow obstacle
                                             mov Dx,Red_Current_Y[0];;Y position
                                             mov si,Red_Current_Y[0]
                                             add si,obstacleSize
                                             mov Cx,Red_Current_X[2];X position
                                             ADD cx,1d;ADD by 1 to go the pixel back
                                             ADD CX,obstacleSize;;
                                             Draw_Obstacle_For_Left_Red_Outer:;outerloop
                                             mov Cx,Red_Current_X[2];y position
                                             ADD Cx,1d;sub by 1 to go the pixel back
                                             ADD Cx,obstacleSize;;if smaller than the size 
                                             Draw_Obstacle_For_Left_Red_Inner:;inner loop
                                             mov ah,0ch;;DRAW
                                             mov al,obstacleColor
                                             int 10h
                                             DEC Cx
                                             cmp Cx,Red_Current_X[2];COMPLETE THE WIDTH
                                             jnz Draw_Obstacle_For_Left_Red_Inner
                                             inc DX;FOR HEIGHT
                                             cmp Dx,si
                                             jnz Draw_Obstacle_For_Left_Red_Outer

                                             
                                             jmp FINISH_Red_Move_Left_Obstacle

                                             FINISH_Red_Move_Left_Obstacle:
                                             jmp  far ptr FINAL_RED
                         CALL_Red_Move_Right: 
                                             call clear_red
     mov cx,Red_Current_X[2]
                                             mov dx,Red_Current_Y[0]
                                             add cx,2d
                                             mov ah,0Dh
                                             mov al,0h
                                             int 10h
                                             mov bl,al
                                             cmp bl,3h
                                             jnz check_second_Red_color_
                                             mov is_Red_Win,1d
                                             jmp continue_RED_Right_end_submain
                                             check_second_Red_color_:
                                             cmp bl,0ch
                                            jnz continue_RED_Right_end_submain
                                             mov is_Red_Win,1d


              continue_RED_Right_end_submain:
                                             mov  bx,Red_Current_X[0]
                                             add  bx,Red_velocity
                                             mov  Red_Current_X[0],bx
                                             mov  Current_X[0],bx
                                             mov  bx,Red_Current_X[2]
                                             add  bx,Red_velocity
                                             mov  Red_Current_X[2],bx
                                             mov  Current_X[2],bx
                                             mov  bx,Red_Current_Y[0]
                                             mov  Red_Current_Y[0],bx
                                             mov  Current_Y[0],bx
                                             mov  bx,Red_Current_Y[2]
                                             mov  Red_Current_Y[2],bx
                                             mov  Current_Y[2],bx
                                             lea  bx,red_car_right
                                             mov  si,bx
                                             call draw
                                             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                             cmp Red_Run_Power_Up,1d
                                                  jnz FINISH_Red_Move_Right_Obstacle_Break_Jmp
                                                  cmp enablePowerUpRed,3d
                                             jnz FINISH_Red_Move_Right_Obstacle_Break_Jmp  
                                             mov enablePowerUpRed,0d    
                                                 mov Red_Run_Power_Up,0d  
                                             mov cx,Red_Current_X[0];;x position
                                             mov dx,Red_Current_Y[0];y position
                                             CMP CX,1D
                                             JBE FINISH_Red_Move_Right_Obstacle_Break_Jmp
                                             dec cx;INC  by 1 to go the pixel bacK
                                             CMP cx,obstacleSize;FOR CHECK
                                             JbE FINISH_Red_Move_Right_Obstacle_Break_Jmp
                                             sub cx,obstacleSize;to draw obst
                                             Power_Up_Red_Right_First:;loop CHECK
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Red_Move_Right_Obstacle_Break_Jmp
                                             inc cx     ;
                                             cmp cx,Red_Current_X[0]
                                             jne  Power_Up_Red_Right_First;;stile check
                                             ;;;;;second check
                                             mov cx,Red_Current_X[0]
                                             mov dx,Red_Current_Y[2]
                                             sub cx,1
                                             sub cx,obstacleSize;to draw obst
                                        Power_Up_Red_Right_Second:;loop
                                             mov ah,0dh
                                             mov al,0h
                                             int 10h
                                             cmp al,Track_color
                                             jne FINISH_Red_Move_Right_Obstacle
                                             inc cx     ;
                                             cmp cx,Red_Current_X[0]
                                             jne  Power_Up_Red_Right_Second;;stille check
               ;;;;;;;;;;;;;;;;;;;;;middel check
                                        jmp Draw_Red_Obs_Right
                                        FINISH_Red_Move_Right_Obstacle_Break_Jmp: jmp FINISH_Red_Move_Right_Obstacle
                                        Draw_Red_Obs_Right:
                                        ;;;;;;drow obstacle
                                             mov Dx,Red_Current_Y[0];;Y position
                                             mov si,Red_Current_Y[0]
                                             add si,obstacleSize
                                             mov Cx,Red_Current_X[0];X position
                                             sub cx,1d;ADD by 1 to go the pixel back
                                             sub CX,obstacleSize;;
                                             Draw_Obstacle_For_Right_Red_Outer:;outerloop
                                             mov Cx,Red_Current_X[0];y position
                                             sub Cx,1d;sub by 1 to go the pixel back
                                             sub Cx,obstacleSize;;
                                             Draw_Obstacle_For_Right_Red_Inner:;inner loop
                                             mov ah,0ch;;DRAW
                                             mov al,obstacleColor
                                             int 10h
                                             inc Cx
                                             cmp Cx,Red_Current_X[0];COMPLETE THE WIDTH
                                             jnz Draw_Obstacle_For_Right_Red_Inner
                                             inc DX;FOR HEIGHT
                                             cmp Dx,si
                                             jnz Draw_Obstacle_For_Right_Red_Outer
                                             jmp FINISH_Red_Move_Right_Obstacle
                                             FINISH_Red_Move_Right_Obstacle:
                                             jmp  far ptr FINAL_RED


     clear_red PROC
                          mov  bx,Red_Current_X[0]
                          mov  Current_X[0],bx
                          mov  bx,Red_Current_X[2]
                          mov  Current_X[2],bx
                          mov  bx,Red_Current_Y[0]
                          mov  Current_Y[0],bx
                          mov  bx,Red_Current_Y[2]
                          mov  Current_Y[2],bx
                          lea  bx,img_black
                          mov  si,bx
                          mov Draw_Request,1h
                          call draw
                          mov Draw_Request,0h
                          ret
     clear_red ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PowerUp_4_Red_Up Proc
mov CanOverObstacle,0d;CHECK CAN OVER OBSTACLE

                              mov direction,0h
                              mov cx,Red_Current_X[0]
                              mov dx,positionY[2]
                              First_Power_UP_Red_Check_Up:;;LOOP 
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_UP_POWER_UP_CHECK
                              DEC Dx 
                              CMP DX,positionY[0]
                              JNZ First_Power_UP_Red_Check_Up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;second check
                              mov cx,Red_Current_X[2]
                              mov dx,positionY[2]
                              Second_Power_UP_Red_Check_Up:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_blue
                              cmp bl,Track_color
                              jne FINSH_Red_UP_POWER_UP_CHECK
                              DEC DX
                              CMP DX,positionY[0]
                              JNZ Second_Power_UP_Red_Check_Up
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; middel check
                              mov cx,Red_Current_X[0]
                              add cx,5d
                              mov dx,positionY[2]

                              Middel_Power_UP_Red_Check_Up:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_UP_POWER_UP_CHECK
                               DEC DX
                              CMP DX,positionY[0]
                              JNZ Middel_Power_UP_Red_Check_Up
                              mov CanOverObstacle,1d
FINSH_Red_UP_POWER_UP_CHECK:
RET

PowerUp_4_Red_Up ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;down 
PowerUp_4_Red_Down Proc
mov CanOverObstacle,0d;CHECK CAN OVER OBSTACLE

mov direction,0h
                              mov cx,Red_Current_X[0]
                              mov dx,positionY[0];position [0] will be the back of car [2]front 
                              First_Power_UP_Red_Check_Down:
                              ;;LOOP 
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_Down_POWER_UP_CHECK
                              inc Dx ;down add not sub
                              CMP DX,positionY[2]
                              JNZ First_Power_UP_Red_Check_Down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;second check
                              mov cx,Red_Current_X[2]
                              mov dx,positionY[0]
                              Second_Power_UP_Red_Check_Down:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_Down_POWER_UP_CHECK
                              inc DX
                              CMP DX,positionY[2]
                              JNZ Second_Power_UP_Red_Check_Down
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; middel check
                              mov cx,Red_Current_X[0]
                              add cx,5d
                              mov dx,positionY[0]

                              Middel_Power_UP_Red_Check_Down:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_BLUE
                              cmp bl,Track_color
                              jne FINSH_Red_Down_POWER_UP_CHECK
                               inc DX
                              CMP DX,positionY[2]
                              JNZ Middel_Power_UP_Red_Check_Down
                              mov CanOverObstacle,1d
FINSH_Red_Down_POWER_UP_CHECK:
RET

PowerUp_4_Red_Down ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PowerUp_4_Red_Left Proc
mov CanOverObstacle,0d;CHECK CAN OVER OBSTACLE

mov direction,0h
                              mov cx,positionX[0]
                              mov dx,Red_Current_Y[0];position [0] will be the back of car [2]front 
                              First_Power_UP_Red_Check_Left:;;LOOP 
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_Left_POWER_UP_CHECK
                              dec cx ;down add not sub
                              CMP cx,positionX[2]
                              JNZ First_Power_UP_Red_Check_Left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;second check
                              mov cx,positionX[0]
                              mov dx,Red_Current_Y[2]
                              Second_Power_UP_Red_Check_Left:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_Left_POWER_UP_CHECK
                              dec cx
                              CMP cX,positionX[2]
                                 JNZ Second_Power_UP_Red_Check_Left
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; middel check
                              mov cx,positionX[0]
                             mov dx,Red_Current_Y[0]

                              add dx,5d

                              Middel_Power_UP_Red_Check_Left:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_Left_POWER_UP_CHECK
                              dec CX
                              CMP CX,positionX[2]
                              JNZ Middel_Power_UP_Red_Check_Left
                              mov CanOverObstacle,1d
FINSH_Red_Left_POWER_UP_CHECK:
RET

PowerUp_4_Red_Left ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PowerUp_4_Red_Right Proc
mov CanOverObstacle,0d;CHECK CAN OVER OBSTACLE

mov direction,0h
                              mov cx,positionX[0]
                              mov dx,Red_Current_Y[0];position [0] will be the back of car [2]front 
                              First_Power_UP_Red_Check_Right:;;LOOP 
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_Right_POWER_UP_CHECK
                              inc cx ;down add not sub
                              CMP cx,positionX[2]
                              JNZ First_Power_UP_Red_Check_Right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;second check
                              mov cx,positionX[0]
                              mov dx,Red_Current_Y[2]
                              Second_Power_UP_Red_Check_Right:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_Right_POWER_UP_CHECK
                              inc cx
                              CMP cX,positionX[2]
                                 JNZ Second_Power_UP_Red_Check_Right
                              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; middel check
                              mov cx,positionX[0]
                             mov dx,Red_Current_Y[0]

                              add dx,5d

                              Middel_Power_UP_Red_Check_Right:
                              mov ah,0dh
                              mov al,0h
                              int 10h
                              mov bl,al
                              call Check_power_up_red
                              cmp bl,Track_color
                              jne FINSH_Red_Right_POWER_UP_CHECK
                              inc CX
                              CMP CX,positionX[2]
                              JNZ Middel_Power_UP_Red_Check_Right
                              mov CanOverObstacle,1d
FINSH_Red_Right_POWER_UP_CHECK:
RET

PowerUp_4_Red_Right ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     Check_power_up_red PROC
                              cmp bl,first_power_color
                              jne check_1R
                              mov enablePowerUpRed,1h
                              mov Power_UP_Start_point[0],cx
                              mov Power_UP_Start_point[2],dx
                              call clearPower
                              jmp continue_R

                              check_1R:
                              cmp bl,second_power_color
                              jne check_2R
                              mov enablePowerUpRed,2h
                              mov Power_UP_Start_point[0],cx
                              mov Power_UP_Start_point[2],dx
                              call clearPower
                              jmp continue_R

                              check_2R:
                              cmp bl,third_power_color
                              jne check_3R
                              mov enablePowerUpRed,3h
                              mov Power_UP_Start_point[0],cx
                              mov Power_UP_Start_point[2],dx
                              call clearPower
                              jmp continue_R


                              check_3R:
                              cmp bl,forth_power_color
                              jne continue_R
                              mov enablePowerUpRed,4h
                              mov Power_UP_Start_point[0],cx
                              mov Power_UP_Start_point[2],dx
                              call clearPower
                              jmp continue_R
                           
                              continue_R:
                              ret

     Check_power_up_red ENDP
     FINAL_RED:
     ret
CARRED ENDP




clearPower PROC near
     cmp direction,0h ;; the power up is above
     je above
     cmp direction,1h ;; the power up is down
     je down
     cmp direction,2h ;; the power up is left
     je left
     cmp direction,3h ;; the power up is right
     je right
     jmp far ptr end_of_clear_power

     above:    
               mov cx,Power_UP_Start_point[0]
               mov dx,Power_UP_Start_point[2]
               add cx,1
               loop1:
                    dec cx
                    mov ah,0dh
                    mov al,0h
                    int 10h
                    cmp al,bl
                    je loop1
               add cx,1
               mov Power_UP_Start_point[0],cx
               sub dx,7d
               mov Power_UP_Start_point[2],dx

               jmp far ptr end_of_clear_power
     down:
               mov cx,Power_UP_Start_point[0]
               mov dx,Power_UP_Start_point[2]
               add cx,1
               loop2:
                    dec cx
                    mov ah,0dh
                    mov al,0h
                    int 10h
                    cmp al,bl
                    je loop2
               add cx,1
               mov Power_UP_Start_point[0],cx
               mov Power_UP_Start_point[2],dx

               jmp far ptr end_of_clear_power
     left:
               mov cx,Power_UP_Start_point[0]
               mov dx,Power_UP_Start_point[2]
               add dx,1
               loop3:
                    dec dx
                    mov ah,0dh
                    mov al,0h
                    int 10h
                    cmp al,bl
                    je loop3
               add dx,1
               mov Power_UP_Start_point[2],dx
               sub cx,7d
               mov Power_UP_Start_point[0],cx

               jmp far ptr end_of_clear_power
     right:
               mov cx,Power_UP_Start_point[0]
               mov dx,Power_UP_Start_point[2]
               add dx,1
               loop4:
                    dec dx
                    mov ah,0dh
                    mov al,0h
                    int 10h
                    cmp al,bl
                    je loop4
               add dx,1
               mov Power_UP_Start_point[2],dx
               mov Power_UP_Start_point[0],cx
               jmp far ptr end_of_clear_power


     end_of_clear_power:
          mov bx,Power_UP_Start_point[0]
          dec bx
          mov Current_X[0],bx
          mov dx,Power_UP_Start_point[0]
          add dx,8d
          mov Current_X[2],dx

          mov bx,Power_UP_Start_point[2]
          dec bx
          mov Current_Y[0],bx
          mov dx,Power_UP_Start_point[2]
          add dx,8d
          mov Current_Y[2],dx

          lea  bx,img_black
          mov  si,bx
          call draw

          ret
      
clearPower ENDP




end




























































