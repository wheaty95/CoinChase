;==============================================================================
; Constants

PlayerFrame             = 4
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

playerSprite    byte 0
playerXHigh     byte 0
playerXLow      byte 175
PlayerY         byte 229

;===============================================================================
; Macros/Subroutines

gamePlayerInit
        
        LIBSPRITE_ENABLE_AV             playerSprite, True
        LIBSPRITE_SETFRAME_AV           playerSprite, PlayerFrame
        LIBSPRITE_SETCOLOR_AV           playerSprite, Cyan
        LIBSPRITE_PLAYANIM_AVVVV playerSprite,13,13,1,TRUE
        rts

;===============================================================================

gamePlayerUpdate      

        jsr gamePlayerUpdatePosition

        rts

;===============================================================================

gamePlayerUpdatePosition

        LIBINPUT_GETHELD GameportLeftMask
        bne gPUPRight
        LIBMATH_SUB16BIT_AAVVAA playerXHigh, PlayerXLow, 0, PlayerHorizontalSpeed, playerXHigh, PlayerXLow
gPUPRight
        LIBINPUT_GETHELD GameportRightMask
        bne gPUPUp
        LIBMATH_ADD16BIT_AAVVAA playerXHigh, PlayerXLow, 0, PlayerHorizontalSpeed, playerXHigh, PlayerXLow
gPUPUp
        LIBINPUT_GETHELD GameportUpMask
        bne gPUPDown
        LIBMATH_SUB8BIT_AVA PlayerY, PlayerVerticalSpeed, PlayerY
gPUPDown
        LIBINPUT_GETHELD GameportDownMask
        bne gPUPEndmove
        LIBMATH_ADD8BIT_AVA PlayerY, PlayerVerticalSpeed, PlayerY        
gPUPEndmove

        ; clamp the player x position
        LIBMATH_MIN16BIT_AAVV playerXHigh, playerXLow, PlayerXMaxHigh, PlayerXMaxLow
        LIBMATH_MAX16BIT_AAVV playerXHigh, playerXLow, PlayerXMinHigh, PlayerXMinLow
        
        ; clamp the player y position
        LIBMATH_MIN8BIT_AV playerY, PlayerYMax
        LIBMATH_MAX8BIT_AV playerY, PlayerYMin

        ; set the sprite position
        LIBSPRITE_SETPOSITION_AAAA playerSprite, playerXHigh, PlayerXLow, PlayerY

        rts

