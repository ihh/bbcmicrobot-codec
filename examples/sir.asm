;; The Susceptible-Infected-Recovered model from epidemiology

BASIC_INIT = "CLS"
	
START:	lda #1
	tax
INIT:	sta $7c00,x
	lda #3
	inx
	bne INIT
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
	ldy $10
	bne LOWER
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

;; 0 = empty, 1 = infected, 2 = recovered, 3 = susceptible

;; Bits (0,1) = new state of source cell, (2,3) = new state of target cell
;; ...or, with probability (1/256)...
;; Bits (4,5) = new state of source cell, (6,7) = new state of target cell

;; Nybble meanings:
;;   Src Target
;; 0  E   E
;; 1  I   E
;; 2  R   E
;; 3  S   E
;; 4  E   I
;; 5  I   I
;; 6  R   I
;; 7  S   I
;; 8  E   R
;; 9  I   R
;; a  R   R
;; b  S   R
;; c  E   S
;; d  I   S
;; e  R   S
;; f  S   S

REACT:	hex 00 11 22 33		; reactions for source=empty,       target=(empty,infected,recovered,susceptible)
	hex 24 55 99 55		; reactions for source=infected,    target=(empty,infected,recovered,susceptible)
	hex 38 99 aa bb		; reactions for source=recovered,   target=(empty,infected,recovered,susceptible)
	hex cc 55 ee ff		; reactions for source=susceptible, target=(empty,infected,recovered,susceptible)
CHARS:	byte " IRS"		; lower 2 bits must be 00, 01, 10, 11
