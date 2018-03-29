.ORG 0000H
	JMP START

START:	LXI SP,0000H ;STACK INITIALISATION
	MVI A,38H; /LCD Function initialiser -> 2 lines
	CALL CMD
	MVI A,38H;- Double check(saw in previous codes)
	CALL CMD
	CALL DELAY; 47us DELAY
	MVI A,01H; /LCD clear command
	CALL CMD
	MVI A,0cH; /LCD display command
	CALL CMD
	MVI A,80H; /cursor position on display at start
	CALL CMD
	
	;/ now entring the codes to be displayed at initialisation "TIC TAC TOE"
	MVI A,54H; "T"/Ascii code for display data
	CALL DATA
	MVI A,49H; "I" 
	CALL DATA
	MVI A,43H; "C"
	CALL DATA
	MVI A,20H; " "
	CALL DATA
	MVI A,54H; "T" 
	CALL DATA
	MVI A,41H; "A"
	CALL DATA
	MVI A,43H; "C"
	CALL DATA
	MVI A,54H; "T" 
	CALL DATA
	MVI A,4FH; "O"
	CALL DATA
	MVI A,45H; "E"
	CALL DATA
	CALL MDELAY
	MVI A,01H; /LCD clear command
	CALL CMD
	MVI A,80H; /cursor position on display at start
	CALL CMD
	MVI A,0EH; /making the cursor blink
	CALL CMD
	;/ now entring the codes to be displayed at initialisation "LET'S PLAY"
	MVI A,4CH; "L"/Ascii code for display data
	CALL DATA
	MVI A,45H; "E" 
	CALL DATA
	MVI A,45H; "T" 
	CALL DATA
	MVI A,0B4H; " "
	CALL DATA
	MVI A,54H; "s" 
	CALL DATA
	MVI A,20H; " "
	CALL DATA
	MVI A,50H; "P"
	CALL DATA
	MVI A,4CH; "L" 
	CALL DATA
	MVI A,41H; "A"
	CALL DATA
	MVI A,59H; "Y"
	CALL DATA

	CALL MDELAY

P_OPT:	MVI A,01H; /LCD clear command
	CALL CMD
	MVI A,80H; /cursor position on display at start
	CALL CMD
	;/ "A. C v/s P"
	MVI A,41H; "A"/Ascii code for display data
	CALL DATA
	MVI A,2EH; "." 
	CALL DATA
	MVI A,20H; " "
	CALL DATA
	MVI A,43H; "C"
	CALL DATA
	MVI A,20H; " " 
	CALL DATA
	MVI A,76H; "v"
	CALL DATA
	MVI A,2FH; "/"
	CALL DATA
	MVI A,73H; "s" 
	CALL DATA
	MVI A,20H; " "
	CALL DATA
	MVI A,50H; "P"
	CALL DATA
	MVI A,0C0H; /; moving cursor to the next line
	CALL CMD	
	;/ "B. P v/s P"
	MVI A,42H; "B"/Ascii code for display data
	CALL DATA
	MVI A,2EH; "." 
	CALL DATA
	MVI A,20H; " "
	CALL DATA
	MVI A,50H; "P"
	CALL DATA
	MVI A,20H; " " 
	CALL DATA
	MVI A,76H; "v"
	CALL DATA
	MVI A,2FH; "/"
	CALL DATA
	MVI A,73H; "s" 
	CALL DATA
	MVI A,20H; " "
	CALL DATA
	MVI A,50H; "P"
	CALL DATA
	CALL KEYPAD
	ORA A; marking the flags
; if A register has value 0-> no value, display again 1 -> C v/s P 2-> P v/s P 3-> incorrect value
	JZ P_OPT; returning as no input came
	CMA; handling the incorrect input case
	CALL I_INP
	JZ P_OPT; after displaying input was incorrect return
; now 2-> C v/s P and 1->P v/s P 
	DCR A
	CZ P_MINIMAX
	DCR A 
	CNZ CMMAX
	JMP START
	
  
; port 81H data lines of LCD + 80H control lines, EN(7), RW(6), RS(5) and rest don't care	
CMD: 	OUT 81H
	MVI A,80H;RS=0,E=1
	OUT 80H
	CALL DELAY
	MVI A,00H;RS=0,E=0
	OUT 80H
	CALL DELAY
	RET
KEYPAD: IN 82H
	RET
P_MINIMAX: RET
DATA: 	OUT 81H
	MVI A,0A0H;RS=1,E=1
	OUT 80H
	CALL DELAY
	MVI A,20H;RS=1,E=0
	OUT 80H
	CALL DELAY
	RET
	
DELAY:	MVI C,01H; making delay 140/3 * 10^-6 = 46.67us
LOOP:	DCR C
	JNZ LOOP
	RET
		
I_INP:	PUSH PSW
	MVI A,01H; /LCD clear command
	CALL CMD
	MVI A,80H; /cursor position on display at start
	CALL CMD
;/ "INCORRECT INPUT"
	MVI A,49H; "I"/Ascii code for display data
	CALL DATA
	MVI A,4EH; "N" 
	CALL DATA
	MVI A,43H; "C"
	CALL DATA
	MVI A,4FH; "O"
	CALL DATA
	MVI A,52H; "R" 
	CALL DATA
	MVI A,52H; "R"
	CALL DATA
	MVI A,45H; "E"
	CALL DATA
	MVI A,43H; "C" 
	CALL DATA
	MVI A,54H; "T"
	CALL DATA
	MVI A,20H; " "
	CALL DATA
	MVI A,49H; "I"
	CALL DATA
	MVI A,4EH; "N" 
	CALL DATA
	MVI A,50H; "P"
	CALL DATA
	MVI A,55H; "U"
	CALL DATA
	MVI A,54H; "T" 
	CALL DATA
	CALL MDELAY; making delay of 1s 
	POP PSW
	RET
MDELAY:	PUSH PSW  
	LXI B,30D4H; making delay of 1s
LOOP_M:	DCX B
	MOV A, C
	ORA B
	JNZ LOOP_M
	POP PSW
	RET	
.END

CMMAX:	PUSH PSW
	LXI H,BOARD   ;CWIN LOADS BOARD AUTOMATICALLY /H-L MODIFIED NO STACKING FOR H/
	CALL UPDATE	;REPLACING BY THE LED LOGIC
	MVI B,09H
	CALL P12	;PLAY FIRST OR SECOND DISPLAY	
	IN 82H		;CALL KEYPAD
	CPI 00H
	JZ PLAY1
	JMP PLAY2
PLAY1:	DCR B
	MVI M,01H	;PLACE X AT TOPLEFT CORNER
	CALL UPDATE
PLAY2:	CALL PLAYERMOVE
	CALL UPDATE
	DCR B
	JZ ENDOG
	CALL AIMOVE
	CALL UPDATE
	CALL CWIN
	JNZ ENDOG
	DCR B
	JZ ENDOG
	JMP PLAY2	
ENDOG:	CALL SDISP;THIS FUNCTIONS DISPLAYS WHO WON AND UPDATES THE TALLY ON AIBOARD
	POP PSW
	RET
;FUNCTIONS:
;--------------------------------------------------------------
;AIMOVE:

AIMOVE:	PUSH PSW
	PUSH B
	PUSH D
	PUSH H
	LXI H,BOARD
	MVI D,0FFH
	MVI C,09H
AILOOP:	MOV A,M
	CPI 00H
	JNZ INVM
	MVI M,01H
	CALL MIN
	CPI 01H
	JZ EXITA
	;NON WINNING CASES
	CMP D
	JNC SKAI
	MOV D,A
	MOV E,C
SKAI:	MVI M,00H
INVM:	INX H
	DCR C
	JNZ AILOOP
	;CASE 	WHERE IT ISNT A WINNING SITUATION:
	LXI H,BOARD
	MVI D,00H
	MVI A,09H
	SUB E
	MOV E,A
	DAD D
	MVI M,01H
EXITA:	POP H
	POP D
	POP B
	POP PSW
	RET
;---------------------------------------
;MIN
MIN:	PUSH H
	PUSH B
	PUSH D
	LXI H,BOARD
	CALL CWIN
	CPI 00H
	JNZ EXITM
	CALL CFULL
	CPI 00H
	JZ EXITM
	LXI H,BOARD
	MVI D,02H
	MVI C,09H
MINL:	MOV A,M
	CPI 00H
	JNZ MININV
	MVI M,02H	;PLACING 'O'
	CALL MAX
	CPI 02H
	JZ XITFE
	CMP D
	JNC MINSKP
	MOV D,A
MINSKP:	MVI M,00H	;REMOVING 'O'
MININV:	INX H
	DCR C
	JNZ MINL
	MOV A,D
	JMP EXITM
XITFE:	MVI M,00H	;REMOVING 'O'
EXITM:	POP D
	POP B
	POP H
	RET
;---------------------------------------
;MAX
;PLAY AS X(01H)
MAX:	PUSH H
	PUSH B
	PUSH D
	LXI H,BOARD
	CALL CWIN
	CPI 00H
	JNZ EXITMX
	CALL CFULL
	CPI 00H
	JZ EXITMX
	LXI H,BOARD
	MVI D,0FFH
	MVI C,09H
MAXL:	MOV A,M
	CPI 00H
	JNZ MAXINV
	MVI M,01H	;PLACING 'X'
	CALL MIN
	CPI 01H
	JZ XIT01
	CMP D
	JNC MAXSKP
	MOV D,A
MAXSKP:	MVI M,00H	;REMOVING 'X'
MAXINV:	INX H
	DCR C
	JNZ MAXL
	;NON 01 CASES:
	MOV A,D
	JMP EXITMX
XIT01:	MVI M,00H	;REMOVING 'X'
EXITMX:	POP D
	POP B
	POP H
	RET
;---------------------------------------
;FUNCTION TO CHECK IF THE BOARD IS FULL
CFULL:	LXI H,BOARD
	MVI C,09H
EX2:	MOV A,M
	CPI 00H
	JZ EX1
	INX H
	DCR C
	JNZ EX2
	MVI A,00H
	RET
EX1:	MVI A,01H
	RET
;---------------------------------------
;MODIFIED CWIN: FE RETURN AND KEEPING D INTACT
CWIN:	PUSH D
	LXI D,WINLIST
	MVI A,08H
	DCX D
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
	CPI 0FAH
	JZ WINO
	CPI 03H
	JZ WINX
	POP PSW ;RESTORING A	
	DCR A
	JNZ CLOOP	
	POP D
	MVI A,00H
	RET
WINO:	POP PSW ;BALANCING THE STACK
	POP D
	MVI A,02H; O WON
	RET
WINX:	POP PSW ;BALANCING THE STACK
	POP D
	MVI A,01H; X WON
	RET
;---------------------------------------
UPDATE:	LXI SP, 0FFFFH	
	PUSH PSW
	PUSH H
	; modifying the update function such that 01->x and 10->o
	LXI H,BOARD
	MOV A,M; STATUS 000000XX
	RLC
	RLC 
	INX H
	ORA M
	RLC
	RLC; STATUS 0000XXXX
	INX H
	ORA M
	RLC 
	RLC; STATUS 00XXXXXX
	INX H
	ORA M
	; GENERATED THE FIRST 8-BITS
	OUT 00H; GENERATING THE OUTPUT 
	
	INX H
	MOV A,M; STATUS 000000XX
	RLC
	RLC 
	INX H
	ORA M
	RLC
	RLC; STATUS 0000XXXX
	INX H
	ORA M
	RLC 
	RLC; STATUS 00XXXXXX
	INX H
	ORA M
	;GENERATED THE SECOND 8-BITS
	OUT 01H; GENERATING THE OUTPUT
	
	INX H	
	MOV A,M
	;GENERATED THE THIRD 8-BITS
	OUT 02H
	POP H
	POP PSW
	RET
;----------------------------------------
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
BOARD:		.DB 00H,00H,00H
		.DB 00H,00H,00H
		.DB 00H,00H,00H
		
AIBOARD: 	.DB 00H,00H,00H; INITIALISING ALL STATES -> W/L/D	.
;----------------------------------------
PLAYERMOVE:
	PUSH PSW
	LXI H,BOARD
	PUSH D
	MVI D,00H
	IN 80H
	MOV E,A
	DAD D
	POP D
	MOV A,M
	CPI 00H
	JNZ INVALID
	;HL IS STILL POINTING TO EXACT POSITION:
	MVI M,02H ;X=01H ASSUMED, O=02H ASSUMED
	PUSH B
	LXI H,BOARD
	CALL CWIN
	POP B
	CPI 00H
	JNZ STOP	
	POP PSW
	RET
STOP:	CALL UPDATE
	HLT
INVALID: POP PSW
	 INR B
	 RET
;----------------------------------------
SDISP: 	 RET
P12: 	PUSH PSW
	MVI A,01H; /LCD clear command
	CALL CMD
	MVI A,80H; /cursor position on display at start
	CALL CMD
	;/"DO YOU WANT TO PLAY FIRST(A/B)?"
	POP PSW
	RET