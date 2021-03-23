#importonce

.filenamespace game

.const RETURN = $0D
.const DELETE = $14

.const HEADER_ROW = 0
.const STATUS_ROW = 12
.const PROMPT_ROW = 15

secret_number: .byte 0

guess_buffer: .fill 2, 0
guess_buffer_len: .byte 0
.const guess_buffer_max_len = 2

// theme is randomly chosen based on the bottom three bits of secret (pro tip!)
theme_table:
    .byte YELLOW, BLUE
    .byte LIGHT_BLUE, WHITE
    .byte WHITE, GREEN
    .byte YELLOW, RED
    .byte PURPLE, BLACK
    .byte CYAN, DARK_GREY
    .byte LIGHT_GREEN, GREY
    .byte LIGHT_RED, RED

init: {
    jsr random.init

    // sets theme #0 as a default as we've not picked a secret yet
    jsr set_theme

    print(0, HEADER_ROW, strings.header)

    // seed the HRNG (human random number generator)
    print(0, STATUS_ROW, strings.press_return_to_begin)
    !:  jsr input.read_key
        cmp #RETURN
        bne !-

    jsr pick_secret

    print(0, STATUS_ROW, strings.awaiting_guess)
    print(0, PROMPT_ROW, strings.prompt)

    rts
}

main_loop: {
    jsr input.read_key
    jsr handle_key

    jmp main_loop

    rts
}

pick_secret: {
    find_less_than_100:
        rnd()
        and #%01111111  // mask down to 0-127 for better chances
        cmp #100
        bcs find_less_than_100
    sta secret_number
    jsr set_theme
    rts
}

// sets background, border, and text colour based on secret number
set_theme: {
    // convert secret number to table index
    lda secret_number
    and #%00000111
    asl
    tax

    // set background colour
    mov theme_table+1,x : vic.BACKGROUND_COLOUR

    // set border & text colour
    // the bottom few rows aren't coloured as we never write to them anyway
    mov16 #COLOUR_BASE : VEC0
    mov theme_table,x : vic.BORDER_COLOUR
    jsr memset256   // bytes $0000-$00FF
    inc VEC0+1
    jsr memset256   // bytes $0100-$01FF
    inc VEC0+1
    jsr memset256   // bytes $0200-$02FF

    rts
}

// expects a petscii key code in AC
handle_key: {
    cmp #RETURN; bne !+
        jsr handle_return
        rts

!:  cmp #DELETE; bne !+
        jsr handle_delete
        rts

!:  cmp #'0';   bcc !+
    cmp #'9'+1; bcs !+
        jsr handle_digit

!:  rts
}

calculate_guess_value: {
    // multiply first digit by 10
    lda guess_buffer
    asl; sta TMP        // AC *= 2 (-> TMP)
    asl; asl            // AC *= 8
    clc; adc TMP        // AC = x*8 + x*2 = x * 10
    
    // add second digit
    clc; adc guess_buffer+1

    rts
}

handle_return: {
    // put guess onto stack
    jsr calculate_guess_value; pha
    
    // clear the guess buffer & screen
    ldx #guess_buffer_max_len
    loop:
        dex
        mov #0 : guess_buffer,x
        mov #' ' : locate(strings.prompt_len, PROMPT_ROW),x
        cpx #0
        bne loop
    stx guess_buffer_len

    // retrieve guess & compare with secret
    pla
    cmp secret_number
    beq guess_correct
    bcs guess_too_high
    bcc guess_too_low

    guess_correct: {
        jsr pick_secret
        print(0, STATUS_ROW, strings.guess_correct)
        rts
    }

    guess_too_high: {
        print(0, STATUS_ROW, strings.guess_too_high)
        rts
    }

    guess_too_low: {
        print(0, STATUS_ROW, strings.guess_too_low)
        rts
    }
}

handle_delete: {
    ldx guess_buffer_len
    beq return  // return if guess buffer is empty

    // overwrite buffer head with 0 and screen with ' '
    dex
    mov #0 : guess_buffer,x
    mov #' ' : locate(strings.prompt_len, PROMPT_ROW),x
    stx guess_buffer_len

    return: rts
}

handle_digit: {
    // push digit to screen & buffer
    ldx guess_buffer_len

    // return if the guess buffer is full
    cpx #guess_buffer_max_len; bcs return

    // push to screen
    sta locate(strings.prompt_len, PROMPT_ROW),x

    // convert to numeric value and add to guess buffer
    and #$0F
    sta guess_buffer,x
    inx
    stx guess_buffer_len
    
    return: rts
}
