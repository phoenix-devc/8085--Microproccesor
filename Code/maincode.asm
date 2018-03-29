.ORG 0000H
JMP START

START:	MVI A,38H; /LCD Function initialiser -> 2 lines
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
	MVI A,54H: "T" 
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
	
	;this will be displayed when we start the code, now making a delay of 1s and displaying "LET's PLAY"
	CALL MEN_DELAY
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
	MVI A,54H; "T"
	CALL DATA
	MVI A,B4H; "'"
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

	;after this display: A. C v/s P B. C v/s P these are mapped to A and B on the keypad
	CALL MEN_DELAY
	MVI A,01H; /LCD clear command
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
	
	MVI A,C0H; /; moving cursor to the next line
	CALL CMD	
	;/ "B. C v/s P"
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
	
; port 81H data lines of LCD + 80H control lines, EN(7), RW(6), RS(5) and rest don't care	
CMD: 	OUT 81H
	MVI A,80H ;RS=0,E=1
	OUT 80H
	CALL DELAY
	MVI A,00H ;RS=0,E=0
	OUT 80H
	CALL DELAY
	RET

DATA: 	OUT 81H
	MVI A,A0H ;RS=1,E=1
	OUT 80H
	CALL DELAY
	MVI A,20H ;RS=1,E=0
	OUT 80H
	CALL DELAY
	RET
	
DELAY:	MVI C,8CH; making delay 140/3 * 10^-6 = 46.67us
LOOP:	DCR C
	JNZ LOOP
	RET
.END