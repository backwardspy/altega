// uses SID voice #3 with a noise waveform to generate random bytes
#importonce

.filenamespace random

.label byte = sid.OSC_VOICE3

init: {
    // set maximum frequency
    lda #$FF
    sta sid.VOICE3_FREQ+0
    sta sid.VOICE3_FREQ+1

    // noise waveform, gate off
    mov #$80 : sid.VOICE3_CONTROL

    rts
}

.macro @rnd() {
    lda sid.OSC_VOICE3
}
