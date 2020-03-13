	;; Clears MODE 7 screen
	;; VDU_INIT is an array of VDU_INIT_LEN bytes to be written to each line

	lda #12
	ldx #24
ROW_VDU_START:
	jsr $ffe3
	ldy #-VDU_INIT_LEN
ROW_VDU:
	lda VDU_INIT-256+VDU_INIT_LEN,y
	jsr $ffe3
	iny
	bne ROW_VDU
	lda #13
	dex
	bne ROW_VDU_START
