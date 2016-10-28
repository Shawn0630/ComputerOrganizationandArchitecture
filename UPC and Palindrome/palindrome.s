	AREA PALIN, CODE, READONLY
	ENTRY
	
	LDR r1,=STG			;Load r1 with the address of the string
	LDRB r2,EOS			;Put the end of string value, NULL, in r2
	MOV r4,#0			;Load r4 so it can be a counter for the length of the string
	LDRB r3,[r1,r4]		;Load the first ASCII value of the string in r3 from r1
	MOV r5,#0			;r5 will hold the value to keep track of the first half of the string position
	
LP1 CMP r3,r2			;Compare the string position value with the null EOS
	BEQ FIN				;If the are equal values, both null, exit
	LDRB r3,[r1,r4]		;Load the next ASCII value of the string in r3
	ADD r4,#1			;Add 1 to the counter
	B	LP1				;Always go back to the top of the loop
FIN SUB r4,#2			;Subtract 1 so we don't count the null, and another because the string starts at 0
	
NEW LDRB r6,[r1,r5]		;Load the next value of the string into r6
CP1 CMP r6,#ca			;Compare the string position to the value before ASCII letters start
	BLO ET1				;If r6 < 64 it cannot be an ASCII letter, upper case or lower case, so ET1 (exit 1)
CP2	CMP r6,#a			;Compare the string position to the value before lower case ASCII a
	BHI NT1				;If r6 > 96, it may be an ASCII value so go to NT1 (next 1)
	B	CH1				;Otherwise it may be a capital letter so go to CH1 (change 1)
NT1 CMP r6,#z			;Compare the string position to the value after ASCII z
	BLO ET2				;If r6 < 123, it is an ASCII lower case letter so go to ET2 (exit 2)
	B	ET1				;Otherwise r6 > 122, so it is too large to be an ASCII letter so go to ET1 (exit 1)
CH1 ADD r6,#32			;If it is a capital letter we can add 32 to see if it might be lower case
	B	CP1				;Go back to CP1 (compare 1) to see if it is a lower case letter
ET1 ADD r5,#1			;Increment the position variable since it was not an ASCII code
	B	NEW				;Go back to CP1 (compare 1) to compare the next string position value

ET2 LDRB r7,[r1,r4]		;Load the previous value of the string into r7
CP3 CMP r7,#ca			;Compare the string position to the value before ASCII letters start
	BLO ET3				;If r7 < 64 it cannot be an ASCII letter, upper case or lower case, so ET3 (exit 3)
CP4	CMP r7,#a			;Compare the string position to the value before lower case ASCII a
	BHI NT2				;If r7 > 96, it may be an ASCII value so go to NT2 (next 2)
	B	CH2				;Otherwise it may be a capital letter so go to CH2 (change 2)
NT2 CMP r7,#z			;Compare the string position to the value after ASCII z
	BLO ET4				;If r7 < 123, it is an ASCII lower case letter so go to ET4 (exit 4)
	B	ET3				;Otherwise r7 > 122, so it is too ylarge to be an ASCII letter so go to ET3 (exit 3)
CH2 ADD r7,#32			;If it is a capital letter we can add 32 to see if it might be lower case
	B	CP3				;Go back to CP3 (compare 3) to see if it is a lower case letter
ET3 SUB r4,#1			;Decrement the position variable since it was not an ASCII code
	B	ET2				;Go back to CP3 (compare 3) to compare the previous string position value

ET4 CMP r4,r5			;See if we have checked the same location (counters r4 and r5 keep track of two locations)
	BLE PAL				;If r5 >= r4, it has made it past the half point of the string and we have a palindrome so go to PAL (palindrome)
	CMP r6,r7			;Otherwise, we do not have a palindrome yet so compare r6 and r7
	BNE INV				;If they are not equal we do not have a palindrome and go to INV (invalid)
	ADD r5,#1			;Add 1 from r5 to move to the next location in the string
	SUB r4,#1			;Subtract 1 from r4 to move to the previous location in the string
	B	NEW				;Go back to NEW (new) to keep checking for a palidrome
PAL MOV r0,#1			;Since we have a palindrome store r0 with 1
	B	EXT				;Go to EXT (exit)
INV MOV r0,#0			;If we do not have a palidrome store 0 in r0
EXT B EXT				;Infinite loop symbolizes we are done
	
	AREA PALIN, DATA, READONLY

ca	EQU 64							;ca will hold the ASCII value before upper case A
a	EQU 96							;a will hold the ASCII value before lower a
z	EQU 123							;z will hold the ASCII value after lower case z
STG DCB "He lived as a devil, eh?" 	;string 
EOS DCB 0x00						;null string character

	END