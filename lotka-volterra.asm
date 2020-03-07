UPPER_NYBBLE_PROB = 32		; probability of using upper nybble
	
LOOP:
	jsr $af87
	ldx $d
	ldy $e
	jsr GETADDR
	sty $70
	sta $71
	ldx $d
	ldy $e
	lda $f
	bpl NOTX
	dex 
	lsr
	bcc DONE
	inx 
	inx
	bcs DONE
NOTX:
	dey 
	lsr
	bcc DONE
	iny 
	iny 
DONE:
	jsr GETADDR
	sty $72
	sta $73
	ldx #0
	lda ($72,x)
	lsr
	php
	lsr
	lda ($70,x)
	rol
	plp
	rol
	tay
	lda REACT,y
	ldy $10
	cpy #UPPER_NYBBLE_PROB
	bcs LOWER
	lsr
	lsr
	lsr
	lsr
LOWER:	pha
	and #3
	beq SPC1
	ora #64
SPC1:	sta ($70,x)
	pla
	and #12
	beq SPC2
	lsr
	lsr
	ora #64
SPC2:	sta ($72,x)
	bpl LOOP
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
	;; 0 = empty, 1 = rock, 2 = paper, 3 = scissors
	;; Bits (0,1) = new state of source cell, (2,3) = new state of target cell
	;; ...or, with probability (UPPER_NYBBLE_PROB/256)...
	;; Bits (4,5) = new state of source cell, (6,7) = new state of target cell
REACT:	hex 00 54 a8 fc		; reactions for source=empty,    target=(empty,rock,paper,scissors)
	hex 04 55 22 55		; reactions for source=rock,     target=(empty,rock,paper,scissors)
	hex 08 aa aa 33		; reactions for source=paper,    target=(empty,rock,paper,scissors)
	hex 0c 11 ff ff		; reactions for source=scissors, target=(empty,rock,paper,scissors)
