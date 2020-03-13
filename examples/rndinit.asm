;; Random initialization for reaction-diffusion.asm

;; Including file must define the following:
;; INITCOUNT - number of initial random characters

	lda #INIT_COUNT
	sta $74
RNDINIT:
	jsr RNDCELL
	ldx #0
	jsr WRITE
	dec $74
	bne RNDINIT

