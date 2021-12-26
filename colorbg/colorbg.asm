	processor 6502
	include "vcs.h"
	include "macro.h"

	seg code
	org $F000	; defines the origin of the ROM at $F000

START:
	; CLEAN_START	; Macro to safely clear the memory registers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the background luminosity color to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lda #$1E	; Load color into A ($1E = yellow NTSC)
	sta COLUBK	; Store color in background luminosity address $09

	jmp START	; Repeat from START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fill ROM Size to 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFFC	; Defines the origin of the ROM at $FFFC
	.word START	; Reset vector at $FFFC (where the program starts)
	.word START	; Intrrupt vector at $FFFE (unused)
	

	
