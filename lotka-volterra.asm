UpperNybbleProb = 8
	
LOOP:
	jsr $af87
	ldx $0d
	ldy $0e
	jsr GETADDR
	sty $70
	sta $71
	lda $0f
	and #3
	tay
	lda DIRS,y
	sta MOVE
	ldx $0d
	ldy $0e
MOVE:	nop
	jsr GETADDR
	sty $72
	sta $73
	ldx #0
	lda ($72,x)
	lsr
	php
	lsr
	lda ($70,x)
	and #3
	rol
	plp
	rol
	tay
	lda REACT,y
	ldy #UpperNybbleProb
	cpy $10
	bcc LOWER
	lsr
	lsr
	lsr
	lsr
LOWER:	pha
	and #3
	tay
	lda CHARS,y
	sta ($70,x)
	pla
	and #12
	lsr
	lsr
	tay
	lda CHARS,y
	sta ($72,x)
	bcc LOOP
GETADDR:
	txa 
	and #15
	asl
	tax 
	tya 
	and #31
	adc $c3b6,x
	tay 
	lda $c3b5,x
	adc #$7c
	rts
DIRS:	dex
	inx
	dey
	iny
	;; 0 = empty, 1 = rock, 2 = paper, 3 = scissors
	;; Bits (0,1) = new state of source cell, (2,3) = new state of target cell
	;; ...or, with probability (UPPER_NYBBLE_PROB/256)...
	;; Bits (4,5) = new state of source cell, (6,7) = new state of target cell
REACT:	hex 00 54 a8 fc		; reactions for source=empty,    target=(empty,rock,paper,scissors)
	hex 04 15 22 55		; reactions for source=rock,     target=(empty,rock,paper,scissors)
	hex 08 aa 2a 33		; reactions for source=paper,    target=(empty,rock,paper,scissors)
	hex 0c 11 ff 3f		; reactions for source=scissors, target=(empty,rock,paper,scissors)
CHARS:	byte " ABC"
