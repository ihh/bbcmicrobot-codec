;; Ornstein-Uhlenbeck process

BASIC_INIT = "MO.0:V.23,1;0;0;0;"

START:	lda #0
	sta $71			; Y
ORIG:	lda #12
	jsr $ffee
	lda #25
	jsr $ffee
	lda #4
	jsr $ffee
	lda #0
	sta $70			; X
	jsr XCOORD
	lda $71
	jsr YCOORD
LOOP:	jsr $af87
	lda #25
	jsr $ffee
	lda #5
	jsr $ffee
	lda $70
	jsr XCOORD
	lda $70
	and #31
	bne NODIV
	lda $71
	jsr DIV2
	sta $71
NODIV:	lda $0d
	jsr DIV16
	clc
	adc $71
	sta $71
	jsr YCOORD
	inc $70
	bne LOOP
	beq ORIG
DIV16:	jsr DIV4
DIV4:	jsr DIV2
DIV2:	cmp #$80
	ror
	rts
MUL4:	stx $72
	asl
	rol $72
	asl
	rol $72
	rts
XCOORD: ldx #0
	jsr MUL4
	jsr $ffee
	lda $72
	jmp $ffee
YCOORD: ldx #0
	cmp #$80
	bcc POS
	dex
POS:	jsr MUL4
	jsr $ffee
	lda $72
	clc
	adc #2
	jmp $ffee
