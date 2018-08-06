; Constants

RivalFrame             = 4
PlayerHorizontalSpeed   = 5
PlayerVerticalSpeed     = 5
PlayerXMinHigh          = 0     ; 0*256 + 24 = 24  minX
PlayerXMinLow           = 24
PlayerXMaxHigh          = 1     ; 1*256 + 64 = 320 maxX
PlayerXMaxLow           = 64
PlayerYMin              = 60
PlayerYMax              = 229 

;===============================================================================
; Variables

rivalSprite    byte 1
rivalXHigh     byte 0
rivalXLow      byte 160
rivalY         byte 100

;===============================================================================
; Macros/Subroutines

gameEnemyInit
        
        LIBSPRITE_ENABLE_AV             rivalSprite, True
        LIBSPRITE_SETFRAME_AV           rivalSprite, RivalFrame
        LIBSPRITE_SETCOLOR_AV           rivalSprite, Yellow
        LIBSPRITE_PLAYANIM_AVVVV rivalSprite,0,12,1,TRUE
        LIBSPRITE_SETPOSITION_AAAA rivalSprite, rivalXHigh, rivalXLow, rivalY
        rts

enemyCollision
        jsr AssignRandomValueIntoLDA 
        sta rivalXLow    

        ; clamp the player x position
        LIBMATH_MIN16BIT_AAVV rivalXHigh, rivalXLow, PlayerXMaxHigh, PlayerXMaxLow
        LIBMATH_MAX16BIT_AAVV rivalXHigh, rivalXLow, PlayerXMinHigh, PlayerXMinLow

        jsr AssignRandomValueIntoLDA 
        sta rivalY 

        ;y pos
        LIBMATH_MIN8BIT_AV rivalY, PlayerYMax
        LIBMATH_MAX8BIT_AV rivalY, PlayerYMin

        LIBSPRITE_SETPOSITION_AAAA rivalSprite, rivalXHigh, rivalXLow, rivalY

    
        




        jsr INCREASE_SCORE
        rts



