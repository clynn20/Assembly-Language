TITLE	ASSIGNMENT_FOUR    (CompositeNumbers.asm)
;Author: Chialing Hu
;Course: CS271
;Date: 10/23/2020
;Program: Assignment 4

INCLUDE Irvine32.inc


.data

;display string
	progtitle		BYTE		"Welcome to Composite Numbers  by Chialing Hu",0
	intro_one		BYTE		"Please enter the number of composite numbers you would like to see. ",0
	intro_two		BYTE		"The program will accept orders up to 400 composites.",0
	ask_num		BYTE		"Enter the number of composites to display [1,400]: ",0
	outrange		BYTE		"Out of range! Try again.",0
	goodbye		BYTE		"Results Certified by Chialing Hu. Thank you for using Composite Numbers. Goodbye. ",0
	space		BYTE		"	",0
	
	UPPERBOUND = 400
	LOWERBOUND = 1
	input_num		SDWORD	?
	temp			SDWORD	3
	count		SDWORD	0
	divisor		SDWORD	?


.code

main PROC
	call introduction
	call	getuserdata
	call showcomposites
	call farewell

	exit
main ENDP


;-----------------------------------------------------------
;prodecure to show introduction of program
;receives: none
;reutrns:	 none
;preconditions:	none
;registered changed:	edx
;-----------------------------------------------------------

introduction PROC

	mov		edx,offset progtitle
	call		WriteString 
	call		crlf
	call		crlf
	mov		edx,offset intro_one
	call		WriteString
	call		crlf
	mov		edx,offset intro_two
	call		WriteString
	call		crlf
	call		crlf
	ret

introduction ENDP


;-----------------------------------------------------------
;prodecure to get data from user 
;receives: none
;reutrns:	 none
;preconditions:	none
;registered changed:	edx
;-----------------------------------------------------------

getuserdata PROC

promptdata:
	mov		edx,offset ask_num
	call		WriteString
	call		ReadInt


;-----------------------------------------------------------
;prodecure to validate the input data from user
;receives:	input_num from user 
;reutrns:		validate the user input, if out of bound then show error message
;preconditions:	
;registered changed:	eax,edx
;-----------------------------------------------------------

validate PROC
checkbound:
	mov		input_num,eax
	cmp		input_num,UPPERBOUND
	jg		tryagain
	cmp		input_num,LOWERBOUND
	jl		tryagain
	jmp		gooddata

tryagain:
	mov		edx,offset outrange
	call		WriteString
	call		crlf
	mov		edx,offset ask_num
	call		WriteString
	call		ReadInt
	jmp		checkbound
	
gooddata:
	ret
validate ENDP
	
	call		crlf
	ret
getuserdata ENDP


;-----------------------------------------------------------
;prodecure to find and show composite number
;receives: input_num from user 
;reutrns:	 none
;preconditions:	validated input_num between 1 to 400
;registered changed:	ecx
;-----------------------------------------------------------

showcomposites PROC

	mov		ecx,input_num						;show the excatly term user want 
compositeloop:
	call		iscomposite
	call		printcomposite
	loop		compositeloop


;-----------------------------------------------------------
;prodecure to find the composite numbers
;receives: none
;reutrns:	 none
;preconditions:	none
;registered changed:	edx,eax,ebx
;-----------------------------------------------------------

iscomposite	PROC

newdividen:
	inc		temp								;increase temp in each new cycle, temp is the dividend right here
	mov		divisor,1							;set the divisor
newdivisor:
	inc		divisor							;increase divisor in each new cycle,which means always start from two
	mov		eax,temp		
	mov		ebx,divisor
	cmp		eax,ebx									
	je		newdividen						;the prime number only has 1 and itself as factor
	mov		edx,0							
	idiv		ebx
	cmp		edx,0
	jne		newdivisor						;if the remainder is not equal to zreo, try another divisor until it works 
	ret										;any number passes this function is a composite number
iscomposite	ENDP


;-----------------------------------------------------------
;prodecure to print the composite number 
;receives: validated temp  
;reutrns:	 print the validated temp (composite number)
;preconditions:	validated temp (composite number) from iscomposite prodecure 
;registered changed:	edx,eax
;-----------------------------------------------------------

printcomposite	PROC
	
	inc		count
	mov		eax,temp						
	call		WriteDec							
	mov		edx,offset space
	call		WriteString
	cmp		count,8							;each line can only contain eight composite numbers at most 
	je		newline
	jmp		endprint

newline:										
	call		crlf								;switch to new line
	mov		count,0							;set the new count in new line

endprint:
	ret
printcomposite	ENDP

	ret
showcomposites ENDP



;-----------------------------------------------------------
;prodecure to say goodbye to user 
;receives: none
;reutrns:	 none
;preconditions:	none
;registered changed:	edx
;-----------------------------------------------------------

farewell	PROC
	call		crlf
	mov		edx,offset goodbye
	call		WriteString
	call		crlf
	ret
farewell	ENDP

END main







