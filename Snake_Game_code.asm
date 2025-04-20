[org 0x0100]

jmp start
position_x: dw 0
position_y: dw 0
food: dw 0
GameOver: db 'Game Over'
current_score: db '0'
score: db 'Score: '
snake: db 02,265,265,265,265   ; Initial snake representation  (asciis store)      
snake_length: dw 5
direction: db 3
delaytime: dd 0
snake_locations:dw 0  ; Array to store snake locations

snake_heading: db "SNAKE GAME",0
names: db "    MUHAMMAD ZAHID (22F-3394)                                                           M.SARMAD (22F-3312)",0
enterr: db "Welcome To Snake Game",0

instruction8: db "Arrows Keys",0
instruction1: db "Up", 0
instruction2: db "Left",0
instruction6: db "Down",0
instruction7: db "Right",0
instruction0: db "CONTROLLER INSTRUCTIONS", 0
instruction3: db "PLAYING INSTRUCTIONS :", 0
instruction4: db "1) Snake will die if it collides with  boundary", 0
instruction5: db "2) Snake will die if it collides with itself", 0
pause_snake : db "3) Press p to pause the game",0
exit_snake  : db "4) Press e to exit the game",0
startt      : db "5) Press any key to start", 0
food_color: db 0x1E02

;================ SCREEN CLEARING ===================
clearscreen:    
    push ax
    push es
    push di
    mov ax, 0xb800
    mov es, ax
    mov di, 0
clr:
    mov word [es:di], 0x0720
    add di, 2
    cmp di, 4000
    jne clr
    pop di
    pop es
    pop ax
    ret



;================ STRING PRINTING SUBROUTINE ================
printstr: push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push ds
pop es 
mov di, [bp+4]
mov cx, 0xffff      
xor al, al  
repne scasb          
mov ax, 0xffff        
sub ax, cx  
dec ax            
jz exit1                
mov cx, ax          
mov ax, 0xb800    
mov es, ax      
mov al, 80            
mul byte [bp+8]      
add ax, [bp+10]
shl ax, 1        
mov di,ax                    
mov si, [bp+4]    
mov ah, [bp+6]        
cld                  
nextchar: lodsb    
stosw                      
loop nextchar                  
exit1: pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 8


;================ PRINTING Working ================
welcomeuser:

    push 28
    push 4
    mov ax, 0x05
    push ax
    mov ax,enterr
    push ax
    call printstr
    push 24
    push 6
    mov ax, 0x04
    push ax
    mov ax,names
    push ax
    call printstr

    push 28
    push 9
    mov ax, 0x09
    push ax
    mov ax, instruction0
    push ax
    call printstr
    push 24
    push 13
    mov ax, 0x04
    push ax
    mov ax, instruction8
    push ax
    call printstr
    push 40
    push 12
    mov ax, 0x07
    push ax
    mov ax, instruction1
    push ax
    call printstr
    push 40
    push 13
    mov ax, 0x08
    push ax
    mov ax, instruction2
    push ax
    call printstr
    push 40
    push 14
    mov ax, 0x0A
    push ax
    mov ax, instruction6
    push ax
    call printstr
    push 40
    push 15
    mov ax, 0x06
    push ax
    mov ax, instruction7
    push ax
    call printstr
    push 0
    push 17
    mov ax, 0x09
    push ax
    mov ax, instruction3
    push ax
    call printstr

    push 0
    push 18
    mov ax, 0x03
    push ax
    mov ax, instruction4
    push ax
    call printstr

    push 0
    push 19
    mov ax, 0x03
    push ax
    mov ax, instruction5
    push ax
    call printstr
    push 0
    push 20
    mov ax, 0x03
    push ax
    mov ax,pause_snake
    push ax
    call printstr

    push 0
    push 21
    mov ax, 0x03
    push ax
    mov ax,exit_snake
    push ax
    call printstr

    push 0
    push 22
    mov ax, 0x03
    push ax
    mov ax,startt
    push ax
    call printstr

    ret

      ;=====================================================
      ; Function to draw the snake at specified locations
      ;=====================================================
draw_snake:
    push bp
    mov bp, sp
    push ax
    push bx
    push si
    push cx
    push dx

    mov si, [bp + 6]        ;;; load snake representation 02,254,254,254,254
    mov cx, 5
    mov di,490            ;;;location of snake                                       ++++++++++++++
    mov ax, 0xb800
    mov es, ax

    mov bx, [bp + 4]         ;;;load array of snake loaction
    mov ah, 0x06
    snake_next_part:
        mov al, [si]
        mov [es:di], ax
        mov [bx], di
        inc si
        add bx, 2
        sub di, 2
        loop snake_next_part

    pop dx
    pop cx
    pop si
    pop bx
    pop ax
    pop bp
    ret 6
           ;=========================================
             ; Function to print the current score
            ;=========================================
printScore:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di
    push es

    cmp byte[current_score], 58
    jne s
    mov byte[current_score],'A'
    s:
    mov si, score
    mov ax, 0xb800
    mov ah, 0x07
    mov di, [bp + 4]
    mov cx, 7
    p:
        lodsb
        stosw
    loop p
    mov al, [current_score]
    mov [es:di], ax

    pop es
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2
           ;=========================================       
             ; Function to move the snake left
           ;=========================================
move_snake_left:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake itself parts collision check
    mov bx, [bp + 4]   ; snake locations        
    mov dx, [bx] ; snake head

    mov cx, [bp + 8]; len of snake
    dec cx
    sub dx, 2 ; dx = 1978
    check_left_collision:
        cmp dx, [bx]
        je no_left_movement
        add bx, 2
        loop check_left_collision
    left_movement:
    mov si, [bp + 6]            ;snake
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax
    left_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2

        loop left_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    jmp end1
    no_left_movement:
    call over
    end1:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;-----------------------------------------------------------------------------------
; Function to move the snake up
move_snake_up:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts collision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    dec cx

    sub dx, 160

    check_up_collision:
        cmp dx, [bx]
        je no_up_movement
        add bx, 2
        loop check_up_collision

    upward_movement:
    mov si, [bp + 6]            ;snake
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax
    up_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2

        loop up_location_sort

    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    jmp end2

    no_up_movement:
    call over
    end2:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;=========================================
; Function to move the snake down
;=========================================
move_snake_down:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts collision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    dec cx
    add dx, 160
    check_down_collision:
        cmp dx, [bx]
        je no_down_movement
        add bx, 2
        loop check_down_collision

    downward_movement:
    mov si, [bp + 6]            ;snake
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax
    down_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        loop down_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    jmp end3

    no_down_movement:
    call over
    end3:

    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;=========================================
; Function to move the snake right
;=========================================
move_snake_right:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts collision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    dec cx
    add dx, 2
    check_right_collision:
        cmp dx, [bx]
        je no_right_movement
        add bx, 2
        loop check_right_collision

    right_movement:
    mov si, [bp + 6]            ;snake
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax
    right_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
       
        loop right_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    jmp end4
    no_right_movement:
    call over
    end4:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;=========================================
       ; Collsion Checking
;=========================================
check_death:
    push ax
    push di
    push cx

    mov ax, [snake_locations]
    cmp ax, 160
    jb finished
    mov di, 160              
    mov cx, 24

    check1:
        cmp ax, di
        je finished
        add di, 158
        cmp ax, di
        je finished
        add di, 2

        loop check1
   
    mov di, 3840
    cmp ax, di
    ja finished
    jmp else

    finished:
    call over
    else:
        pop cx
        pop di
        pop ax
    ret
   
;=========================================
 ;   KEYBOARD INTTERUPT SUBROUTINE
;=========================================
snake_int:
    push ax

    xor ax, ax
    mov ah, 0x01
    int 0x16 ; call BIOS keyboard service
    jz no_int
    call movement
    no_int:

    pop ax
    ret


pausee:
    call pausing
    jmp st
pausing:
    looping_pausing:
    call snake_int
    jmp looping_pausing
ret
exit_snnk:
call over

    ;======== Play Game =========
Gaming_Zone:
    call clearscreen
    call welcomeuser
 
    xor ax, ax
    mov ah,0
    int 0x16 ; call BIOS keyboard service

    call clearscreen
    call draw_border

    push word [snake_length]   ;5
    push snake
    push snake_locations    
    call draw_snake       ;draw snake at locations
    call displayFood

    repeat:
    push 230
    call printScore
    cmp byte[current_score], '10'
    jae level1
    mov dword[delaytime], 200000
    level1:
    mov dword[delaytime], 120000

    delay:
        dec dword[delaytime]
        cmp dword[delaytime], 0
        jne delay

    mov ah, 01h
    int 16h
    jz noKey
  movement:
    mov ah, 0
    int 16h
   
    cmp ah, 0x48 ;up arrow
    je up
    cmp ah, 0x4B ;left arrow
    je left
 
    cmp ah, 0x50 ;down arrow
    je down
       cmp ah, 0x4D ;right arrow
    jne noright
    jmp right
    noright:
    cmp al,0x70
    je pausee
     cmp al,0x65
    je exit_snnk
    st:
    cmp ah, ' '
    jne repeat      
    mov ah, 0x4c
    int 21h
    je exit2
    exit2:
    pop bx
    pop ax
    ret
   
    noKey:
        cmp byte[direction], 0
        je up
        cmp byte[direction], 1
        je down
        cmp byte[direction], 2
        je left
        cmp byte[direction], 3
        je right

    up:
    cmp byte [direction], 1
    je down
        mov byte[direction], 0
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_up
       jmp new


    down:
        cmp byte [direction], 0
    je up
        mov byte[direction], 1
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_down
        jmp new


    left:
        cmp byte [direction], 3
    je right
        mov byte[direction], 2
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
       
        push bx
        call move_snake_left
        jmp new

    right:
        cmp byte [direction], 2
    je left
        mov byte[direction], 3
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_right

    new:
        call check_death

        push ax
        mov ax, word[food]
        cmp ax, [snake_locations]
        jne f
        call displayFood
        add word[snake_length], 1
        add byte[current_score], 1

    f:
        pop ax
        jmp repeat

    exit:
        pop bx
        pop ax
        ret
;=========================================
  ; display food at a random position
;=========================================
displayFood:
    push  bp
    push bx
    push ax
    push cx
    push dx
    push es
    push di

    l1:
    rdtsc          ; read time stamp counter in dx:ax

    add  ax, dx             ; randomize
    mov  cx, 25    
    div  cx      

    mov word[position_x], dx

    rdtsc

    add  ax, dx

    mov  cx, 80  
    div  cx       ; here dx contains the remainder of the division - from 0 to 9

    mov word[position_y], dx

    mov ax, [position_x]
    mov bx, 80
    mul bx
    add ax, [position_y]
    shl ax, 1
    mov bx,ax
    mov cx,160
    cmp ax, 3840
     jg  l1
     cmp ax, 160
     jb l1
   
     div cx
     cmp dl,0
     je l1
     xor dl,dl
     mov ax,bx
     mov cx,160
     add ax,2
     div cx
     cmp dl,0
     je l1
     mov ax,bx


    mov word[food], ax
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov al, 7
    mov ah, 10000011b
    mov [es:di], ax

    pop di
    pop es
    pop dx
    pop cx
    pop ax
    pop bx
    pop bp
    ret
;=========================================
   ; Function to draw the game border
;=========================================
draw_border:
    push ax
    push bx
    push es
    push di
    push si
    push cx

    mov ax, 0xb800
    mov es, ax
    mov di,0

    mov cx, 80     ;set coloumn
    mov ah, 0x10                                                                           
    mov al, 260                          ; set the ASCII character for the border    
    top_border:
        mov [es:di], ax
        mov [es:di+3840], ax
        add di, 2                  ;print border on top
        loop top_border

    mov cx, 25                         ;set row
    mov di,0
    left_border:
        mov [es:di], ax
        mov [es:di+158], ax
        add di, 160                     ;each line print border on left side
        loop left_border

    pop cx
    pop si
    pop di
    pop es
    pop bx
    pop ax
    ret
;=========================================
    ;  game over Checking
;=========================================
over:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push es
    push si
    push di

    mov ax, 0xb800
    mov ah, 0x04
    mov si, GameOver
    mov cx, 9
    mov di, 1510
    printMsg:
        lodsb
        stosw
        loop printMsg
    push 1670
    call printScore

    pop di
    pop si
    pop es
    pop cx
    pop bx
    pop ax
    pop bp
    mov ax, 0x4c00
    int 0x21
    ret

;===========================
; Main program entry point
;===========================
start:
    call Gaming_Zone
    mov ax, 0x4c00
    int 0x21