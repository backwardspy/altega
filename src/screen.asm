#importonce

.function locate(x, y) {
    .return $0400 + x + y * 40
}

.macro print(x, y, string) {
    .var loc = locate(x, y)
    mov16 #string : VEC0
    mov16 #loc : VEC1
    jsr memcpy0
}
