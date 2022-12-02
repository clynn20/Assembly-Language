Title assignment7	(combinationcal.asm)
;Author: Chialing Hu
;Course: CS271
;Date: 12/06/2020
;Program: Assignment 7


INCLUDE Irvine32.inc


;macro to print the string which store in memory location 
displayString	MACRO  string
	push		edx
	mov		edx,offset string
	call		WriteString
	pop		edx
ENDM

.data
progtitle		BYTE		"Assignment7: Welcome to the Combinations Calculator   by Chialing Hu",0
intro_one		BYTE		"I'll give you a combinations problem. You enter your answer, and I'll let you know if you're right. ",0
problem_str1   BYTE		"Problem:",0
problem_str2   BYTE		"Number of elements in the set: ",0
problem_str3   BYTE		"Number of elements to choose from the set: ",0
ask_answer     BYTE		"How many ways can you choose: ",0
invalid_str	BYTE		"Invalid input!",0
result_str1	BYTE		"There are ",0
result_str2    BYTE      " combinations of ",0
result_str3	BYTE		" items from a set of ",0
correct_str	BYTE		"You are correct.",0
practice_str	BYTE		"You need more practice.",0
again_str		BYTE		"Another problem?(y or Y/n or N): ",0
invalid_res	BYTE		"Invalid response!",0
goodbye		BYTE		"Thank you for using this program. See you next time.",0
MAXSTR = 10
n			DWORD	?
r			DWORD	?
n_fac		DWORD	?
r_fac		DWORD	?
input_buffer	BYTE		MAXSTR	DUP(?)
input_again	BYTE      MAXSTR	DUP(?)
num			DWORD	?
result		DWORD	?
again		DWORD	?

	


.code

main PROC

	call		introduction

	playagain:	
	
		push		offset n
		push		offset r
		call		showProblem

		push		offset input_buffer
		push		offset num 
		call		getData
		
		push		n
		push		r
		push		offset n_fac
		push		offset r_fac
		push		offset result
		call		combinations

		push		n
		push		r
		push		num
		push		result
		call		showResults

		push		offset again
		push		offset input_again
		call		askAgain

		mov		eax,1
		cmp		again,eax
		je		playagain


	bye:
		displaystring	goodbye


	
exit 
main	ENDP

;-----------------------------------------------------------
;prodecure to show introduction of program
;receives: none
;reutrns:	 none
;preconditions:	none
;registered changed:	none
;-----------------------------------------------------------
Introduction  PROC

	pushad
	displayString 	progtitle	
	call		crlf
	displayString 	intro_one	
	call		crlf
	call		crlf
	popad
	ret	

Introduction ENDP



;-----------------------------------------------------------
;prodecure to generate random numbers and display the problem
;receives:  addr of n and addr of r 
;reutrns:		random number in n and r 
;preconditions:		none
;registered changed:	ebp,eax,ebx,ecx
;-----------------------------------------------------------
showProblem  PROC
	push		ebp
	mov		ebp,esp
	pushad
	mov		ebx,[ebp+12]                        ;addr of n 
	call		Randomize
	mov		eax,10
	call		RandomRange
	add		eax,3
	mov		[ebx],eax						;write random number back in n
	mov		ecx,[ebp+8]					;addr of r 
	call		RandomRange	
	add		eax,1
	mov		[ecx],eax						;write random number back in r 
	displaystring  problem_str1
	call		crlf
	displaystring	problem_str2
	mov		eax,[ebx]
	call		WriteDec						;show n 
	call		crlf
	displaystring	problem_str3
	mov		eax,[ecx]
	call		WriteDec						;show r 
	call		crlf
	popad
	pop		ebp
	ret	8

showProblem  ENDP



;-----------------------------------------------------------
;prodecure to get and validate the user data
;receives: addr of input_buffer, addr of num 
;reutrns:			numeric number in num
;preconditions:	none
;registered changed:	ebp,eax,ebx,ecx,edx,esi
;-----------------------------------------------------------
getData   PROC
	push		ebp
	mov		ebp,esp
	pushad

	get:
		displaystring ask_answer
		mov		edx,[ebp+12]						;addr of input buffer 
		mov		ecx,MAXSTR
		call		Readstring
		mov		ecx,eax							;input buffer string length 
		mov		esi,[ebp+12]						;addr of input buffer 
		mov		ebx,0						
		cld										;forward direction
	
	isnum: 
		lodsb
		movzx	eax,al
		cmp		eax,48							;ascii for 0 
		jl		invalid
		cmp		eax,57							;ascii for 9 
		jg		invalid
		sub		eax,48							;to decimal numeric 
		push		eax
		mov		eax,ebx
		mov		ebx,10
		mul		ebx
		mov		ebx,eax
		pop		eax
		add		ebx,eax
		loop		isnum
		jmp		good  

	invalid:
		displayString  invalid_str					;invalid string 
		call	crlf
		jmp	get

	good: 
		mov		eax,ebx							;final number converted from string 
		mov		ebx,[ebp+8]						;addr of num
		mov		[ebx],eax							;store number in num
		call		crlf

	popad
	pop		ebp
	ret		8

getData  ENDP



;-----------------------------------------------------------
;prodecure to call factorial and calculate the result 
;receives:	value of n, r and addr of result, n_fac, r_fac
;reutrns:		calculated number in result 
;preconditions:	none
;registered changed:	ebp,eax,ebx,ecx
;-----------------------------------------------------------
combinations  PROC

	push		ebp
	mov		ebp,esp
	pushad

	push		[ebp+24]								;n
	call		factorial				
	mov		ebx,[ebp+16]							;addr of n_fac
	mov		[ebx],eax								;move n! into n_fac

	push		[ebp+20]								;r
	call		factorial
	mov		ebx,[ebp+12]							;addr of r_fac
	mov		[ebx],eax								;move r! into r_fac

	mov		eax,[ebp+24]							;n
	mov		ebx,[ebp+20]							;r
	sub		eax,ebx								
	push		eax									;n-r
	call		factorial						
	mov		ebx,eax								;move (n-r)! into ebx

	push		ebx									;(n-r)!
	mov		ecx,[ebp+12]							;addr of r_fac
	mov		eax,[ecx]								;r!
	pop		ebx									
	mul		ebx									;r!*(n-r)!  in eax
	mov		ebx,eax								;store r!*(n-r)! in ebx			
	push		ebx									
	mov		ecx,[ebp+16]							;addr of n_fac
	cdq
	mov		eax,[ecx]								;n!
	pop		ebx									;r!*(n-r)!
	div		ebx									;n!/[r!*(n-r)!] is in eax
	mov		ecx,[ebp+8]							;addr of result
	mov		[ecx],eax								;store n!/[r!*(n-r)!] in result


	popad
	pop		ebp
	ret  20

combinations ENDP



;-----------------------------------------------------------
;prodecure to calculate the factorial 
;receives:	number to be calculated 
;reutrns:		number! in eax
;preconditions:	none
;registered changed:	ebp,eax,ebx
;-----------------------------------------------------------
factorial  PROC

	push		ebp
	mov		ebp,esp
	mov		eax,[ebp+8]							;number to be calculated 
	cmp		eax,0
	ja		recursive
	mov		eax,1
	jmp		return

	recursive:
		dec		eax								;factorial n-1
		push		eax
		call		factorial

	calc:
		mov		ebx,[ebp+8]
		mul		ebx

	return:
		pop		ebp
		ret	4


factorial  ENDP



;-----------------------------------------------------------
;prodecure to display the answer, result and performance 
;receives:	value of n, r, num, result
;reutrns:			none
;preconditions:		the result and num were calculated 
;registered changed:	ebp,eax,ebx,ecx
;-----------------------------------------------------------
showResults   PROC
	
	push		ebp
	mov		ebp,esp
	pushad
	displaystring	result_str1
	mov		eax,[ebp+8]							;result
	call		Writedec
	displaystring	result_str2
	mov		eax,[ebp+16]							;r
	call		Writedec
	displaystring	result_str3
	mov		eax,[ebp+20]							;n
	call		Writedec
	call		crlf
	mov		ebx,[ebp+12]							;num
	mov		ecx,[ebp+8]							;result
	cmp		ebx,ecx	
	je		correct 
	displaystring	practice_str
	call		crlf
	jmp		theend
		
	correct:
		displaystring	correct_str
		call		crlf
	
	theend:
		call		crlf
		popad
		pop		ebp
		ret	16


showResults ENDP



;-----------------------------------------------------------
;prodecure to ask if user want to play again 
;receives:	addr of input_again, again
;reutrns:			    set value for again
;preconditions:		none
;registered changed:	ebp,esi,eax,ebx,ecx,edx
;-----------------------------------------------------------
askAgain   PROC
	
		push		ebp
		mov		ebp,esp
		pushad

		ask:
			displaystring	 again_str
			mov		edx,[ebp+8]						;addr of input_again 
			mov		ecx,MAXSTR
			call		Readstring
			cmp		eax,1							;length of input_again
			jne		invalid

		checkisyY:
			cld
			mov		esi,[ebp+8]						;first char in input_again
			lodsb
			movzx	eax,al
			cmp		eax,79h							;ascii y
			je		trueyY
			cmp		eax,59h							;ascii Y
			je		trueyY
			jmp		checkisnN

		trueyY:
			mov		ebx,[ebp+12]						;addr of again
			mov		eax,1
			mov		[ebx],eax							;set again to 1 
			jmp		theend
			

		checkisnN:
			cld
			mov		esi,[ebp+8]
			lodsb
			movzx	eax,al
			cmp		eax,4Eh							;ascii N
			je		truenN
			cmp		eax,6Eh							;ascii n
			je		truenN
			jmp		invalid

		truenN:
			mov		ebx,[ebp+12]						;addr of again
			mov		eax,0							
			mov		[ebx],eax							;set again to 0
			jmp		theend
			

		invalid:
			call		crlf
			displaystring	invalid_res
			call		crlf
			jmp		ask


		theend:
			call		crlf
			popad
			pop		ebp
			ret	8

askAgain  ENDP



END main 