TITLE Fibonacci Numbers     (Program02.asm)

; Author: Timothy Liu
; Last Modified: October 14, 2018
; OSU email address: liutim@oregonstate.edu
; Course number/section: CS_271_400_F2018
; Project Number: 2                Due Date: October 14, 2018
; Description: This program will display the program title and the programmer's
;   name, then ask for the user's name before greeting the user. The program will
;   then ask the user for a number of Fibonacci terms to display (from 1 to 46).
;   After validating the input, the program will calculate and display the
;   Fibonacci numbers, then say good-bye to the user before exiting.

; Implementation notes: Uses global variables

INCLUDE Irvine32.inc

LOWER_LIMIT = 1		; Min number of Fibonacci terms
UPPER_LIMIT = 46	; Max number of Fibonacci terms
TAB = 9				; ASCII code for tab
TWO_TABS = 30		; More than 30 terms requires 2 tabs to align columns
ONE_TAB = 9227465	; After this Fib term, 1 tab is sufficient to align columns

.data
programTitle    BYTE    "Fibonacci Numbers", 0              ; Title of program
authorIntro     BYTE    "Programmed by Timothy Liu", 0      ; Introduce author
ec_1			BYTE	"EC #1: Numbers are displayed in "
				BYTE	"aligned columns.", 0				; Describes Extra Credit #1
ec_2			BYTE	"EC #2: Does something incredible, "
				BYTE	"namely column width changes based "
				BYTE	"on user's input.", 0				; Describes Extra Credit #2
promptName      BYTE    "What's your name? ", 0             ; Prompt for user's name
userName        BYTE    33 DUP(0)                           ; String to be entered by user
greeting        BYTE    "Hello, ", 0                        ; Greet user
instructions    BYTE    "Enter the number of Fibonacci "
                BYTE    "terms to be displayed.", 0         ; User instructions
stateRange      BYTE    "Give the number as an integer "
                BYTE    "in the range [1 .. 46].", 0        ; Describe range of input
promptNum       BYTE    "How many Fibonacci terms "
                BYTE    "do you want? ", 0                  ; Prompt for number of Fib terms
outOfRange		BYTE	"Out of range. Enter a number in "
				BYTE	"[1 .. 46]", 0						; Error message for invalid input
numTerms        DWORD   ?                                   ; Holds number of Fib terms
firstTerm		DWORD	0									; Used to help calculate Fib terms
secondTerm		DWORD	1									; Used to help calculate Fib terms
termCounter		DWORD	0									; Counter to ensure 5 terms per row
farewell        BYTE    "Results certified "
                BYTE    " by Timothy Liu", 0Dh, 0Ah 
                BYTE    "Goodbye, ", 0                      ; Farewell text

.code
main PROC
; --- introduction ---
; Display the program name
    mov     edx, OFFSET programTitle
    call    WriteString
    call    CrLf
    
; Display the programmer's name
    mov     edx, OFFSET authorIntro
    call    WriteString
    call    CrLf
    call    CrLf

; Display Extra Credit descriptions
	mov		edx, OFFSET ec_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_2
	call	WriteString
	call	CrLf
	call	CrLf
    
; Prompt for user's name
    mov     edx, OFFSET promptName
    call    WriteString
    
; Get and store user's name
    mov     edx, OFFSET userName
    mov     ecx, SIZEOF userName
    call    ReadString
    
; Greet the user
    mov     edx, OFFSET greeting
    call    WriteString
    mov     edx, OFFSET userName
    call    WriteString
    call    CrLf
    
; --- userInstructions ---
; Display instructions and valid range of input
    mov     edx, OFFSET instructions
    call    WriteString
    call    CrLf
    mov     edx, OFFSET stateRange
    call    WriteString
    call    CrLf
    call    CrLf

; --- getUserData ---        
; Prompt user for number of Fibonacci terms
firstPrompt:
    mov     edx, OFFSET promptNum
    call    WriteString
    call    ReadDec
    
; Validate user input is an int from 1 to 46
    cmp     eax, LOWER_LIMIT
    jl      invalidInput
	cmp		eax, UPPER_LIMIT
	jg		invalidInput
	jmp		validInput

; If input is out of range, display error and re-prompt user
invalidInput:
	mov		edx, OFFSET outOfRange
	call	WriteString
	call	CrLf
	jmp		firstPrompt

; Store valid input
validInput:
	mov		numTerms, eax

; Set loop counter
	mov		ecx, numTerms

; --- displayFibs ---
; Print first Fibonacci number prior to entering loop
	call	CrLf
	mov		eax, secondTerm
	call	WriteDec
	inc		termCounter				; Update term counter
	dec		ecx						; Update loop counter
	mov		al, TAB					; Insert 1 horizontal tab
	call	WriteChar
	cmp		numTerms, TWO_TABS		; If user wants more than 30 terms, add 2nd tab
	jle		justOneTab				; If user wants 30 or fewer terms, skip 2nd tab
	call	WriteChar				; Inserts a 2nd tab if warranted
justOneTab:
	cmp		numTerms, 1				; Check if user only wanted 1 Fibonacci number
	je		ending					; Jump to farewell text if only 1 term desired

; Calculate and print out remaining Fibonacci numbers
printLoop:
	mov		eax, firstTerm
	mov		ebx, secondTerm
	add		eax, ebx				; Calculate next Fibonacci number
	call	WriteDec				; Print Fibonacci number
	inc		termCounter				; Increment term counter
	mov		firstTerm, ebx			; Save terms for next calculation
	mov		secondTerm, eax
	mov		al, TAB					; Insert 1 horizontal tab
	call	WriteChar
	cmp		numTerms, TWO_TABS		; If user wants more than 30 terms, add 2nd tab
	jle		oneTab					; If user wants 30 or fewer terms, skip 2nd tab
	cmp		secondTerm, ONE_TAB		; After 9227465, revert back to 1 tab between terms
	jg		oneTab
	call	WriteChar				; Inserts 2nd tab if warranted
oneTab:
	cmp		termCounter, 5			; Check if printed 5 terms on current line
	je		newline
noNewline:
	loop	printLoop
	jmp		ending

; If printed 5 terms on current line, move cursor to next line
newline:
	call	CrLf
	mov		termCounter, 0			; Reset counter
	jmp		noNewline

;--- farewell ---
; Say farewell to user
ending:
	call	CrLf
	call	CrLf
	mov		edx, OFFSET farewell
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	exit							; exit to operating system
main ENDP		

; (insert additional procedures here)

END main
