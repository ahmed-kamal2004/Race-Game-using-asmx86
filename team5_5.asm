;extrn username:byte
;public login

   extrn username:byte            
  extrn  userenter   :byte   
    extrn  userenter2   :byte         
      
  extrn  Morethan15  :byte         
  extrn  NOTLETTER    :byte        
  extrn  InitialPoint     :  byte
   extrn InitialNumber   : byte                                                      ;initial point as number
   extrn InitialPointMes  :byte   

   extrn  continueToSecondPage :byte
   public login 
    .model small

.CODE
login proc far
                      
                         mov  ax,0003h                   ;clearscreen
                         mov  cx,0h                      ;clear
                         mov  dh,24d                      ;clear
                         mov  dl,70d
                         int  10h
    enternameLabel:      
                      
                         cmp bx,2h      
                           jz name2
                        lea  dx,userenter               ;point to the userenter1
                         jmp namecoml;to not enter in the next
                        name2: lea  dx,userenter2;player2

                       namecoml:
                        mov  ah,9h                      ;display enter you name
                         int  21h                        ;interrupt
                         mov  ah,2h                      ;move curser
                         mov  dh,1h                      ;move curser
                         mov  dl,2h
                         int  10h
                         mov  ah,0ah                     ;read name
                         lea  dx,username
                         int  21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHECK NUMBER OF CHAR
                         cmp  username[18],'$'           ;check 15char
                         jnz  name_15                    ;more than 15char

    ;;;;;;;;;;;;;;;;;;;checkfirstchar;;;;;;;;;
                         cmp  username[2],'A'            ;if<'A' error
                         jc   name_firstnotchar
                         cmp  username[2], 'z'           ;>'z' error
                         jnc  name_firstnotchar
                         cmp  username[2],'Z'            ;bwtween A TO Z TRUE
                         jnc  aftercheck
                         cmp  username[2],'a'            ;BETWWN a to z true
                         jnc  name_firstnotchar
    ;;;;;;;;;;;;;;;;;;;;;;;;;
                         JMP  aftercheck
    ;;;;;;;;;;;;;;;;;;;;;toke again becuse cha>15;;;;;;;;;;;;;;;;;;;
    name_15:             
                      
                         lea  di,username[2]             ;;to clear string $
                         mov  cx,17d
                         mov  al,'$'
                         repe stosb
                         mov  ax,0003h                   ;clearscreen
                         mov  cx,0h                      ;clear
                         mov  dh,1h                      ;clear
                         mov  dl,79d
                         int  10h
                         mov  ah,9h                      ;display enter you name
                         lea  dx,Morethan15              ;point to the morethan15
                         int  21h                        ;interrupt
                         jmp  enternameLabel
    ;;;;;;;;;;;;;;;;;;;;;;;first not letter;;;;;;;;;;;
    name_firstnotchar:   
                         mov  ah,2h
                         mov  dh,2h
                         mov  dl,2h
                         int  10h
                         lea  di,username[2]             ;;to clear string $
                         mov  cx,17d
                         mov  al,'$'
                         repe stosb
                         mov  ax,0003h                   ;clearscreen
                         mov  cx,0h                      ;clear
                         mov  dh,1h                      ;clear
                         mov  dl,79d
                         int  10h
                         mov  ah,9h                      ;display enter you name
                         lea  dx,NOTLETTER               ;point to the morethan15
                         int  21h                        ;interrupt
                         jmp  enternameLabel
    aftercheck:          
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INITILA POINT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               checkpointenter:

               mov ah,0003h;clear
               mov cx,0200h
               mov dx,184fh
               int 10h
                         mov  ah,2h                      ;curser
                         mov  dh,2h                      ;;row
                         mov  dl,0h                      ;;col
                         int  10h
                      
                         mov  ah,9h                      ;display enter you initial points
                         lea  dx,InitialPointMes
                         int  21h
                      
                         mov  ah,2h                      ;curser
                         mov  dh,3h
                         mov  dl,2h
                         int  10h
                      
                         mov  ah,0ah                     ;print
                         lea  dx,InitialPoint
                         int  21h
                         mov al,InitialPoint[2]
                         sub al,'0'
                         cmp  al,9h
                         jnc checkpointenter;check if he enter char
                         
                      
                         cmp  InitialPoint[3],0dh        
                         jz   initial_point_create
                         mov al,InitialPoint[3]
                         sub al,'0'
                         cmp  al,9h
                         jnc checkpointenter;check if he enter char
                         
 
                         mov  al,InitialPoint[2]         ;; first one *10+second one
                         sub  al,'0'
                         mov  bl,10d
                         mul  bl
                         mov  ah,InitialPoint[3]
                         sub  ah,'0'
                         add  al,ah
   
                         mov  InitialNumber, al
                         jmp  after_point_check
      
    initial_point_create:                                ;only one digit
                         mov  al,InitialPoint[2]
                         mov  InitialNumber,al
                         sub  InitialNumber,'0'
    ;;;;;;;;;;;;;;;;;;enter key;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    after_point_check:   
                         mov  ah,0003h
                         mov  cx,0400h
                         mov  dh,05h
                         mov  dl,79d
                         int  10h
                         mov ah,02h
                         mov dh,04h
                        mov dl,0h
                         int 10h
                         mov  ah,9h                      ;display enter you initial points
                         lea  dx,continueToSecondPage
                         int  21h
                         mov  ah,7h
                         int  21h
                         cmp  al,0dh
                         jnz  after_point_check
                      
    ;mov  ah,02h
    ;ADD InitialNumber,'0'            ;print
    ;mov dl, InitialNumber
    ;int  21h
  ret
login endp
end   