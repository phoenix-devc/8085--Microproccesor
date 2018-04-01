; PCH - these are the column ports(ouptut) 
; PCL - these are the row ports(input) 
; @82H (PPI-2,PORT C)
; CWR = 10000001B (CHECK)
; =81H
; MAPPING LOGIC
;0000->1 0100->2 1000->3 1100->A
;0001->4 0101->5 1001->6 1101->B
;0010->7 0110->8 1010->9 1110->C
;0011->* 0111->0 1011-># 1111->D

.ORG 0000H
	LXI SP,0000H
	CALL KEYINP
	HLT
KEYINP:	PUSH B
	;CONFIGURING OUTPUT PORT (DELETE IF REDUNDANT)
	MVI A,81H
	OUT 83H
KEYREP:	LXI B, 0000H
	MVI A,70H
	OUT 82H
	IN 82H
	ORI 0F0H
	CALL CKEY
	CPI 22H
	JZ KEYEND 
	INX B
	MVI A,0B0H
	OUT 82H
	IN 82H
	ORI 0F0H
	CALL CKEY
	CPI 22H
	JZ KEYEND
	INX B
	MVI A,0D0H
	OUT 82H
	IN 82H
	ORI 0F0H
	CALL CKEY
	CPI 22H
	JZ KEYEND
	INX B
	MVI A,0E0H
	OUT 82H
	IN 82H
	ORI 0F0H
	CALL CKEY
	CPI 22H
	JZ KEYEND
	JMP KEYREP
KEYEND:	MOV A, C
	POP B
	RET
CKEY:	RAL; THESE
	RAL; ARE
	RAL; THE REDUNDANT
	RAL; UPPER BITS
	RAL
	JNC SEND
	INR C
	RAL
	JNC SEND
	INR C
	RAL
	JNC SEND
	INR C
	RAL
	JNC SEND
CEND:	RET
SEND:	MVI A, 22H
	; DEBOUNCING DELAY FOR 1ms
	PUSH B
	MVI C, 02H
CAG2:	MVI B, 03FH
CAG:	DCR B
	JNZ CAG
	DCR C
	JNZ CAG2
	POP B
	JMP CEND	