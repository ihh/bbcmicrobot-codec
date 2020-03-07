MAIN:	jsr $af87		; calls BASIC RND subroutine, which puts random bits in bytes $0D..$10 of zero page
	jsr COUNT
	lda $0d
	ldy $0e
	jsr LOOKUP		; on returning from the LOOKUP subroutine, X is zero
	lda ($70,X)		; A is the old state of the cell
	dex			; X is the mask for the new value we'll store in the cell. It's now 0xFF, presuming we're going to set the cell to nonempty
	ldy $72			; Y is the "nonempty neighbor count"
	cmp #33			; test if the central cell is nonempty (contains a digit). If we take the branch, the cell is currently empty
	bcc SPACE
	inx			; the cell is currently nonempty, so set the mask to 0, because the new state (if we flip it) will be empty
	lda #8			; subtract the "nonempty neighbor" count from 8 to get the "empty neighbor" count
	sbc $72
	tay
SPACE:	stx $75
	lda PROBS,Y		; look up the probability of rejecting a flip, given the number of non-identical neighbors
	cmp $0f
	bcs MAIN
	tya
	adc #48			; if we're setting the cell to nonempty, have it show a digit representing nonempty neighbor count (originally for debugging, but kind of fun)
	and $75
	ldx #0
	sta ($70,X)
	jmp MAIN
LOOKUP:	and #15			; points ($70) to cell indexed by (Y,A), clears X, corrupts A, preserves Y
	asl
	tax
	tya
	and #31
	adc $c3b6,X		; look up the address of this cell using the *40 multiplication table at $c3b5
	sta $70
	lda $c3b5,X
	adc #$7c
	sta $71
	ldx #0
	rts
COUNT:	lda #0			; counts nonempty cells in Moore neighborhood of cell at ($E,$D), returns value in $72
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
TEST:	txa			; tests if cell at (Y,X) is nonempty; if so, increments $72. Preserves X & Y
	pha
	jsr LOOKUP
	lda ($70,X)
	cmp #33			; a cell is empty if it contains a space character
	bcc EMPTY
	inc $72
EMPTY:	pla
	tax
	rts
PROBS:	byte 239,223,191,127   	; 255*(1-0.5^N) for N=4,3,2,1
