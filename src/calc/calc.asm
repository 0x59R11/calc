.8086

INCLUDE calc.inc
INCLUDE .\string\string.inc
INCLUDE .\convr\convr.inc

; Number systems
EXTERN DEC_formatter:WORD, HEX_formatter:WORD, OCT_formatter:WORD, BIN_formatter:WORD


data SEGMENT PARA USE16 PUBLIC 'data'
	
	inputFormatter DW ? 	; Input formatter
	resultFormatter DW ? 	; Retult formatter
	
	
	titleStr DB "Calc v1.0  (by 0x59R11) ", 0Dh, 0Ah, 0Dh, 0Ah, 24h
	
	
	inputFormatStr DB "Choose input format:  (default - DEC, 16 - HEX, 8 - OCT, 2 - BIN): ", 24h
	inputFormatInput DB 10h, 10h DUP(?)
	
	resultFormatStr DB "Choose result format: (default - DEC, 16 - HEX, 8 - OCT, 2 - BIN): ", 24h
	resultFormatInput DB 10h, 10h DUP(?)
	
	
	hexFormatterStr DB "16", 24h
	octFormatterStr DB "8", 24h
	binFormatterStr DB "2", 24h
	
	
	
	
	inputNum1Str DB "num 1: ", 24h
	inputNum2Str DB "num 2: ", 24h
	
	divideByZeroErrorStr DB "Cannot divide by zero", 24h
	
	
	addNStr DB " + ", 24h
	subNStr DB " - ", 24h
	mulNStr DB " * ", 24h
	divNStr DB " / ", 24h
	rdivNStr DB " % ", 24h
	
	resStr DB " = ", 24h
	
	
	
	inputNum1 DB 11h, ?, 11h DUP(?)
	inputNum2 DB 11h, ?, 11h DUP(?)
	
	num1FormattedStr DB 11h DUP(?)
	num2FormattedStr DB 11h DUP(?)
	
	formattedStrPrefix DB ">>>  = ", 24h
	
	
	resultStr DB 11h DUP(?)
	
	
	
	
	
	num1 DW ? ; First number
	num2 DW ? ; Second number
	
	addN DW ? ; num1 + num2
	subN DW ? ; num1 - num2
	mulN DW ? ; num1 * num2
	divN DW ? ; num1 / num2
	rdivN DW ? ; num1 % num2
	
data ENDS

const SEGMENT PARA USE16 PUBLIC 'const'
	
const ENDS



code SEGMENT PARA USE16 PUBLIC 'code'
	ASSUME CS:code, DS:data, SS:stack
	BEGIN:

;
; ENTRY POINT PROCEDURE
;
	main PROC C
	
		mov AX, data
		mov DS, AX
		
		mov AX, const
		mov ES, AX
		
		

		; Output title
		mov AH, 9h
		mov DX, offset titleStr
		int 21h


		; Choose input formatter
		mov AH, 9h
		mov DX, offset inputFormatStr
		int 21h
		
		mov AH, 0Ah
		mov DX, offset inputFormatInput
		int 21h
		mov BX, DX
		add BX, 2h
		xor CX, CX
		mov CL, BYTE PTR [BX - 1]
		add BX, CX
		mov BYTE PTR [BX], 24h
		
		; Write new line
		mov AH, 2h
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		
		mov WORD PTR [inputFormatter], offset DEC_formatter
		
		
		invoke strcmp, offset inputFormatInput + 2, offset hexFormatterStr
		cmp AX, 0h
		jne no_set_hex_input_formatter
		mov WORD PTR [inputFormatter], offset HEX_formatter
		jmp done_set_input_formatter
		
	no_set_hex_input_formatter:
		invoke strcmp, offset inputFormatInput + 2, offset octFormatterStr
		cmp AX, 0h
		jne no_set_oct_input_formatter
		mov WORD PTR [inputFormatter], offset OCT_formatter
		jmp done_set_input_formatter
		
	no_set_oct_input_formatter:
		invoke strcmp, offset inputFormatInput + 2, offset binFormatterStr
		cmp AX, 0h
		jne done_set_input_formatter
		mov WORD PTR [inputFormatter], offset BIN_formatter
		
		
		
	done_set_input_formatter:
		
		
		
		; Choose result formatter
		mov AH, 9h
		mov DX, offset resultFormatStr
		int 21h
		
		mov AH, 0Ah
		mov DX, offset resultFormatInput
		int 21h
		mov BX, DX
		add BX, 2h
		xor CX, CX
		mov CL, BYTE PTR [BX - 1]
		add BX, CX
		mov BYTE PTR [BX], 24h
		
		; Write new line
		mov AH, 2h
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		
		mov WORD PTR [resultFormatter], offset DEC_formatter
		
		
		
		invoke strcmp, offset resultFormatInput + 2, offset hexFormatterStr
		cmp AX, 0h
		jne no_set_hex_result_formatter
		mov WORD PTR [resultFormatter], offset HEX_formatter
		jmp done_set_result_formatter
		
	no_set_hex_result_formatter:
		invoke strcmp, offset resultFormatInput + 2, offset octFormatterStr
		cmp AX, 0h
		jne no_set_oct_result_formatter
		mov WORD PTR [resultFormatter], offset OCT_formatter
		jmp done_set_result_formatter
		
	no_set_oct_result_formatter:
		invoke strcmp, offset resultFormatInput + 2, offset binFormatterStr
		cmp AX, 0h
		jne done_set_result_formatter
		mov WORD PTR [resultFormatter], offset BIN_formatter
		
		
		
	done_set_result_formatter:
		
		
		
		; Write new line
		mov AH, 2h
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		
		
		
		; Output input prefix
		mov AH, 9h
		mov DX, offset inputNum1Str
		int 21h
		
		; Input num1
		mov AH, 0Ah
		mov DX, offset inputNum1
		int 21h
		mov BX, DX
		add BX, 2h
		xor CX, CX
		mov CL, BYTE PTR [BX - 1]
		add BX, CX
		mov BYTE PTR [BX], 24h
		
		; Parse num1
		invoke parsetonum, offset inputNum1 + 2, WORD PTR [inputFormatter]
		mov WORD PTR [num1], AX
		
		invoke parsetostr, WORD PTR [num1], offset num1FormattedStr, WORD PTR [resultFormatter]
		
		; Write new line
		mov AH, 2h
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		
		
		; Output num1 in result formatter
		mov AH, 9h
		mov DX, offset formattedStrPrefix
		int 21h
		
		mov DX, offset num1FormattedStr
		int 21h


		; Write new line
		mov AH, 2h
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		
		
		
		; Output input prefix
		mov AH, 9h
		mov DX, offset inputNum2Str
		int 21h
		
		; Input num2
		mov AH, 0Ah
		mov DX, offset inputNum2
		int 21h
		mov BX, DX
		add BX, 2h
		xor CX, CX
		mov CL, BYTE PTR [BX - 1]
		add BX, CX
		mov BYTE PTR [BX], 24h
		
		; Parse num2
		invoke parsetonum, offset inputNum2 + 2, WORD PTR [inputFormatter]
		mov WORD PTR [num2], AX
		
		invoke parsetostr, WORD PTR [num2], offset num2FormattedStr, WORD PTR [resultFormatter]
		
		; Write new line
		mov AH, 2h
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		
		
		; Output num2 in result formatter
		mov AH, 9h
		mov DX, offset formattedStrPrefix
		int 21h
		
		mov DX, offset num2FormattedStr
		int 21h
		
		
		; Write new line
		mov AH, 2h		
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h


		
		; Write new line
		mov AH, 2h		
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		
		
		
		; Calculating Add
		mov AX, WORD PTR [num1]
		add AX, WORD PTR [num2]
		mov WORD PTR [addN], AX	
			
		invoke parsetostr, WORD PTR [addN], offset resultStr, WORD PTR [resultFormatter]
		
		; Output add result
		mov AH, 9h
		mov DX, offset num1FormattedStr
		int 21h
		
		mov DX, offset addNStr
		int 21h
		
		mov DX, offset num2FormattedStr
		int 21h
		
		mov DX, offset resStr
		int 21h
		
		mov DX, offset resultStr
		int 21h
		
		
		; Write new line
		mov AH, 2h		
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		nop
		
		
		
		; Calculating Sub
		mov AX, WORD PTR [num1]
		sub AX, WORD PTR [num2]
		mov WORD PTR [subN], AX
		
		invoke parsetostr, WORD PTR [subN], offset resultStr, WORD PTR [resultFormatter]
		
		; Output sub result
		mov AH, 9h
		mov DX, offset num1FormattedStr
		int 21h
		
		mov DX, offset subNStr
		int 21h
		
		mov DX, offset num2FormattedStr
		int 21h
		
		mov DX, offset resStr
		int 21h
		
		mov DX, offset resultStr
		int 21h
		
		
		; Write new line
		mov AH, 2h		
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		nop
		
		
		; Calculating Mul
		mov AX, WORD PTR [num1]
		mul WORD PTR [num2]
		mov WORD PTR [mulN], AX
		
		invoke parsetostr, WORD PTR [mulN], offset resultStr, WORD PTR [resultFormatter]
		
		; Output mul result
		mov AH, 9h
		mov DX, offset num1FormattedStr
		int 21h
		
		mov DX, offset mulNStr
		int 21h
		
		mov DX, offset num2FormattedStr
		int 21h
		
		mov DX, offset resStr
		int 21h
		
		mov DX, offset resultStr
		int 21h
		
		
		; Write new line
		mov AH, 2h		
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		nop
		
		
		
		
		; Calculating Div		
		cmp WORD PTR [num2], 0h
		je devide_by_zero_error
		

		mov AX, WORD PTR [num1]
		xor DX, DX
		div WORD PTR [num2]	
		mov WORD PTR [divN], AX
		mov WORD PTR [rdivN], DX
		
		
		invoke parsetostr, WORD PTR [divN], offset resultStr, WORD PTR [resultFormatter]
		
		; Output div result
		mov AH, 9h
		mov DX, offset num1FormattedStr
		int 21h
		
		mov DX, offset divNStr
		int 21h
		
		mov DX, offset num2FormattedStr
		int 21h
		
		mov DX, offset resStr
		int 21h
		
		mov DX, offset resultStr
		int 21h
		
		
		; Write new line
		mov AH, 2h		
		mov DL, 0Dh
		int 21h
		
		mov DL, 0Ah
		int 21h
		nop
		
		
		invoke parsetostr, WORD PTR [rdivN], offset resultStr, WORD PTR [resultFormatter]
		
		; Output rdiv result
		mov AH, 9h
		mov DX, offset num1FormattedStr
		int 21h
		
		mov DX, offset rdivNStr
		int 21h
		
		mov DX, offset num2FormattedStr
		int 21h
		
		mov DX, offset resStr
		int 21h
		
		mov DX, offset resultStr
		int 21h
		
		
		jmp skip_output_devide_by_zero_error
		
		
	devide_by_zero_error:
		mov AH, 9h
		mov DX, offset divideByZeroErrorStr
		int 21h
		
	skip_output_devide_by_zero_error:
		
		; Write new line
		;mov AH, 2h		
		;mov DL, 0Dh
		;int 21h
		
		;mov DL, 0Ah
		;int 21h
		;nop
		
		

		mov AX, 4C00h
		int 21h
		nop
		
	ret
	ALIGN 10h
	main ENDP
;
;
;
	
	
code ENDS


stack SEGMENT PARA USE16 STACK 'stack'
	DB 256 DUP(?)
stack ENDS
END BEGIN