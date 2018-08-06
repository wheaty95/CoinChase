;Starting point of the program
;sys20645

*=$0801 
  byte $0c,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00,$00
*=$0810 

get = $ffe4 ;input control
SPACE = $20 ;key value
W_KEY = $57 ;key value
E_KEY = $45 ;key value
T_KEY = $54 ;key value
S_KEY = $53 ;key value
A_KEY = $41 ;key value
D_KEY = $44 ;key value
NUM_1_KEY = $31 ;key value

posX    = $D000
posY    = $D001

pos1X    = $D002
pos1Y    = $D003

sprite1Color = $D027
sprite2Color = $D028

spriteDataLocation = #$80
sprite1DataLocation = #$80


MOVEMENT_AMOUNT = #$5
PRINT_LINE = $AB1E ;basic function
CLEAR = $E544 ;basic function

score = $0811

leftBit = $0812


MSBX    = $D010
ENABLE  = $D015
COLLISION_FLAG  = $D01E ;collsion flag

main
        jmp load
        jmp gameloop 
  
GAMELOOP  
        jsr get
        cmp #W_KEY ; Check the W Key for input
        beq UP
 
        cmp #S_KEY ; Check the S Key for input
        beq DOWN

        jsr checkLeft

        cmp #D_KEY ; Check the D Key for input
        beq RIGHT

        cmp #NUM_1_KEY ; Check the 1 Key for input
        beq quit

        jsr COLLISION
        jsr CLEAR
        ldx #$00
        jsr RenderText 
        jsr RenderEnemyAnim
        jsr movement
        jmp GAMELOOP

RenderText
        ldx #$00
        jsr RENDER_SCORE_TEXT

        ldx #$00
        jsr RENDER_SCORE
        rts

COLLISION
;if collision
        ldy COLLISION_FLAG
        cpy #%00000011            ;check to see if there has been a collision between sprite 1 and 2
        beq CollisionBetweenSprite1and2      
;else  
        rts

CollisionBetweenSprite1and2
        jsr AssignRandomValueIntoLDA 
        sta pos1X     
        jsr AssignRandomValueIntoLDA 
        sta pos1Y   
        jsr INCREASE_SCORE
        rts

INCREASE_SCORE
        ldX score
        INC score
        rts

QUIT ;quit out of the program (Clean up)
        JSR CLEAR
        LDA #0
        STA ENABLE
        RTS
  
UP              
        LDA posY
        sec
        sbc MOVEMENT_AMOUNT
        STA posY
        jmp GAMELOOP

DOWN           
        LDA posY
        clc
        adc MOVEMENT_AMOUNT
        STA posY
        jmp GAMELOOP

LEFT           
        LDA posX
        sec
        sbc MOVEMENT_AMOUNT
        STA posX

        LDX posX
        CPX #255
        bne OVERFLOW_CHECK

        LDX #0
        STX MSBX
        jmp GAMELOOP

RIGHT           
        LDA posX
        clc
        ADC MOVEMENT_AMOUNT
        STA posX

        LDX posX
        CPX #255
        bne OVERFLOW_CHECK

        LDA #1
        STA MSBX
        jmp GAMELOOP
     


movement
        lda leftBit
        cmp 1
        beq LEFT
        rts


checkLeft
        jsr $ffe4
        cmp #A_KEY ; Check the W Key for input
        beq leftDown

        jsr leftUp
        rts

leftDown
        lda 1
        sta leftBit
        rts

leftUp
        jsr CollisionBetweenSprite1and2
        lda 0
        sta leftBit
        rts


OVERFLOW_CHECK
        jmp GAMELOOP 
        rts

InitSIDChip
        LDA #$FF  ; maximum frequency value
        STA $D40E ; voice 3 frequency low byte
        STA $D40F ; voice 3 frequency high byte
        LDA #$80  ; noise waveform, gate bit off
        STA $D412 ; voice 3 control register
        rts

POST_LOAD
        lda #0
        sta score
        jsr InitSIDChip
        jsr INIT_SPRITES
        jmp GAMELOOP

  
LOAD
        lda spriteDataLocation ;pointer to the sprite data
        sta $07f8
        LDX #100 ;XPos
        LDY #70 ;YPos
        STX posX
        STY posY
        lda 1
        sta sprite1Color


        lda sprite1DataLocation ;pointer to the sprite data
        sta $07f9
        LDX #100 ;XPos
        LDY #100 ;YPos
        STX pos1X
        STY pos1Y
        lda 3
        sta sprite2Color

        lda #$03
        sta $d015 ;sprite enable flag 01 Only sprite one. 02 Only sprite 2. 03 sprite 1 and 2



        jmp POST_LOAD