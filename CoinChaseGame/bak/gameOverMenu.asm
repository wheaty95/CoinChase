gameOverTextX      byte 15
gameOverTextY      byte 10


gameOverText
      text 'Game Over!'
                        byte 0

GAME_OVER_LOOP
        ; Wait for scanline 255
        LIBSCREEN_WAIT_V 255
        jsr libInputUpdate
      
        LIBSCREEN_DRAWTEXT_AAAV gameOverTextX, gameOverTextY, gameOverText, White
       
        jsr libSpritesUpdate    

        LIBINPUT_GETHELD GameportFireMask
        beq GAME_OVER_END
        jmp GAME_OVER_LOOP
        
GAME_OVER_END
        jmp QUIT

GAME_OVER_START
        jsr CLEAR
        LIBSPRITE_ENABLE_AV             playerSprite, True
        LIBSPRITE_ENABLE_AV             rivalSprite, False

        LDX #170 ;XPos 
        LDY #160 ;YPos 
        STX SP0X 
        STY SP0Y            

        LIBSPRITE_STOPANIM_A playerSprite
        LIBSPRITE_SETFRAME_AV playerSprite,13
        LIBSPRITE_SETCOLOR_AV           playerSprite, Cyan

        jmp GAME_OVER_LOOP

