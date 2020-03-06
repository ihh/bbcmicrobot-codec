MAIN:	jsr $af87
	jsr COUNT
	ldx $0d
	ldy $0e
	jsr XY
	lda ($70,X)
	dex
	ldy $72
	cmp #33
	bcc SPACE
	inx
	lda #8
	sbc $72
	tay
SPACE:	stx $75
	lda PROBS,Y
	cmp $0f
	bcs MAIN
	tya
	adc #48
	and $75
	ldx #0
	sta ($70,X)
	jmp MAIN
XY:	pha
	txa
	and #15
	asl
	tax
	tya
	and #31
	adc $c3b6,X
	sta $70
	lda $c3b5,X
	adc #$7c
	sta $71
	pla
	ldx #0
	rts
COUNT:	lda #0
	sta $72
	ldx $0D
	ldy $0E
	dex
	jsr TEST
	iny
	jsr TEST
	iny
	jsr TEST
	inx
	jsr TEST
	inx
	jsr TEST
	dey
	jsr TEST
	dey
	jsr D
D:	dex
TEST:	stx $74
	jsr XY
	lda ($70,X)
	cmp #33
	bcc EMPTY
	inc $72
EMPTY:	ldx $74
	rts
PROBS:	byte 216,184,156,133   	; 255*(0.8^N) for N=1..4
