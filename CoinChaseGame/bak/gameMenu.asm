flowStartX      byte 9
flowStartY      byte 20

gameDescX      byte 7
gameDescY       byte 11

descX      byte 8
descY      byte 21

flowStartText
      text 'PRESS FIRE TO START!'
                        byte 0

descText
      text 'A GAME BY ELLIOTT WHEAT'
                        byte 0

gameDescText
      text 'Collect 10 coins to win!'
                        byte 0

MENU_LOOP
        ; Wait for scanline 255
        LIBSCREEN_WAIT_V 255
        jsr libInputUpdate
      
        LIBSCREEN_DRAWTEXT_AAAV flowStartX, flowStartY, flowStartText, White
        
        LIBSCREEN_DRAWTEXT_AAAV descX, descY, descText, White

        LIBSCREEN_DRAWTEXT_AAAV gameDescX, gameDescY, gameDescText, White

         

        LIBINPUT_GETHELD GameportFireMask
        beq MENU_END
        jmp MENU_LOOP
        

MENU_START
        jsr CLEAR
        LIBSPRITE_ENABLE_AV             playerSprite, False
        LIBSPRITE_ENABLE_AV             rivalSprite, True
        LIBSPRITE_SETFRAME_AV rivalSprite,1
        jmp MENU_LOOP

MENU_END
        LIBSPRITE_ENABLE_AV             playerSprite, True
        LIBSPRITE_ENABLE_AV             rivalSprite, True
        jmp GAMELOOP