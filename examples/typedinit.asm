;; Initialization for reaction-diffusion.asm with random locations but fixed types

;; Including file must define the following:
;; INIT_COUNT - number of initial randomly-placed characters
;; INIT_TYPE - type of initial randomly-placed characters

	lda #INIT_COUNT
	sta $74
RNDINIT:
	jsr RNDCELL
	ldx #0
	lda #INIT_TYPE
	jsr WRITE
	dec $74
	bne RNDINIT

