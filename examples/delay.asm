;; Delay loop which zeroes the accumulator
	
DELAY:
	lda $295
	cmp #11
	bcc DELAY
