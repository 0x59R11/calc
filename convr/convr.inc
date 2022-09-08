
; STRUCTURES:
	PFORMAT STRUCT
		mulr WORD ?
		divr WORD ?
	PFORMAT ENDS

; PROCEDURES:
	parsetonum PROTO C strPtr:WORD, formatter:WORD
	parsetostr PROTO C number:WORD, outBuffer:WORD, formatter:WORD