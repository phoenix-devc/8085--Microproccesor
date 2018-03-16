// This is a one second delay subroutine that provides delay according to the register B

DELAY:	   PUSH D
	   PUSH H
	   PUSH PSW

SECOND:	
	   DCX D
	   MOV A,D

LOOP:	   DCX D
	   MOV A,D
	   ORA E
	   JNZ LOOP
	   DCR B
	   JNZ SECOND
	   POP PSW
	   POP D
	   RET
