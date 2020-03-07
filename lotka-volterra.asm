SYMLOOKUP = $2000
	
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
	cmp $10  		; with a 1 in 256 chance, use the upper nybble
	bne NORMAL
	lsr
	lsr
	lsr
	lsr
NORMAL:	pha
	and #3
	beq SPC1
	ora #64
SPC1:	sta ($70,x)
	pla
	lsr
	lsr
	and #3
	beq SPC2
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
	;; 0 = space, 1 = rock, 2 = paper, 3 = scissors
REACT:	byte 0,4,8,12  		; reactions for space
	byte 4,5,2,5		; reactions for rock
	byte 8,10,10,3		; reactions for paper
	byte 12,1,15,15		; reactions for scissors
