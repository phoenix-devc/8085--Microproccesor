;CHECKWIN FUNCTION IMPLEMENTATION (8085)
;-----------------------------------------------------------------------
;BOARD STATE IS 9 BYTES LOCATED BY PTR "BOARD" (2BYTE PTRS) 
;TERMS:
;00H -> UNUSED
;01H -> X
;FFH -> 0
;-----------------------------------------------------------------------
;The H-L Register pair must be set to "BOARD"
;The Checkwin function will evaluate the board pointed by "BOARD"
;using the table of winning combinations (pointed by "WINLIST"). 
;The table has offsets stored in running sum form.
;The function after evaluation stores the following in the Accumulator:
;00H -> No one wins
;01H -> X wins
;FFH -> 0 wins
;-----------------------------------------------------------------------
;LOCATIONS:
CODE	.EQU 0000H
;CODE:
	.ORG CODE
	LXI SP,0000H ;STACK INITIALISATION
	LXI H,BOARD   ;BOARD HAS TO BE LOADED IN THE HL PAIR BEFORE CALLING CWIN
	CALL CWIN
	HLT
;FUNCTIONS:
CWIN:	LXI D,WINLIST
	MVI A,08H
	DCR E
CLOOP:	PUSH PSW
	XRA A
	INX D
	PUSH H
	MVI B,00H
	XCHG
	MOV C,M
	XCHG
	DAD B
	ADD M
	XCHG
	INX H
	MOV C,M
	XCHG
	DAD B
	ADD M
	XCHG
	INX H
	MOV C,M
	XCHG
	DAD B
	ADD M
	POP H ;RESTORING HL
	CPI 0FDH
	JZ WINO
	CPI 03H
	JZ WINX
	POP PSW ;RESTORING A	
	DCR A
	JNZ CLOOP	
	MVI A,00H
	RET
WINO:	POP PSW ;BALANCING THE STACK
	MVI A,0FFH
	RET
WINX:	POP PSW ;BALANCING THE STACK
	MVI A,01H
	RET
;CONVERSION TABLE:
WINLIST:	.DB 00H,01H,01H
		.DB 03H,01H,01H
		.DB 06H,01H,01H
		.DB 00H,03H,03H
		.DB 01H,03H,03H
		.DB 02H,03H,03H
		.DB 00H,04H,04H
		.DB 02H,02H,02H
;BOARD STATE:
BOARD:		.DB 0FFH,0FFH,01H
		.DB 00H,0FFH,0FFH
		.DB 01H,0FFH,01H