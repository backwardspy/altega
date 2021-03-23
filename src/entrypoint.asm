entrypoint: {
    jsr game.init
    jsr game.main_loop
    rts
}
