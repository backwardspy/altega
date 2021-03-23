//-page 0-----------------------------------------------------------------------
.label TMP = $0002   // AVAILABLE: 1 byte

.label NDX = $00C6      // number of characters in keyboard buffer

.label VEC0 = $00FB  // AVAILABLE: 1 vector or 2 bytes
.label VEC1 = $00FD  // AVAILABLE: 1 vector or 2 bytes

//-page 2-----------------------------------------------------------------------
.label KEYD = $0277   // keyboard buffer of size 10

//------------------------------------------------------------------------------
.label SCREEN_BASE = $0400

//-I/O registers----------------------------------------------------------------
.namespace vic {
    .label BORDER_COLOUR = $D020
    .label BACKGROUND_COLOUR = $D021
}

.namespace sid {
    .label VOICE3_FREQ = $D40E
    .label VOICE3_CONTROL = $D412
    .label OSC_VOICE3 = $D41B
}

.label COLOUR_BASE = $D800

//------------------------------------------------------------------------------
* = $0801 "Basic Loader"
BasicUpstart(entrypoint)

//------------------------------------------------------------------------------
* = $1000 "Code"
#import "src/memory.asm"
#import "src/screen.asm"
#import "src/extensions.asm"
#import "src/input.asm"
#import "src/random.asm"
#import "src/game.asm"
#import "src/entrypoint.asm"

//------------------------------------------------------------------------------
* = $2000 "Data"
#import "data/strings.asm"
