
   extrn chatmes:byte 
  extrn   gamemes : byte 
   extrn exemes :byte  
   extrn  enterKey :byte
   public choose
.model small
.CODE
choose proc far
            
              chooseScreen:
              mov ax,0003h       ;clearscreen
              mov cx,0h          ;clear
              mov dh,24d         ;clear
              mov dl,70d
              int 10h
              mov ah,2h          ;curser
              mov dx ,0517h      ;row 7 colum 23
              int 10h
              mov ah,9h          ;print first message
              lea dx,chatmes
              int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;
              mov ah,2h          ;curser
              mov dx ,0917h      ;row 7 colum 23
              int 10h
              mov ah,9h          ;print second message
              lea dx,gamemes
              int 21h
    ;;;;;;;;;;;;;;;;;;;;;;
              mov ah,2h          ;curser
              mov dx ,0d17h      ;row 7 colum 23
              int 10h
              mov ah,9h          ;print third message
              lea dx,exemes
              int 21h

    ;;;;;;;;;;;notification bar;;;;;;;;;;;;;;
              mov dh,14h         ;for curser
              mov dl,00h

    printDash:                   ;for print-
              mov ah,02h
    ;move curser to show notification
              int 10h
              mov cl,dl
              mov ah,02h
              mov dl,'-'
              int 21h
              mov dl,cl
              add dl,1d
              cmp dl,80d         ;from dtart screen to end
              jnz printDash


    ;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;take char;;;;;;;;;;;;;;;;;;;;;;;;
              mov ah,02h
              mov dx ,0f17h      ;row 7 colum 23
              int 10h
              mov ah,0h
              int 16h
              cmp ah,01h  ; If Person Clicked ESC
              jnz takeF
              mov ah,4ch  ; Close the Program
              int 21h
    takeF:    
              cmp ah,60d
             jnz chooseScreen
              mov enterKey,ah
              ret
             
hlt
choose endp
end 
