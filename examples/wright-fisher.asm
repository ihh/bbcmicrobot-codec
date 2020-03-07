BASES:
 byte "tgca"
INIT:
 lda #32
 sta $74
START:
 lda #13
 jsr $ffee
 lda #10
 jsr $ffee
 jsr $af87
 lda $0d
 and #31
 tay 
 ldx $50,y
 dec $74,x
 lda $0e
 and #31
 tax 
 lda $0f
 and #15
 cmp #4
 bcc STORE
 lda $50,x
STORE:
 sta $0050,y
 tax 
 inc $74,x
 ldy #4
CHAR: tya
 ora #128
 ldx $73,y
 inx 
ROW:
 jsr $ffee
 lda BASES-1,y
 dex 
 bne ROW
 dey 
 bne CHAR
 beq START
