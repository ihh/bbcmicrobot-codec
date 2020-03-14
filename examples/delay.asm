;; Delay loop
	
DELAY_LOOP:
	lda $295
	cmp #DELAY
	bcc DELAY_LOOP
