    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000

Start:
    CLEAN_START ; macro to clear TIA and memory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start a new frame by turning on VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NextFrame:
    lda #2  ; Same as binary %0000 0010
    sta VBLANK ; Turn on VBLANK
    sta VSYNC  ; Turn on VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate 3 Line of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    sta WSYNC   ; first scanline
    sta WSYNC   ; second scanline
    sta WSYNC   ; thrid scanline

    lda #0
    sta VSYNC   ; turn off vsync

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Let the TIA output the recommended 37 scanlines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldx #37         ; X = 37 ( to count 37 scanline)
LoopVBlank:
    sta WSYNC       ; output a scanline
    dex             ; decrement X
    bne LoopVBlank  ; loop if X != 0

    lda #0          ; clear VBLANK
    sta VBLANK      ; turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 192 visible scanlines (kernel)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #192    ; counter for 192 visible scanlines
LoopScanline:
    stx COLUBK   ; store background color
    sta WSYNC    ; wait for the next scanline
    dex          ; decrement X
    bne LoopScanline ; loop if X != 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Output 30 more VBLANK scanlines (overscan) to completye our frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #2  ; Hit and turn on VBLANK
    sta VBLANK  ; Turn on VBLANK
    ldx #30   ; X = 30 ( to count 30 scanline)
LoopOverscan:
    sta WSYNC   ; wait for next scanline
    dex          ; decrement X
    bne LoopOverscan ; loop if X != 0

    jmp NextFrame ; jump to the next frame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete ROM size to 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC ; ROM size
    .word Start
    .word Start


