MAIN:	jsr $af87		; calls RND subroutine, which puts random bits in 0xD..0x10
	jsr COUNT
	ldx $0d
	ldy $0e
	jsr XY
	lda ($70,X)
	dex
	ldy $72
	cmp #33			; if the cell is nonempty (contains a digit), subtract the count from 8
	bcc SPACE
	inx
	lda #8
	sbc $72
	tay
SPACE:	stx $75
	lda PROBS,Y		; look up the probability of a flip, given this many neighbors
	cmp $0f
	bcs MAIN
	tya
	adc #48
	and $75
	ldx #0
	sta ($70,X)
	jmp MAIN
XY:	pha			; points (&70) to cell indexed by (Y,X), clears X, preserves A & Y
	txa
	and #15
	asl
	tax
	tya
	and #31
	adc $c3b6,X		; look up the address of this cell using the *40 multiplication table at $c3b5
	sta $70
	lda $c3b5,X
	adc #$7c
	sta $71
	pla
	ldx #0
	rts
COUNT:	lda #0			; counts nonempty cells in Moore neighborhood of cell at (&E,&D), returns value in &72
	sta $72
	ldx $0D
	ldy $0E
	dex
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
	jsr TEST
	jsr D
D:	dex
TEST:	stx $74			; tests if cell at (Y,X) is nonempty; if so, increments &72. Preserves X & Y
	jsr XY
	lda ($70,X)
	cmp #33			; a cell is empty if it contains a space character
	bcc EMPTY
	inc $72
EMPTY:	ldx $74
	rts
PROBS:	byte 216,184,156,133   	; 255*(0.8^N) for N=1..4
