#importonce

.filenamespace input

// waits for the user to press a key and returns it in AC
read_key: {
    wait_for_key:   // loop until there's something in the buffer
        ldx NDX
        beq wait_for_key

    // pop a single key from the buffer and return
    dex
    stx NDX
    lda KEYD,x

    rts
}
