.8086

INCLUDE string.inc


code SEGMENT PARA USE16 PUBLIC 'code'
	
	
; -----------------------------------------------
; unsigned short GetStringLength(char* strPtr[])
; {
	strlen PROC C strPtr:WORD ; AX - result
	push SI
	push DI
		
		
		; SI - pointer to the first character
		; DI - pointer to the next character
		
		mov SI, strPtr
		mov DI, SI
		
		xor AX, AX 				; Clear AX
		
		
		
		; for (char* ptr = strPtr; *ptr != '$'; ptr++)
	strlen_loop1: 			
		cmp BYTE PTR [DI], 24h
		je strlen_found 	; [DI] == '$'
		inc DI
		jmp strlen_loop1
		;
		
		
		; lastCharPtr - firstCharPtr = string Length
	strlen_found:
		mov AX, DI
		sub AX, SI
		
		
	pop DI
	pop SI
	ret
	ALIGN 10h
	strlen ENDP
; }
; -----------------------------------------------
;
	
	
; -----------------------------------------------
; unsigned short GetSumOfString(char* strPtr[])
; {
	strsum PROC C strPtr:WORD ; AX - result
	push SI
	push DI
	push CX
		
		
		; SI - pointer to the indexed character
		; DI - pointer to the last character
		
		mov SI, strPtr
		mov DI, SI
		
		invoke strlen, SI
		add DI, AX 				; DI += strlen
		
		xor CX, CX
		
	strsum_loop1:
		mov CL, BYTE PTR [SI]
		add AX, CX
		inc SI
		cmp DI, SI
		jne  strsum_loop1
		
		
	pop CX
	pop DI
	pop SI
	ret
	ALIGN 10h
	strsum ENDP
; }
; -----------------------------------------------
;
	
	
; -----------------------------------------------
; unsigned short CompareTwoStrings(char* strA[], char* strB[])
; {
	strcmp PROC C strA:WORD, strB:WORD ; AX - result
	push CX
		
		
		invoke strsum, strB
		mov CX, AX
		
		invoke strsum, strA
		
		sub AX, CX
		
		
	pop CX
	ret
	ALIGN 10h
	strcmp ENDP
; }
; -----------------------------------------------
;
















;
; To upper character
; -----------------------------------------------
	toupper_char PROC C character:BYTE ; AX - result
		
		xor AX, AX
		mov AL, character
		and AL, 0DFh
		
	ret
	ALIGN 10h
	toupper_char ENDP
;
; -----------------------------------------------
;


;
; To lower character
; -----------------------------------------------
	tolower_char PROC C character:BYTE ; AX - result
		
		xor AX, AX
		mov AL, character
		or AL, 20h
		
	ret
	ALIGN 10h
	tolower_char ENDP
;
; -----------------------------------------------
;
	
	
code ENDS
END