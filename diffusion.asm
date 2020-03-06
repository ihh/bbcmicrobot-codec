m:
 jsr $af87
 ldx $d
 ldy $e
 jsr c
 sty $70
 sta $71
 ldx $d
 ldy $e
 lda $f
 asl
 bcc notx
 dex 
 asl
 bcc done
 inx 
 inx
 bcs done
notx:
 dey 
 asl
 bcc done
 iny 
 iny 
done:
 jsr c
 sty $72
 sta $73
 ldx #0
 lda ($70,x)
 pha 
 lda ($72,x)
 sta ($70,x)
 pla 
 sta ($72,x)
 bne m
c:
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
