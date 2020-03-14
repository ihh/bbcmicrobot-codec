;; Delay loop
	
DELAY:
	lda $295
	cmp #11
	bcc DELAY
