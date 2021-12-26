    processor 6502

    seg code
    org $F000   ; Define the code origin at $F000

Start:
    sei ; Disable interrupts
    cld ; Disable the BCD decimal math mode
    ldx #$FF ; Load the X register to $FF
    tsx ; Trasfer the X register to the stack pointer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the page zero region to ($00 to $FF)
; Meaning the entire RAM and also the entire TIA registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #0 ; A = 0
    ldx #$FF ; X = $FF
    sta $FF ; maker sure $FF is zeroed before the loop
MemLoop:
    dex ; Decrement the X register
    sta $0,X ; Store the value of A in the address $0 + X
    bne MemLoop ; Loop until X = 0 (z-flag is set)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill the ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

    org $FFFC ; Jump to the reset vector
    .word Start ; Reset vector at $FFFC  (where prpgram starts)
    .word Start ; Interrupt vector at $FFFE  (unused in VCS)

