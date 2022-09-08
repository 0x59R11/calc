.8086

INCLUDE .\string\string.inc
INCLUDE convr.inc

PUBLIC DEC_formatter, HEX_formatter, OCT_formatter, BIN_formatter


const SEGMENT PARA PUBLIC 'const'
	; FORMATTERS:
	HEX_formatter PFORMAT <0010h, 1000h>
	DEC_formatter PFORMAT <000Ah, 2710h>
	OCT_formatter PFORMAT <0008h, 8000h>
	BIN_formatter PFORMAT <0002h, 8000h>
	
const ENDS


code SEGMENT PARA USE16 PUBLIC 'code'
	
	
; -----------------------------------------------
; unsigned short ParseStringToNumber(char* strPtr[], PFORMAT* formatter)
; {
	parsetonum PROC C strPtr:WORD, formatter:WORD
	sub SP, 6h
	push BX
	push CX
	push DX
	push SI
	push DI
	
	
		; "123", 24  -  31, 32, 33, 24
		mov SI, strPtr
		
		mov WORD PTR [BP - 6], 0h
		cmp BYTE PTR [SI], 2Dh ; if first char == '-'
		jne parse1
		mov WORD PTR [BP - 6], 1h
		inc SI
		
	parse1:	
		
		invoke strlen, SI
		mov WORD PTR [BP - 2], AX ; [BP - 2] - str len
		
		mov DI, AX
		dec DI
		
		xor AX, AX
		mov WORD PTR [BP - 4], AX ; [BP - 4] - result
		
		
		mov CX, 1h
		
	loop1:
		mov BX, SI
		add BX, DI
		
		xor AX, AX
		mov AL, BYTE PTR [BX]
		

		; TODO: Unhandled check characters to number
		cmp AL, 41h
		jge hex_num
		sub AL, 30h
		jmp dec_num
	hex_num:
		invoke toupper_char, AL
		sub AL, 37h
	dec_num:
		;
		
		
		mul CX
		add WORD PTR [BP - 4], AX
		
		
		mov AX, CX
		mov BX, WORD PTR [formatter]
		mov BX, WORD PTR ES:[BX]
		mul BX
		mov CX, AX
		
		
		dec DI
		
		
		cmp DI, 0
	jge loop1
		
		
		cmp WORD PTR [BP - 6], 1h
		jne setresult
		mov AX, WORD PTR [BP - 4]
		neg AX
		mov WORD PTR [BP - 4], AX
		
		
	setresult:
		; Load result into AX
		mov AX, WORD PTR [BP - 4]
		
	pop DI
	pop SI
	pop DX
	pop CX
	pop BX
	add SP, 6h
	ret
	ALIGN 10h
	parsetonum ENDP
; }
; -----------------------------------------------
;
	
	
; -----------------------------------------------
; none ParseNumberToString(unsigned short num, char* buffer[], PFORMAT* formatter)
; {
	parsetostr PROC C number:WORD, outBuffer:WORD, formatter:WORD
	push BX
	push CX
	push DX
	push SI
	push DI
	
		
		mov SI, WORD PTR [formatter]
		mov DI, outBuffer
			
		mov AX, number
		mov CX, WORD PTR ES:[SI + 2] ; divider
		
		
	loop1:
		xor DX, DX
		div CX
		mov BX, DX ; remainder of the division
		
		
		; TODO: Unhandled check
		cmp AL, 0Ah
		jge hex_num
		add AL, 30h
		jmp dec_num
	hex_num:
		add AL, 37h
	dec_num:
		;
		
		
		mov BYTE PTR [DI], AL
		inc DI
		
		mov AX, CX
		xor DX, DX
		div WORD PTR ES:[SI + 0]
		mov CX, AX
		
		mov AX, BX
		cmp CX, 1
	jge loop1
		
		
		mov BYTE PTR [DI], 24h
		
		
	pop DI
	pop SI
	pop DX
	pop CX
	pop BX
	ret
	ALIGN 10h
	parsetostr ENDP
; }
; -----------------------------------------------
;
	
	
code ENDS
END