;; A Lotka-Volterra style reaction-diffusion model with three mutually repressing agents:
;;  "rock" (A), "paper" (B), and "scissors" (C)
	
	INCLUDE "reaction-diffusion.asm"

UpperNybbleProb = 8		; probability of using alternate reaction for a source-target pair, stored in upper nybble

;; 0 = empty, 1 = rock, 2 = paper, 3 = scissors
;; Bits (0,1) = new state of source cell, (2,3) = new state of target cell
;; ...or, with probability (UpperNybbleProb/256)...
;; Bits (4,5) = new state of source cell, (6,7) = new state of target cell

REACT:	hex 00 54 a8 fc		; reactions for source=empty,    target=(empty,rock,paper,scissors)
	hex 04 15 22 55		; reactions for source=rock,     target=(empty,rock,paper,scissors)
	hex 08 aa 2a 33		; reactions for source=paper,    target=(empty,rock,paper,scissors)
	hex 0c 11 ff 3f		; reactions for source=scissors, target=(empty,rock,paper,scissors)
CHARS:	byte " ABC"		; lower 2 bits must be 00, 01, 10, 11

