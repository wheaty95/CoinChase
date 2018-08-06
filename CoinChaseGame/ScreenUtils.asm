;////////////////////////////
;util functions

BORDER = $d020 
SCREEN = $d021 

flowStartX      byte 0
flowStartY      byte 0

scoreX      byte 7
scoreY      byte 0

flowStartText
      text 'Coins:'
                        byte 0
randomBGColour
        inc SCREEN ; increase screen colour 
        inc BORDER ; increase border colour 
        rts

RENDER_SCORE_TEXT
        LIBSCREEN_DRAWTEXT_AAAV flowStartX, flowStartY, flowStartText, White
        rts

RENDER_SCORE
        LIBSCREEN_DRAWDECIMAL_AAAV scoreX, scoreY, score, White
        rts