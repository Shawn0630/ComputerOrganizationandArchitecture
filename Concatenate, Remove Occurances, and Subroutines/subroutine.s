		AREA FUNCTION, CODE, READONLY
		ENTRY

;-------MAIN-------------------------------------------------------------------------------------------------------
		MOV r0,#2_0011					;Signed integer binary value that gets passed as a parameter to funct
		ADR r13,stack
		BL funct						;Call funct a(r0^2) + b(r0) + c
		MOV r1,r0,LSL #1				;Double the return value and stored it in r1
	
ELOOP 	B ELOOP							;Infinite loop symbolizes we are done	
;------------------------------------------------------------------------------------------------------------------

;-------SUBROUTINE--y = x(ax + b) + c------------------------------------------------------------------------------
funct	STMFD r13!,{r1-r7}				;Store the values of register we will modify in a stack
		
		LDR r1,varA						;Load the value of variable a in r1
		LDR r2,varB						;Load the value of variable b in r2
		LDR r4,varC						;Load the value of variable c in r3
		LDR r5,varD						;Load the value of variable d in r4
		
		MUL r6,r1,r0					;Store a(x) into r6
		ADD r6,r2						;Store a(x) + b into r6
		MUL r6,r0,r6					;Store x(a(x) + b) into r6
		ADD r6,r4						;Store x(a(x) + b) + c into r6
		MOV r0,r6
		
		CMP r0,r5						;Compare the result with variable d
		BMI NTIVE						;If the value is negative do not update it with d
		MOVHI r0,r5						;Store d in the result register if r0 > d
		
NTIVE 	LDMFD r13!,{r1-r7}				;Load the original values of the register from the stack
		BX r14							;Go back to the branch we left called the function from (same as MOV r15,14)
;-------------------------------------------------------------------------------------------------------------------		

		AREA FUNCTION, DATA, READONLY
		
		SPACE 40						;Declare space for the stack
stack	DCD 0							;Base of the stack
varA	DCD 5							;Value for variable a
varB	DCD 6							;Value for variable b
varC	DCD 7							;Value for variable c
varD	DCD 50							;Value for variable d
		
		END