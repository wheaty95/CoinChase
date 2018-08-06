frame_count = 8                               ; constant for the nbr of sprite frames you have
frame_counter = $8011           ; variable to keep track of how far through the animation we are
dataPointer = 128               ; sprite data will be read by VIC-II at 128*64 ($2000)

RenderEnemyAnim
        dec frame_counter                      ;  frame_counter variable -= 1
        bne increment_sprite_pointer           ; if frame_counter > 0, goto .increment_sprite_pointer...
        
        lda #dataPointer        ; ... otherwise, we should reset to the start of the animation
        sta $07f9                               ; reset the sprite pointer to start of sprite data
        ldx #frame_count               
        stx frame_counter
        rts     
                                ; return
increment_sprite_pointer
        inc $07f9                               ; sprite pointer += 1 (moves to the next frame)
        rts 

INIT_SPRITES
        lda #frame_count
        sta frame_counter
        rts