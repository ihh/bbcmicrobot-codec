;; The Susceptible-Infected-Recovered model from epidemiology

INIT_TYPE = 3
INIT_COUNT = 0			; i.e. 256

DELAY = 0
	
START:	
	INCLUDE "cursor.asm"
	INCLUDE "cls.asm"
	INCLUDE "typedinit.asm"
	lda #1
	jsr WRITE
	INCLUDE "delay.asm"
	INCLUDE "reaction-diffusion.asm"

VDU_INIT_LEN = 3
VDU_INIT:
	byte 132,157,131
	
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
	hex 84 55 99 55		; reactions for source=infected,    target=(empty,infected,recovered,susceptible)
	hex 88 99 aa bb		; reactions for source=recovered,   target=(empty,infected,recovered,susceptible)
	hex cc 55 ee ff		; reactions for source=susceptible, target=(empty,infected,recovered,susceptible)
RATE:	hex 10 10 10 10		; rates for alternate (upper-nybble) reactions for source=(empty,infected,recovered,susceptible)
CHARS:	byte " IRS"		; lower 2 bits must be 00, 01, 10, 11
