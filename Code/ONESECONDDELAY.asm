// This is a one second delay subroutine that provides delay according to the register B
//Where are the values for D,?
//You pushed H but never popped it. Function won't return.
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
