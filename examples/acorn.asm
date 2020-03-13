	ldx #0
LOOP:	lda DATA,x
	beq LOOP
	jsr $ffee
	inx
	jmp LOOP
DATA:	byte 12,10,10,13
	byte "acorn computer"
	byte 10,10,10,13
	byte ">MICRO HUMANS RULE!"
	byte 0

