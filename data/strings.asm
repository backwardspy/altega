#importonce

.filenamespace strings

header:
.text "                                        "
.text " UCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCI "
.text " B                                    B "
.text " B            a l t e g a             B "
.text " B                                    B "
.text " JCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCK "
.text "                                        "
.text "                                        "
.text " i've picked a number between 0 and 99  "
.text " let's see how quickly you can guess it "
.label header_len = * - header
.byte 0

press_return_to_begin:
.text "       S press return to begin S        "
.text "                                        "
.byte 0

awaiting_guess:
.text "awaiting your guess...                  "
.text "                                        "
.byte 0

guess_correct:
.text "correct! well done. i've picked another "
.text "number between 0 and 99. again!         "
.byte 0

guess_too_high:
.text "too high! try something lower...        "
.text "                                        "
.byte 0

guess_too_low:
.text "too low! try something higher...        "
.text "                                        "
.byte 0

prompt:
.text "   guess: "
.label prompt_len = * - prompt
.byte 0
