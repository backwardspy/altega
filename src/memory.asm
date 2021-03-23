// copies bytes from input to output until a null byte is encountered
// expects:
//  the input pointer to be in VEC0
//  the output pointer to be in VEC1
memcpy0: {
    ldy #0
    loop:
        lda (VEC0),y
        beq return // stop when null byte is found
        
        sta (VEC1),y

        iny
        bne loop    // loop if YR hasn't wrapped around

        // YR has wrapped, we need to shift input/output by 256
        inc VEC0+1
        inc VEC1+1
        jmp loop

    return: rts
}

// overwrites 256 bytes of memory with AC
// expects the output pointer to be in VEC0
memset256: {
    ldy #0
    loop:
        sta (VEC0),y
        dey
        bne loop    // loop until YR wraps

    rts
}
