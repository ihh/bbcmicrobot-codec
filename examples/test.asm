	JSR stars
	LDA #"O"
	JSR $FFEE
	LDA #"K"
	JSR $FFEE
stars:	LDA #42
	JSR $FFEE
	JMP $FFEE
