;; General engine for reaction-diffusion models
;; Including file must define the following:
;; UpperNybbleProb - a symbol equal to 255 * (probability of using alternate reaction)
;; CHARS - a four-byte array of characters, where the character at position N must have bits 0-1 equal to N (e.g. " ABC")
;; REACT - a 16-byte array of reactions.
;;  If source cell is SRC and target cell is TARG, then byte (SRC*4+TARG) specifies the new states, as follows:
;; Bits (0,1) = new state of source cell, (2,3) = new state of target cell
;; ...or, with probability (UpperNybbleProb/255)...
;; Bits (4,5) = new state of source cell, (6,7) = new state of target cell

RDLOOP:
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
	sta NBR
	ldx $0d
	ldy $0e
NBR:	nop
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
	bcc RDLOOP
GETADDR:
	txa 
	and #15
	asl			; clears C
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
