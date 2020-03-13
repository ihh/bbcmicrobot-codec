;; General engine for reaction-diffusion models
;; Including file must define the following:
;; CHARS - a four-byte array of characters
;; RATE - a four-byte array of 255 * (probability of using alternate reaction), indexed by source state
;; REACT - a 16-byte array of reactions.
;;  If source cell is SRC and target cell is TARG, then byte (SRC*4+TARG) specifies the new states, as follows:
;; Bits (0,1) = new state of source cell, (2,3) = new state of target cell
;; ...or, with probability (UpperNybbleProb/255)...
;; Bits (4,5) = new state of source cell, (6,7) = new state of target cell

INVCHARS = $6000		; inverse CHARS lookup
	
	ldx #3
INITLOOKUP:
	ldy CHARS,x
	txa
	sta INVCHARS,y
	dex
	bpl INITLOOKUP

RDLOOP:
	jsr RNDCELL
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
	ldx #2
	jsr READ
	lsr
	php
	lsr
	ldx #0
	jsr READ
	tax
	rol
	plp
	rol
	tay
	lda REACT,y
	ldy RATE,x
	cpy $10
	bcc LOWER
	lsr
	lsr
	lsr
	lsr
LOWER:	pha
	ldx #0
	jsr WRITE
	pla
	lsr
	lsr
	ldx #2
	jsr WRITE		; clears Z
	bne RDLOOP
READ:	lda ($70,x)
	tay
	lda INVCHARS,y
	rts
WRITE:	and #3
	tay
	lda CHARS,y
	sta ($70,x)
	rts
RNDCELL:
	jsr $af87
	ldx $0d
	ldy $0e
	jsr GETADDR
	sty $70
	sta $71
	lda $0f
	rts
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
