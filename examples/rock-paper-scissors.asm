;; A Lotka-Volterra style reaction-diffusion model with three mutually repressing agents:
;;  "rock" (R), "paper" (P), and "scissors" (S)

INIT_COUNT = 100

START:	
	INCLUDE "cls.asm"
	INCLUDE "cursor.asm"
	INCLUDE "rndinit.asm"
	INCLUDE "reaction-diffusion.asm"

VDU_INIT_LEN = 3
VDU_INIT:
	byte 129,157,135
	
	
;; 0 = empty, 1 = rock, 2 = paper, 3 = scissors
;; Bits (0,1) = new state of source cell, (2,3) = new state of target cell
;; ...or, with probability RATE[source]...
;; Bits (4,5) = new state of source cell, (6,7) = new state of target cell

REACT:	hex 00 54 a8 fc		; reactions for source=empty,    target=(empty,rock,paper,scissors)
	hex 04 15 22 55		; reactions for source=rock,     target=(empty,rock,paper,scissors)
	hex 08 aa 2a 33		; reactions for source=paper,    target=(empty,rock,paper,scissors)
	hex 0c 11 ff 3f		; reactions for source=scissors, target=(empty,rock,paper,scissors)
RATE:	hex 08 08 08 08		; rates for alternate (upper-nybble) reactions for source=(empty,rock,paper,scissors)
CHARS:	byte " RPS"		; lower 2 bits must be 00, 01, 10, 11

