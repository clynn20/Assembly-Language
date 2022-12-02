TITLE	ASSIGNMENT_THREE    (NegativeInteger.asm)
;Author: Chialing Hu
;Course: CS271
;Date: 10/18/2020
;Program: Assignment 3

INCLUDE Irvine32.inc


	UPPERBOUND = -1
	LOWERBOUND = -100
.data
	;display string
	progtitle		BYTE		"Welcome to Negative Numbers Accumulator  by Chialing Hu",0
	ask_name		BYTE		"What's your name?",0
	display_name	BYTE		"Hello, ",0
	intro_one		BYTE		"Please enter any number in [-100,-1] ",0
	intro_two		BYTE		"Enter a non-negative number when you are finished to see results.",0
	ask_num		BYTE		"Enter number: ",0
	outrange		BYTE		"Out of range!",0
	allinvalid_report	BYTE		"All of your input is invalid.",0
	enter_report	BYTE		"You enter ",0
	valid_report	BYTE		" valid numbers",0
	sum_report	BYTE		"The sum of your valid input numbers is ",0
	avg_report	BYTE		"The rounded average is ",0
	goodbye		BYTE		"Thank you for playing Integer Accumulator! Goodbye, ",0


	username		BYTE		30 DUP(0)
	bytecount		DWORD	?
	input_num		SDWORD	?
	valid_count	DWORD     0
	sum			SDWORD	0
	average		SDWORD	?
	remainder		SDWORD	?
	ten			SDWORD	10
	five			SDWORD    5
	tenremainder	SDWORD    ?



.code
main PROC

;show the program title
title:
	mov		edx,offset progtitle
	call		WriteString
	call		crlf
	call		crlf

;prompt the username
userinfo:
	mov		edx,offset ask_name
	call		WriteString
	mov		edx,offset username
	mov		ecx,sizeof username
	call		ReadString
	mov		bytecount,eax

;greet to user
greetuser:
	mov		edx,offset display_name
	call		WriteString
	mov		edx,offset username
	call		WriteString
	call		crlf
	call		crlf

;show intro to user
instruction:
	mov		edx,offset intro_one
	call		WriteString
	call		crlf
	mov		edx,offset intro_two
	call      WriteString
	call		crlf

;ask user to input number
getnumber:
	mov		edx,offset ask_num
	call		WriteString
	call		ReadInt

;validate if the input number is between -1 to -100
validate:
	mov		input_num,eax
	cmp		input_num,LOWERBOUND
	jl		tryagain
	cmp		input_num,UPPERBOUND	
	jle		calculatesum
	mov		ebx,0
	cmp		ebx,input_num
	jle		check

	

;calculate the valid negative number then add them together  and count the valid input times
calculatesum:
	mov		eax,input_num
	add		sum,eax
	inc		valid_count
	loop		getnumber

;calculate the round valid input average
calculateavg: 
	mov		eax,sum
	cdq
	mov		ebx,valid_count
	idiv		ebx
	mov		average,eax								;original quoitent
	mov		remainder,edx
	neg		remainder									
	mov		eax,remainder
	imul		ten										;ten X previous remainder to create new remainder
	mov		tenremainder,eax							
	mov		eax,tenremainder
	cdq	
	mov		ebx,valid_count
	idiv		ebx										;use new remainder to divide valid count
	cmp		five,eax									;if the new quoitent is bigger than five
	jle		round									;that means the original quoitent's first decimal point is more than five
	jmp		displayavg								;remain the original quoitent if the first decimal point is less than five



;if the input is bigger or equal than zero and valid count is zero then show special message
;if the input is bigger or equal than zero and there are previous valid negative input then display the result
check:
	mov       ebx,0
	cmp		ebx,valid_count					;enter all invalid number then enter positive number
	je		allinvalid						;show special message 
	cmp		ebx,valid_count					;have entered some valid number then enter positive number
	jb		displaysum						;show the calculation result

;show the final result
displaysum:
;show total valid number count
	mov		edx,offset enter_report
	call		WriteString
	mov		eax,valid_count
	call		WriteDec
	mov		edx,offset valid_report
	call		WriteString
	call		crlf
;show total vaild number sum 
	mov		edx,offset sum_report
	call		WriteString
	mov		eax,sum
	call		WriteInt
	call		crlf
	jmp		calculateavg

;round up the number if the quotient's first decimal point is bigger or equal than five
round:
	dec		average									;since the number is negative we have to minus 1 to round the nearst

displayavg:
;show total valid number average
	mov		edx,offset avg_report
	call		WriteString
	mov		eax,average
	call		WriteInt
	jmp		saygoodbye
	

;show special message if all of the previous input is invalid and jump to end message
allinvalid:
	mov		edx,offset allinvalid_report
	call		WriteString
	jmp		saygoodbye


;try again if input number is smaller than -100
tryagain:
	mov		edx,offset outrange
	call		WriteString
	call		crlf
	jmp		getnumber


saygoodbye:
	call		crlf
	mov		edx,offset goodbye
	call		WriteString
	mov		edx,offset username
	call		WriteString



exit

main ENDP
END main
