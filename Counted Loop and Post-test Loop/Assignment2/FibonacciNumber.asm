TITLE	ASSIGNMENT_TWO    (FibonacciNumber.asm)
;Author: Chialing Hu
;Course: CS271
;Date: 10/11/2020
;Program: Assignment 2

INCLUDE Irvine32.inc

	UPPERBOUND = 46
	LOWERBOUND = 1

.data
	;display string
	progtitle		BYTE		"Fibnoacci Numbers      by Chialing Hu",0
	ask_name		BYTE		"What's your name?",0
	display_name	BYTE		"Hello, ",0
	intro_one		BYTE		"Enter the number of Fibonacci terms to be displayed.",0
	intro_two		BYTE		"It should be an integer in the range [1,46].",0
	ask_terms		BYTE		"How many Fibonacci terms do you want?",0
	bad_terms		BYTE		"Out of range, the number should between [1,46], try again.",0
	endinfo		BYTE		"Results certified by Chialing Hu",0  
	goodbye		BYTE		"Goodbye, ",0
	space_sign	BYTE		"	",0


	username		BYTE		30 DUP(0)
	bytecount		DWORD	?
	term_input	SDWORD	?
	temp			DWORD	?
	count		DWORD     0


.code
main PROC

	;show the program title
title:
	mov		edx,offset progtitle
	call		WriteString
	call		crlf
	call		crlf
	
	;promt the user info 
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

	;show fibs terms intro
fibintro:
	mov		edx,offset intro_one
	call		WriteString
	call		crlf
	mov		edx,offset intro_two
	call		WriteString
	call		crlf
	
	;get fib terms from user
again:
	mov		edx,offset ask_terms
	call		WriteString
	call		ReadInt                         
	mov		term_input,eax
	
	;validate the fibs terms input
validate:
	cmp		term_input,UPPERBOUND
	jg		error
	cmp		term_input,LOWERBOUND	
	jl		error
	jmp		setfibloop
	
	;show error when out of bound
error:
	mov		edx,offset bad_terms
	call		WriteString
	call		crlf
	loop		again
	
	;set the fib loop term
setfibloop:
	mov		ecx,term_input
	mov		eax,1
	mov		ebx,0

	;show fib terms based on user input
printfib:	
	add		eax,ebx						;fn = fn-1 + fn-2
	call		WriteDec
	mov		temp,eax						
	mov		eax,ebx						;become new fn-2
	mov		ebx,temp						;become new fn-1
	mov		edx,offset space_sign
	call		WriteString
	inc		count						;count start from 0 , add one after pre writedec 
	cmp		count,4						;most term pre line
	je		nextrow
	jmp		keeploop

nextrow:
	call		crlf
	mov		count,0
	
keeploop:
	loop		printfib						;loop back until ecx=0
	

	;show farewell message
saygoodbye:
	call		crlf
	mov		edx,offset endinfo
	call		WriteString 
	call		crlf
	mov		edx,offset goodbye
	call		WriteString
	mov		edx,offset username
	call		WriteString
	call		crlf
	
	
	exit

main ENDP
END main