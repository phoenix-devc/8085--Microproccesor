;1-9 MAPPED TO 0-8
;* -> E
;# -> F
;0 -> 9
;PCH PULSES 
;PCL POLLED
;@82H (PPI-2,PORT C)
;CONFIGURATION :
;CWR = 10001000B (CHECK)
;=88H
.ORG 0000H
;KEYIN WAITS FOR AN INPUT AND AS SOON AS IT GETS AN INPUT , DEBOUNCES ABIT
;EDITS THE VALUE OF FLAGS AND RETURNS INPUT CODE IN ACCUMULATOR <=
;ADD A DEBOUNCING DELAY ASWELL
;DUMMY CODE:__
	LXI SP,0000H
	CALL KEYINP
	HLT


;___
KEYINP:	PUSH B
	PUSH H
	;CONFIGURING OUTPUT PORT (DELETE IF REDUNDANT)
	MVI A,88H
	OUT 83H
	;END OF PORT CONFIGURATION
	;PULSING PCl
KEYREP:	MVI A,00001110B
	OUT 82H
	IN 82H
	ANI 0F0H
	CALL SHIFTACC
	CALL CHECKKEY1	;EDIT A,PSW
	CPI 10H
	JNZ KEYEND
	MVI A,20H
	OUT 82H
	IN 82H
	ANI 0FH
	CALL CHECKKEY2
	CPI 10H
	JNZ KEYEND
	MVI A,40H
	OUT 82H
	IN 82H
	ANI 0FH
	CALL CHECKKEY3
	CPI 10H
	JNZ KEYEND
	MVI A,80H
	OUT 82H
	IN 82H
	ANI 0FH
	CALL CHECKKEY4
	CPI 10H
	JNZ KEYEND
	JMP KEYREP
KEYEND:	POP H	
	POP B
	RET
CHECKKEY1:	CPI 01H		;MASKED D8-D5 sent in LSB
		;D
		JNZ SCK11
		MVI A,0DH
		RET	
SCK11:		CPI 02H
		JNZ SCK12
		MVI A,0CH
		RET
SCK12:		CPI 04H
		JNZ SCK13
		MVI A,0BH
		RET
SCK13:		CPI 08H
		JNZ SCK14
		MVI A,0AH
		RET
SCK14:		MVI A,10H
		RET 
CHECKKEY3:	CPI 01H		;MASKED D8-D5 sent in LSB
		;9
		JNZ SCK31
		MVI A,09H
		RET	
SCK31:		CPI 02H
		JNZ SCK32
		MVI A,07H
		RET
SCK32:		CPI 04H
		JNZ SCK33
		MVI A,04H
		RET
SCK33:		CPI 08H
		JNZ SCK34
		MVI A,01H
		RET
SCK34:		MVI A,10H
		RET 
CHECKKEY2:	CPI 01H		;MASKED D8-D5 sent in LSB
		;#
		JNZ SCK21
		MVI A,0FH
		RET	
SCK21:		CPI 02H
		JNZ SCK22
		MVI A,08H
		RET
SCK22:		CPI 04H
		JNZ SCK23
		MVI A,05H
		RET
SCK23:		CPI 08H
		JNZ SCK24
		MVI A,02H
		RET
SCK24:		MVI A,10H
		RET 
CHECKKEY4:	CPI 01H		;MASKED D8-D5 sent in LSB
		;*
		JNZ SCK41
		MVI A,0EH
		RET	
SCK41:		CPI 02H
		JNZ SCK42
		MVI A,06H
		RET
SCK42:		CPI 04H
		JNZ SCK43
		MVI A,03H
		RET
SCK43:		CPI 08H
		JNZ SCK44
		MVI A,00H
		RET
SCK44:		MVI A,10H
		RET 
	