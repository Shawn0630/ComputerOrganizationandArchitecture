	AREA UPCCHECK, CODE, READONLY
	ENTRY
	
	LDR r1,=UPC				;Load the address of the UPC string
	MOV r9,#10				;Set r9 to value 10 so we can go through the UPC code except the last digit in the loop
	MOV r10,#0				;Set r10 to value 0 so we know where to start the loop
	 
LOP	CMP r10,r9				;Compare r9 and r10
	BHI FIN					;Is r9 > r10, go to FIN (finish), else continue 
	LDRB r2,[r1,r10]		;Load r2 with the r10th value of the UPC code which is from r1
	SUB r2,#cov				;Subtract 48 from the r10th value to convert it from ASCII
	ADD r3,r2				;Store the summation of the UPC values from r2 in r3
	ADD r10,#1				;Add 1 (since we want every other digit) to our counter which is stored in r10
	CMP r10,r9				;Compare r9 and r10
	BHI FIN					;Is r9 > r10, go to FIN (finish), else continue 
	LDRB r2,[r1,r10]		;Load r2 with the r10th value of the UPC code which is from r1
	SUB r2,#cov				;Subtract 48 from the r10th value to convert it from ASCII
	ADD r4,r2				;Store the summation of the UPC values from r2 in r4
	ADD r10,#1				;Add 1 (since we want every other digit) to our counter which is stored in r10
	B	LOP					;Go back to the top of LOP (loop)

FIN	ADD r2,r3,r3,LSL #1		;Add the value of r3 plus the value of r3 times two and store it in r2
	ADD r2,r4				;Add the first sum and the second sum and store it in r2
	SUB r2,#1				;Subtract 1 from the final sum and store it in r2
	
	LDRB r10,[r1,#11]		;Load r10 with the 11th (last) value of the UPC code which is from r1
	SUB r10,#cov			;Subtract 48 from the r10th value to convert it from ASCII
	
NXT SUB r2,#10				;Subtract 10 from final sum	(division by repeated subtraction)
	CMP r2,#10				;Compare the value of r2 and 10
	BLO LOW					;if r2 < 10, branch to LOW (lower)
	BPL NXT					;Otherwise go back to NXT (next) 
LOW RSB r2,#9				;Reverse subtract r2 from 9 (so 9 minus the value of r2), which gives you the check sum digit

	CMP r2,r10				;compare the check sum digit and the last digit of the UPC code
	BNE INV					;If they are not equal go to INV (invalid)
	MOV r0,#1				;Otherwise store the value 1 in r0 because it is a valid code
	B	EXT					;Go to EXT (exit)
INV MOV r0,#2				;If it is invalid store r0 with the value 2
EXT B EXT					;Infinite loops symbolizes that we are done

	AREA UPCCHECK, DATA, READONLY	

cov 	EQU 48					;The value to convert ASCII code to the actual value
UPC		DCB "013800150738"		;UPC string
UPC1	DCB "060383755577"		;UPC String 1 to test
UPC2	DCB "065633454712"		;UPC String 2 to test
	
	END