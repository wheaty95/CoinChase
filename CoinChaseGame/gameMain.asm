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

MOVEMENT_AMOUNT = #$5
PRINT_LINE = $AB1E ;basic function
CLEAR = $E544 ;basic function

score = $0811


MSBX    = $D010
ENABLE  = $D015
COLLISION_FLAG  = $D01E ;collsion flag
TOTAL_NEEDED_FOR_GAME_OVER = #%00001010

main
        jmp load
        jmp gameloop 
  
GAMELOOP  
        ; Wait for scanline 255
        LIBSCREEN_WAIT_V 255

        jsr libInputUpdate

        jsr libSpritesUpdate
        jsr gamePlayerUpdate
        jsr COLLISION
        jsr CLEAR
        ldx #$00
        jsr RenderText 
        jsr CheckGameOver
        jmp GAMELOOP

CheckGameOver
        ldy score
        cpy TOTAL_NEEDED_FOR_GAME_OVER
        bne GAMELOOP

        jsr GAME_OVER_START

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
        jsr enemyCollision
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
        jmp MENU_START
  
LOAD
        sei
        jsr gamePlayerInit        
        jsr gameEnemyInit

        jmp POST_LOAD