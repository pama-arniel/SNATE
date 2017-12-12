;by Jose Arniel Pama

.model large
.stack 256

;START OF DATA SEGMENT
;--------------------------------------------------------
.data
	;general purpose variables
	NEWLINE      DB 0AH,0DH,'$'  ;for printing new line
	inputkey 	 db ? 			 ;holds the value of the key pressed
	screennum  	 db ? 			 ;equal to: 0=quit, 1=title, 2=how to play, 3=game, 4=game over
								 ;determines the screen to go to next  
	;for 'loading' procedure
	loadstring 		db "  Loading...    $"
	completestring	db " Press Enter    $"
	
	;variables for reading 'title.txt'
	TITLE_FILENAME    DB 'title.txt', 00H	
	TITLE_RECORDSTR   DB 1600 DUP('$')  ;length = original length of record + 1 (for $)

	;string variables in title screen
	howtoplaystring	  db " How to Play ", 10, 13, "$"
	startplaystring	  db "Start to Play", 10, 13, "$"
	quitstring 	      db "    QUIT     ", 10, 13, "$"
	
	;snake found at title screen
	tsnake1		db "	                                                     ", 10, 13, "$"
	tsnake2 	db "	                                     ____        /-/|", 10, 13, "$"
	tsnake3     db "	      ______________________________/--0 \__/   /_/ | Letters", 10, 13, "$"
	tsnake4 	db "	     <_T_H_E_B_O_O_K_I_S_H_S_N_A_K_E_____/  \   |^|/|", 10, 13, "$"
	tsnake5 	db "	                                                |_|/", 10, 13, "$"

	;variables for reading 'help.txt'
	INSTRC_FILENAME    DB 'help.txt', 00H	
	INSTRUCTION_STR    DB 1600 DUP('$')  ;length = original length of record + 1 (for $)
	backstring 		   db "> Back", "$"

	;variables for reading 'goal.txt'
	GOAL_FILENAME   DB 'goal.txt', 00H	
	GOAL_STR    	DB 1600 DUP('$')  ;length = original length of record + 1 (for $)
	GOAL_RAWSTRING	DB 1600 DUP('$')  ;goal text with no spaces and punctuations, just letters
									  ;used for generating food and displaying next goal
	RAWGOALLEN 		DW ? 			  ;the length of the copied letters (excluding the spaces or special characters) from GOAL_STR
	nextgoalindex 	db 4 			  ;to initially access the index after 'GOAL' in GOAL_RAWSTRING

	;variables for reading 'hiscore.txt'
	HIGHSCORE_FILENAME  DB 'hiscore.txt', 00H	
	HIGHSCORE_STR    	DB 6 DUP('$')  ;length = original length of record + 1 (for $)
	HIGHSCORE_RAWSTRING DB 6 DUP('$')  ;highscore string with no spaces, just numbers
	highscorenum 		dw ? 		   ;the number form of HIGHSCORE_STR

	;variables for reading a file
	EXPECTEDLEN       DW 1600 			;general expected length for all files of this program
	READ_FH           DW ?      		;file handle for reading
	ERROR_OPEN        DB 'Error in opening file.$'
	ERROR_READ        DB 'Error reading from file.$'
	NO_RECORD_READ    DB 'No record read from file.$'

	;variables for selecting an option	
	select  		  db "> $" 			;indicator for 'select'
	unselect  		  db "  $" 			;to replace '>'
	selectcol 	  	  db ?
	selectrow 		  db ?
	titleconstantcol  db 34 			;constant value of column used title screen
	
	;variables for snake movement 
	rows 		db 254 dup(25) 			;row coordinates of the snake's body
	cols 		db 254 dup(80) 			;column coordinates of the snake's body	
	snakechars 	db 254 dup(254)			;characters at each coordinate of the snake's body
	temprow 	db ? 					;temporary storage for row, when traversing rows array
	tempcol 	db ? 					;temporary storage for col, when traversing rows array

	;variables for randomizing
	letterLowerBound db 65				;equivalent to letter 'A' in ascii
	letterUpperBound db 90 				;equivalent to letter 'Z' in ascii
	foodChar 		db ? 				;the randomized character will be stored here
	foodRow 		db ? 				;row coordinate of food
	foodCol 		db ? 				;col coordinate of food
	isbody	 		db ? 				;set to 1 when coordinates are within snake's body, else 0

	;variables for checking bounds (also used in randomizing)
	up_range	DB 1					;range for row: [1, 23] 
	down_range	DB 23
	left_range	DB 1					;range for col: [1, 44]
	right_range DB 44

	;variables for food
	randfoodlen db ?					;MAXIMUM OF 10 PROPABLE SPAWNED FOODS; to be randomized later
	minfoodlen 	db 4 					;lowerbound of food length
	maxfoodlen  db 10 					;upperbound of food length
	foodRows 	db 10 dup(23) 			;row coordinates of the foods body
	foodCols 	db 10 dup(44) 			;col coordinates of the foods body
	foodChars 	db 10 dup('A') 			;the characters at each coordinate
	blocksquare db 254 					;equals to 'block square' character in extended ascii

	;variables for snake length 
	snakelen 	db 5 							;contains the current length of the snake's body
	score 		dw 0 							;equivalent to snakelen
	goaltext 	db "goal:           ", "$" 		;the goal label
	scoretext 	db "score:          ", "$" 		;the score label
	highscore	db "highscore:      ", "$"		;the highscore label
	scorestr 	db 5 dup(" ") 					;contains the string form of 'score' number
	
	
	;_countdown procedure variable
	gomessage 	db "GO!", "$"

	;variables for key input in _gamescreen
	gameinputkey db ? 
	pastinput 	 db ?

	;variable for pause
	ispaused 		db ? 						;determines when to print paused_msg or clear_pausedmsg
	paused_msg 		db "> Press any arrow key to resume", "$"
	clear_pausedmsg db "                               ", "$"
	
	;variables for game over screen
	islevelcomplete db ? 						;determines when to display "GAME OVER" or "LEVEL COMPLETE"
	lvlcompletemsg 	db "LEVEL COMPLETE", 10, 13, "$"
	gameovermsg 	db "  GAME OVER   ", 10, 13, "$"
	clearGOmsg 		db "              ", 10, 13, "$" 	;so that murag naay animating effect
	playagainstring	db " Play Again  ", 10, 13, "$"
	menustring 	    db "    MENU     ", 10, 13, "$"
	
	snake 	db "                               ",10, 13
			db "                        .-..-. ", 10, 13
	        db "                       (-o/\o-)", 10, 13
	        db "                      /`''``''`\", 10, 13
	        db "                      \ /.__.\ /", 10, 13
	        db "                       \ `--` /", 10, 13
	        db "                        `)  ('", 10, 13
	        db "                     ,  /::::\  ," , 10, 13
	        db "                     |'.\::::/.'|", 10, 13
	        db "                    _|   ;::;   |_", 10, 13
	        db "                   (::)   ||   (::)                       _.", 10, 13
	        db "                     |    ||    |                       _(:)", 10, 13
	        db "                     '.   ||   .'                       /::\", 10, 13
	        db "                       '._||_.'                         \::/", 10, 13
	        db "                        /::::\                         /:::\", 10, 13
	        db "                        \::::/                        _\:::/", 10, 13
	        db "                        /::::\_.._  _.._  _.._  _.._/::::\", 10, 13
	        db "                        \::::/::::\/::::\/::::\/::::\::::/", 10, 13
	        db "                         `''`\::::/\::::/\::::/\::::/`'''", 10, 13
	        db "                              `''`  `''`  `''`  `''`", 10, 13, "$"

	;variables for file writing
	WRITE_FH          DW ?
	ERROR_CREATE      DB 'Error in creating file.$'
	ERROR_WRITE       DB 'Error writing in file.$'
	IMPROPER_WRITE    DB 'Record not written properly.$'


;START OF CODE SEGMENT
;--------------------------------------------------------
.code

;macro for displaying strings
;accepts a parameter called message and print the message using int 21h
;--------------------------------------------------------
display macro message
	mov ah, 09
	lea dx, message
	int 21h
endm

;macro for printing a string with customizable color
;set bl to color attribute first before calling this function
;--------------------------------------------------------
printwithcolor macro message
    lea dx, message

    ;printing the line
    ;mov bl,2  ;color attribute
    mov bh, 00
    mov ah,9 ;interrupt for printing a string
    mov al,0  ;avoiding extra characters
    mov cx, 100
    int 10h   ;printing colors
    int 21h
endm

;macro for closing files
;accepts a parameter called filehandle and closes that file using int 21h
;--------------------------------------------------------
CLOSEFILE MACRO FILEHANDLE
  ;close file handle
  MOV AH, 3EH           ;request close file
  MOV BX, FILEHANDLE    ;file handle
  INT 21H
ENDM

;macro for randomizing a number
;accepts a lowerbound, upperbound, container
;stores into container the generated random number
;--------------------------------------------------------
RANDOMIZE MACRO LOWERBOUND, UPPERBOUND, CONTAINER
 	mov ah, 00H 			;interrupt to get system time 
	int 1ah

	mov ax, dx 				;set seed (declared as global var) to dl

	;TRICKY PART: this is important so that our 4 foods will vary their coordinates
	;since there is no significant difference in the time that the randomize function is called in _spawnfood,
	;the attributes generated tend to be the similar
	mul container				 

	xor dx, dx 				;clear dx
	xor ch, ch 				;clear ch
	mov cl, upperbound		;set cl to upperbound parameter initially
	sub cl, lowerbound 		;subtract cl to get the range of possible values
	div cx 					;finally, divide ax with cx

	mov al, dl 				;dl contains the remainder of the division
	add al, lowerbound 		;add the lowerbound to al to include it in the chances of selection
	mov container, al 		;store to the container the randomized number
ENDM


;start of main
;--------------------------------------------------------
main proc far
	mov ax, @data
	mov ds, ax
	mov es, ax
	mov inputkey, 00
	mov screennum, 1 	 ;preset screennum to 1=title screen

	main_loop:
		cmp screennum, 0 ;meaning it will exit the program
		je exit
		cmp screennum, 1 ;meaning it will proceed to the'title' screen next
		je gototitle
		cmp screennum, 2 ;meaning it will proceed to 'how to play' screen next
		je gotohow
		cmp screennum, 3 ;meaning it will proceed to 'actual game' screen next
		je gotogame
		cmp screennum, 4 ;meaning it will proceed to 'game over' screen next
		je gotogameover
		jmp main_loop

		gototitle:
			call _titlescreen		;sets the next screen to go to after execution
			jmp main_loop

		gotohow:
			call _howtoplayscreen	;sets the next screen to go to after execution
			jmp main_loop

		gotogame:
			call _gamescreen		;sets the next screen to go to after execution
			jmp main_loop

		gotogameover:
			call _gameoverscreen 	;sets the next screen to go to after execution
			jmp main_loop

	exit:
		mov ah, 4ch
		int 21h
main endp

;sets the cursor locations at specified row and column
;dh and dl must be set to desired [row, col] respectively before calling the function
;--------------------------------------------------------
_set_cursor proc near
	mov ah, 02h ;function code to request for set cursor
	mov bh, 00 	;page number 0, i.e. current screen
	int 10h
	ret
_set_cursor endp

;start of _hidecursor
;points the cursor at row 26 (dh = index 25) and col 1 (dl = index 0)
;to hide the blinking cursor from view
;this is to make the screen clean and neat
;--------------------------------------------------------
_hidecursor proc near
	mov ah, 02h
	mov bh, 0
	mov dh, 25
	mov dl, 0
	int 10h
	ret		
_hidecursor endp

;sets the background and foreground of a certain screen
;start of clear screen; sets BH (color attribute) before calling this function
;--------------------------------------------------------
_clearscreen proc near
	MOV		AX, 0600H ;full screen

	;sets black border
	;MOV		BH, 0FH   ;black background (0), white foreground (E)
	MOV 	CX, 0000H ;row:column (0:0)
	MOV		DX, 184FH ;row:column (24:79)
	INT		10H
	ret
_clearscreen endp

;start of _delay
;important in making sure that the displaying of screen attributes does not lag
;also important in setting the speed of the snake
;set bp and si first before calling this function
;--------------------------------------------------------
_delay proc near
	;MOV BP, 4 ;lower value faster
	;MOV SI, 4 ;lower value faster
	
	delay2:
		dec BP
		nop
		jnz delay2
		dec SI
		cmp SI,0
		jnz delay2
	
	RET
_delay endp

;opens a file and issues an error message when there is 
;an error in opening the file
;IMPORTANT: DX must be set first to the filename we want to open
;after calling "openfile", set AX to the filehandle 
;--------------------------------------------------------
openfile proc near
	;open file
	MOV AH, 3DH           		;request open file
	MOV AL, 00            		;read only; 01 (write only); 10 (read/write)
	;LEA DX, READ_FILENAME 		;IMPORTANT! RESET WHEN NEEDED
	INT 21H
	JC _DISPLAY_ERROR1
	;MOV READ_FH, AX 			;IMPORTANT! RESET WHEN NEEDED
	RET

	_DISPLAY_ERROR1:
		display ERROR_OPEN
		display NEWLINE
		RET
openfile endp


;reads a file and issue error messages when there is
;error in reading the file and when file length read is 0
;the ff. MUST BE SET BEFORE CALLING proc: filehandle, recordlen, inputarea
;--------------------------------------------------------
readfile proc near
  ;read file
  MOV AH, 3FH                 ;request read record
  ;MOV BX, READ_FH             ;file handle
  ;MOV CX, EXPECTEDLEN         ;record length
  ;LEA DX, RECORD_STR          ;address of input area
  INT 21H
  JC _DISPLAY_ERROR2
  CMP AX, 00                  ;zero bytes read?
  JE _DISPLAY_ERROR3
  RET

  _DISPLAY_ERROR2:
    display ERROR_READ
    display NEWLINE
    RET

  _DISPLAY_ERROR3:
    display NO_RECORD_READ
    display NEWLINE
    RET
readfile endp

;display the texts in title screen and determines where
;the player wants to go next:
;--------------------------------------------------------
_titlescreen proc near

	call readtitlefile
	call printtitlestrings
	call _loading
	call selection
	ret

_titlescreen endp

;reads what is in 'title.txt'
;--------------------------------------------------------
readtitlefile proc near
	;open 'title.txt'
	LEA DX, TITLE_FILENAME
	call openfile
	MOV READ_FH, AX

	;read what was in READ_FH filehandle (now = 'title.txt')
	MOV BX, READ_FH             ;file handle
  	MOV CX, EXPECTEDLEN         ;record length
  	LEA DX, TITLE_RECORDSTR     ;address of input area
  	call readfile

  	;close 'title.txt'
  	CLOSEFILE READ_FH
	ret
readtitlefile endp

;prints all the strings necessary in the title screen
;--------------------------------------------------------
printtitlestrings proc near
	;write 'SNATE' on screen
	MOV	BH, 0EH   ;black background (0), yellow foreground (E)
  	call _clearscreen
  	mov dh, 0
	mov dl, 5
	call _set_cursor
	display TITLE_RECORDSTR

	;print snake ascii art with cyan color attribute
	mov bl, 0Ah 		  		;color attribute=light green
	printwithcolor tsnake1
	printwithcolor tsnake2
	printwithcolor tsnake3
	printwithcolor tsnake4
	printwithcolor tsnake5

	;set green color for options
	mov bl, 3 				 	;cyan color

	;display 'How to Play'
	mov dh, 15 				 ;set row
	mov dl, titleconstantcol ;set column
	mov selectrow, dh 		 ;select also current x and y 
	mov selectcol, dl 		 ;coordinate of 'select' indicator
	call _set_cursor 	     ;set cursor
	printwithcolor howtoplaystring  ;print on that coordinate

	;display 'Start to Play'
	mov dh, 17
	mov dl, titleconstantcol
	call _set_cursor
	printwithcolor startplaystring

	;display 'QUIT'
	mov dh, 19
	mov dl, titleconstantcol
	call _set_cursor
	printwithcolor quitstring

	ret
printtitlestrings endp

;terminates the 'loading' function
;--------------------------------------------------------
_terminate proc near
	;set cursor at [22, 34]
	mov dh, 22
	mov dl, 34
	call _set_cursor

	;display "Press Enter"
	display completestring

	;set cursor
	mov dh, 13
	mov dl, 00
	call _set_cursor

	ret
_terminate endp

;displays the loading bar and prints "Press Enter" after
;--------------------------------------------------------
_loading proc near
	mov bl, 00  ;stores the current col

	;set cursor
	mov dh, 22 ;row 22, CAN BE RESET
	mov dl, 34 ;col 34, CAN BE RESET
	call _set_cursor

	;display message
	push bx
	mov bl, 0ch ;light red color
	printwithcolor loadstring
	pop bx

	iterate:
		;set cursor
		mov dh, 23 	;row = 23
		mov dl, bl 	;col = bl
		call _set_cursor

		;display char from register
		mov al, '.' 		;print ...
		mov ah, 09h
		mov bh, 00 				;page number 0
		push bx
		mov bl, 0Ch		 		;black background, light red foreground
		mov cx, 1 				;one char only
		int 10h
		pop bx

		;hides cursor
		call _hidecursor

		;call delay for loading
		mov bp, 5
		mov si, 2
		call _delay

		inc bl
		cmp bl, 80 			;check if 80 (in dec)
		jne iterate
		call _terminate 	;if equal exit
	ret
_loading endp

;sets '>' pointer to proper cursor
;DOES THE FOLLOWING: can quit (sets screennum=1)
;can go to 'How to play' (sets screennum=2)
;can go to 'actual game' (sets screenum=3)
;--------------------------------------------------------
selection proc near
	;determines where the '>' indicator should be set
	;and performs necessary actions respectively
	setindicator:
		mov inputkey, 00 ;para ka-usa ra mureact ang pag-key press

		;display 'select' indicator
		mov dh, selectrow
		mov dl, selectcol
		sub dl, 2  		;so that it will not overwrite 'How to play' etc.
		call _set_cursor
		display select
		call _hidecursor
		mov bp, 2
		mov si, 2
		call _delay

		;get key
		call _getkey
		cmp inputkey, 48h ;up
		je UP
		cmp inputkey, 50h ;down
		je DOWN
		cmp inputkey, 1ch ;enter
		je ENTER
		jmp setindicator

		UP:
			call _beepsound
			cmp selectrow, 15
			jbe setindicator  ;if equal to 13, do nothing

			;if above 15 (e.g. 17, 19), deselect
			;and reset row to (selectrow - 2)
			call deselect
			mov al, selectrow
			sub al, 2
			mov selectrow, al
			jmp setindicator

		DOWN:
			call _beepsound
			cmp selectrow, 19
			jae setindicator

			;if below 19 (e.g. 17, 15), deselect
			;and reset row to (selectrow + 2)
			call deselect
			mov al, selectrow
			add al, 2
			mov selectrow, al
			jmp setindicator

		ENTER:
			call _beepsound
			;3 possibilities: naa sa how to play, start, quit
			cmp selectrow, 15   ;meaning it's pointing to 'how to play'
			je howto 			;if equal to 15, go to 'how to play' screen
			cmp selectrow, 17 	;meaning it's pointing to 'start'
			je game 			;if equal to 17, go to 'actual game' screen
			cmp selectrow, 19 	;meaning it's pointing to 'quit'
			je finish   		;if equal to 19, exit
			jmp setindicator 	;else, loop balik

	howto:
		mov screennum, 2 ;equal to 'how to play'
		ret

	game:
		mov screennum, 3 ;equal to 'actual game'
		ret

	finish:
		mov screennum, 0 ;equal to 'quit'
		ret
selection endp

;prints "  " on previous [selectrow, selectcol] to hide '>'
;--------------------------------------------------------
deselect proc near
	mov dh, selectrow
	mov dl, selectcol
	sub dl, 2  					;so that it will not overwrite 'how to play' etc.
	call _set_cursor
	display unselect
	ret
deselect endp

;from http://www.intel-assembler.it
;produces the beep sound (change the DX or BX to produce other sounds)
;--------------------------------------------------------
_beepsound proc near       
     MOV     DX,500           ; Number of times to repeat whole routine.

     MOV     BX,8089          ; Frequency value.

     MOV     AL, 10110110B    ; The Magic Number (use this binary number only)
     OUT     43H, AL          ; Send it to the initializing port 43H Timer 2.

     NEXT_FREQUENCY:          ; This is were we will jump back to 2000 times.

     MOV     AX, BX           ; Move our Frequency value into AX.

     OUT     42H, AL          ; Send LSB to port 42H.
     MOV     AL, AH           ; Move MSB into AL  
     OUT     42H, AL          ; Send MSB to port 42H.

     IN      AL, 61H          ; Get current value of port 61H.
     OR      AL, 00000011B    ; OR AL to this value, forcing first two bits high.
     OUT     61H, AL          ; Copy it to port 61H of the PPI Chip
                              ; to turn ON the speaker.

     MOV     CX, 100          ; Repeat loop 100 times
     DELAY_LOOP:              ; Here is where we loop back too.
     LOOP    DELAY_LOOP       ; Jump repeatedly to DELAY_LOOP until CX = 0


     INC     BX               ; Incrementing the value of BX lowers 
                              ; the frequency each time we repeat the
                              ; whole routine

     DEC     DX               ; Decrement repeat routine count

     CMP     DX, 0            ; Is DX (repeat count) = to 0
     JNZ     NEXT_FREQUENCY   ; If not jump to NEXT_FREQUENCY
                              ; and do whole routine again.

                              ; Else DX = 0 time to turn speaker OFF

     IN      AL,61H           ; Get current value of port 61H.
     AND     AL,11111100B     ; AND AL to this value, forcing first two bits low.
     OUT     61H,AL           ; Copy it to port 61H of the PPI Chip
                              ; to turn OFF the speaker.
     RET
_beepsound endp

;start of _getkey; gets key input from user
;sets 'inputkey' and 'gameinputkey' variables to key pressed
;--------------------------------------------------------
_getkey proc near
	mov	ah, 01H		;check for input
	int	16H

	jz	_return

	mov	ah, 00H		;get input	mov ah, 10H; int 16H
	int	16H
	
	mov	inputkey, ah
	mov gameinputkey, ah

	_return:
		ret
_getkey endp

;reads what is in 'help.txt' and store the contents to INSTRUCTION_STR
;--------------------------------------------------------
readinstructionfile proc near
	;open 'help.txt'
	LEA DX, INSTRC_FILENAME
	call openfile
	MOV READ_FH, AX

	;read what was in READ_FH filehandle (now = 'help.txt')
	MOV BX, READ_FH             ;file handle
  	MOV CX, EXPECTEDLEN         ;record length
  	LEA DX, INSTRUCTION_STR     ;address of input area
  	call readfile

  	;close 'help.txt'
  	CLOSEFILE READ_FH
	ret
readinstructionfile endp

;displays the instruction; player can go back to the title screen
;--------------------------------------------------------
_howtoplayscreen proc near
	
	;read instruction file
	call readinstructionfile

	;write the instruction on screen
	MOV		BH, 0EH   ;black background (0), yellow foreground (E)
  	call _clearscreen
  	mov dh, 00
	mov dl, 00
	call _set_cursor
	display INSTRUCTION_STR
	
	;display '> Back'
	mov dh, 23 				 ;set row=23
	mov dl, 36 				 ;set column=36
	call _set_cursor 	     ;set cursor
	display backstring  	 ;print on that coordinate
	call _hidecursor 		 ;hide blinking cursor

	;sets screennum to 1 (title screen) when ENTER key is pressed
	waitforenter:
		mov inputkey, 00 	;para ka-usa ra mureact ang pag-key press

		;get key
		call _getkey
		cmp inputkey, 1ch 	;check if inputkey==enter
		je ENTER1 			;if equal, jump to ENTER1
		jmp waitforenter 	;else, wait for enter

		ENTER1:
			call _beepsound  ;beep sound
			mov screennum, 1 ;equal to 'title' screen
			ret
_howtoplayscreen endp

;start of the game screen
;--------------------------------------------------------
_gamescreen proc near
	
	call readgoalfile 		;read from 'goal.txt'
	call readhighscorefile 	;read from 'hiscore.txt'
	call _countdown 		;display countdown timer before starting game

	;reset the following values (in case player choose to play again)
	mov snakelen, 5
	mov score, 0
	mov nextgoalindex, 4
	
	__PRESETS:
		;initialize starting body of snake :)

		;initialize rows at 12
		mov rows[0], 12
		mov rows[1], 12
		mov rows[2], 12
		mov rows[3], 12
		mov rows[4], 12
		mov temprow, 12

		;initialize cols from 36-40
		mov cols[0], 22
	    mov cols[1], 21
	    mov cols[2], 20
	    mov cols[3], 19
	    mov cols[4], 18
	    mov tempcol, 22

	    ;initial food characters 
	    mov al, blocksquare
	    mov snakechars[4], al
	    mov snakechars[3], al
	    mov snakechars[2], al
	    mov snakechars[1], al
	    mov snakechars[0], 232 ;head is equal to the theta symbol

	    call _spawnfood

		;set movement rightwards initially
		mov gameinputkey, 4DH
		mov pastinput, 4DH

		;initially set pause and level complete booleans to false
		mov ispaused, 0
		mov islevelcomplete, 0

	__ITERATE:
		call 	__process

		ARROW_UP:
			CMP 	gameinputkey, 48H   ;UP.
		    JNE  	ARROW_DOWN	 		;if not arrow up, go to ARROW_DOWN
		    call 	_arrow_up 			;call action for arrow up
		    mov 	ispaused, 0 		;set ispaused to false when arrow key is pressed
		    JMP 	__ITERATE 			;iterate again

	    ARROW_DOWN: 
		    CMP 	gameinputkey, 50H   ;DOWN.
		    JNE  	ARROW_LEFT 			;if not arrow down, go to ARROW_LEFT
		    call 	_arrow_down 		;call action for arrow down
		    mov 	ispaused, 0 		;set ispaused to false when arrow key is pressed
		    JMP 	__ITERATE 			;iterate again

	  	ARROW_LEFT:
		    CMP 	gameinputkey, 4BH   ;LEFT.
		    JNE  	ARROW_RIGHT 		;if not arrow left, go to ARROW_RIGHT
		    call 	_arrow_left 		;call action for arrow left
		    mov 	ispaused, 0 		;set ispaused to false when arrow key is pressed
		    JMP 	__ITERATE 			;iterate gain

	    ARROW_RIGHT:
		    CMP 	gameinputkey, 4DH   ;RIGHT.
		    JNE  	SPACE_KEY 			;if not arrow right, go to SPACE_KEY
		    call 	_arrow_right 		;call action for arrow right
		    mov 	ispaused, 0 		;set ispaused to false when arrow key is pressed
		    JMP 	__ITERATE 			;iterate again

		SPACE_KEY:
			CMP 	gameinputkey, 39h 	;space bar
			JNE 	ESC_KEY 			;if not space bar, go to ESC_KEY
			mov 	ispaused, 1 		;if spacebar, set ispaused to true
			JMP 	__ITERATE 			;iterate again


		ESC_KEY:
			CMP 	gameinputkey, 01H   ;ESC.
	    	JNE  	__ITERATE 			;if not equal to any of the keys, iterate again
	    	mov 	screennum, 4 		;set screenum to game over screen
	    	call 	_beepsound 			;call beep
	    	ret							;go out of game screen to go to game over screen
_gamescreen endp

;read the goal text (a sentence, etc.) to be displayed on the game screen
;extract also the letters from the read file and store in GOAL_RAWSTRING
;--------------------------------------------------------
readgoalfile proc near
	;open 'goal.txt'
	LEA DX, GOAL_FILENAME
	call openfile
	MOV READ_FH, AX

	;read what was in READ_FH filehandle (now = 'goal.txt')
	MOV BX, READ_FH         ;file handle
  	MOV CX, EXPECTEDLEN     ;record length
  	LEA DX, GOAL_STR     	;address of input area
  	call readfile

  	;close 'goal.txt'
  	CLOSEFILE READ_FH

  	;copy only the letters in GOAL_STR (used for generating food and displaying next goal)
  	lea si, GOAL_STR 		;so that it will not read the 'GOAL' label
  	lea di, GOAL_RAWSTRING
  	mov bx, 0 				;to be set to RAWGOALLEN later

  	do_copy:
  		;stop if current si is '$'
  		mov al, [si]
  		cmp al, '$'
  		je stop

  		;check if current char is within [A, Z]
  		cmp al, 'A' 		;check if greater than 'A'
  		jb proceed 			;if below 'A', don't copy; proceed
  		cmp al, 'Z' 		;check if lesser than 'Z'
  		ja proceed 			;if above 'Z', don't copy; proceed
  		mov [di], al		;if within [A-Z], copy
  		inc di 				;proceed to next di
  		inc bx 				;increase bx (RAWGOALLEN)

  		proceed:
  			inc si  		;increment si
  			jmp do_copy 	;repeat until [si]=='$'

  	stop:
  		mov RAWGOALLEN, bx  ;set RAWGOALLEN to bx
  		ret
readgoalfile endp

;displays "4, 3, 2, GO!" before starting the game
;--------------------------------------------------------
_countdown proc near
	;readies screen
	mov	ax, 0600H ;full screen
	mov	bh, 07H   ;black background (0), white foreground (7)
	mov cx, 0000H ;row:column (0:0)
	mov	dx, 184FH ;row:column (24:79)
	int	10H

	mov cl, 4
	countdown:
		mov dh, 13 	  	;row = 13
		mov dl, 38		;column = 38
		call _set_cursor

		cmp cl, 1 		;display 'GO!' when equal to 1
		je go

		;else display counter or number
		mov dl, cl 		;store cl (the current number) at dl 
		add dl, 48  	;to convert to number ascii equivalent
		mov ah, 02 		;display what is in dl
		int 21h

		call _hidecursor
		jmp countdown_delay

		go:
			display gomessage
			call _hidecursor

		countdown_delay:
			mov BP, 15 ;lower value faster
			mov SI, 15 ;lower value faster
			call _delay
		loop countdown

	ret
_countdown endp

;start of __process
;--------------------------------------------------------
__process proc near
	call _game_clearscreen 	;clear screen	
	call _printsnake 		;print snake
	call _printfood 		;print food
	call _printscorearea 	;print the texts in score area
	call _checkcollision 	;check collision
	; call _hidecursor 		;hide blinking cursor
	mov BP, 9 				;lower value faster
	mov SI, 3 				;lower value faster
	call _delay 			;call delay
	call _getkey 			;get key
	call _setinputkey 		;set gameinputkey and pastinput to appropriate keys
	ret
__process endp

;start of _game_clearscreen; readies the actual game screen
;--------------------------------------------------------
_game_clearscreen proc	near
	mov	ax, 0600H ;full screen

	;sets blue border
	mov	bh, 90H   ;light blue background (9), black foreground (0)
	mov cx, 0000H ;row:column (0:0)
	mov	dx, 184FH ;row:column (24:79)
	int	10H

	;sets playground for snake
	mov	bh, 0EH   ;black background (0), yellow foreground (E)
	mov cx, 0101H ;row:column (1:1)
	mov	dx, 172CH ;row:column (23:44)
	int	10H

	;sets the box for goal
	mov	bh, 0EH   ;black background (0), yellow foreground (E)
	mov cx, 012EH ;row:column (1:46)
	mov	dx, 0C4EH ;row:column (12:78)
	int	10H

	;sets the box for high score, score, and next letter
	mov	bh, 0EH   ;black background (0), yellow foreground (E)
	mov cx, 0E2EH ;row:column (14:46)
	mov	dx, 174EH ;row:column (23:78)
	int	10H

	;writes the goal text on screen
  	mov dh, 0
	mov dl, 46
	call _set_cursor
	display GOAL_STR

	ret
_game_clearscreen endp

;prints the body of the snake; traverses "rows", "cols", and "snakechars" 
;--------------------------------------------------------
_printsnake proc near
	xor ch, ch 		;clear ch
	mov cl, snakelen
	mov si, 0

	print:
		;set current row and col coordinates
		mov dh, rows[si]
		mov dl, cols[si]
		call _set_cursor

		;print char (stored in al) at current coordinates
		push cx
		mov ah, 09h 			;request display
		mov al, snakechars[si] 	;snake char
		mov bh, 00 				;page number 0
		mov bl, 03h		 		;black background, cyan foreground
		mov cx, 1 				;one char only
		int 10h 				;call interrupt service
		pop cx

		inc si 					;increment si
		loop print  			;repeat until cl==0

	call _hidecursor 			;hide blinking cursor
	ret
_printsnake endp

;generates 'randfoodlen' number of foods (with random attributes: row, col, letter) when called
;--------------------------------------------------------
_spawnfood proc near
	;randomize food length first
	randomize minfoodlen, maxfoodlen, randfoodlen

	mov si, 0 ;start index of foodChars
	jmp randomize_attribs
	
	terminate:
		ret

	randomize_attribs:
		mov al, randfoodlen ;set randfoodlen to al
		xor ah, ah 			;clear ah
		cmp si, ax 			;check if si is already equal to randfoodlen (since traversing array is zero-based)
		je terminate 		;if equal, terminate

		;else, randomize attributes
		random:
			randomize up_range, down_range, foodRow 				;randomize food's row coordinate
			randomize left_range, right_range, foodCol 				;randomize food's column coordinate
			randomize letterLowerBound, letterUpperBound, foodChar 	;randomize character at those coordinates

			call _checkifnotbody 	;check if coordinates are within snake's body
			cmp isbody, 1 			;if yes, randomize again
			je random

		;else, set these attributes to current foodChars index
		set:
			;set randomized row to current foodRows index
			mov dh, foodRow
			mov foodRows[si], dh

			;set randomized column to current foodCols index
			mov dl, foodCol
			mov foodCols[si], dl

			;set randomized char to current foodChars index
			cmp si, 0				
			jne not_firstfood			;if foodChars index is not 0, set char according to the next goal
			mov al, nextgoalindex 		;to access next goal
			xor ah, ah 					;clear ah value, because we will use ax
			mov bx, ax 					;use bx to get what is in index 'nextgoalindex'				
			mov al, GOAL_RAWSTRING[bx] 	;store next goal char to al
			mov foodChars[si], al 		;store next goal to foodChars[0] 
			inc si 						;increase foodChars index
			jmp randomize_attribs 		;repeat

			not_firstfood:
				mov al, foodChar 		;else, set al to randomized foodChar
				mov foodChars[si], al 	;set randomize foodChar to current foodChars index (except at index zero)
				inc si 					;increase foodChars index
				jmp randomize_attribs 	;repeat
_spawnfood endp

;sets bool variable isbody to true if located at snake's body
;--------------------------------------------------------
_checkifnotbody proc near
	mov bl, 0			;start at index 0
	xor bh, bh 			;clear value in bh since we will use in traversing the coordinates of the snake's body
	mov cl, snakelen 	;counter = snakelen; for traversing the snake's body
	xor ch, ch 			;clear ch

	traverse_snake:
		mov dh, rows[bx] 
		cmp dh, foodRow ;compare randomized food row coord with current row of snake's body
		jne travnext 	;if not equal, traverse next

		mov dl, cols[bx] 
		cmp dl, foodCol ;compare randomized food col coord with current col of snake's body
		jne travnext 	;if not equal, traverse next

		true: 			;if both are equal, stop
		mov isbody, 1 	;set isbody to true
		ret	

		travnext: 		;traverse to next index
		inc bx 			;increment bx
	loop traverse_snake ;repeat until bx == (snakelen-1)

	;if every snake body's coord is checked
	;and all of them are not equal
	false:
	mov isbody, 0		;set isbody to false
	ret

_checkifnotbody endp

;prints the foods on the screen in light red color
;--------------------------------------------------------
_printfood proc near
	xor ch, ch 				;clear ch
	mov cl, randfoodlen 		
	mov si, cx 				;start at last index of foodChars
	dec si 					;dec si by 1 since array is zero-based

	print_food:

		;else, set cursor to current food coordinates
		mov dh, foodRows[si]	;set dh to current foodRow
		mov dl, foodCols[si]	;set dl to current foodCol
		call _set_cursor
		
		;print char (stored in al) at current coordinates
		push cx
		mov ah, 09h 			;request display
		mov al, foodChars[si] 	;food char
		mov bh, 00 				;page number 0
		mov bl, 0ch		 		;black background, light red foreground
		mov cx, 1 				;one char only
		int 10h 				;call interrupt service
		pop cx

		dec si 				;decrement si
	 	loop print_food 	;repeat until si == 0
	
	call _hidecursor 		;hide blinking cursor
	ret
_printfood endp

;reads what is in 'hiscore.txt'
;--------------------------------------------------------
readhighscorefile proc near
	;open 'hiscore.txt'
	LEA DX, HIGHSCORE_FILENAME
	call openfile
	MOV READ_FH, AX

	;read what was in READ_FH filehandle (now = 'hiscore.txt')
	MOV BX, READ_FH             ;file handle
  	MOV CX, 6         			;record length = 6
  	LEA DX, HIGHSCORE_STR     	;address of input area
  	call readfile

  	;close 'hiscore.txt'
  	CLOSEFILE READ_FH

  	;copy only the numbers from HIGHSCORE_STR (for proper display format)
  	lea si, HIGHSCORE_STR
  	lea di, HIGHSCORE_RAWSTRING

  	copy_iteration:
  		;stop if current si is '$'
  		mov al, [si]
  		cmp al, '$'
  		je stop2

  		;check if equal to space
  		cmp al, ' '
  		je proceed4
  		
  		;if not space, then copy
  		mov [di], al			;mov al to current di
  		inc di 					;proceed to next di

  		proceed4:
  			inc si 				;proceed to next si
  			jmp copy_iteration 	;repeat

  	stop2:
		ret
readhighscorefile endp

;transforms "score" to its string form and
;prints that string to the set location of cursor
;set dh and dl first before calling this function
;--------------------------------------------------------
printscoretext proc near
	mov 	[scorestr+5], '$' 	;"scorestr" is a global variable
	lea 	si, [scorestr+5] 	;5 is the actual max length of score (6 - 1 for '$')
	
	mov 	ax, score 			;"score" is a global variable
	mov 	bx, 10 				;used in dividing ax

	asc_loop:
		mov 	dx,0            ;clear dx prior to dividing dx:ax by bx
        DIV 	BX              ;DIV AX/10
        ADD 	DX,48           ;ADD 48 TO REMAINDER TO GET ASCII CHARACTER OF NUMBER 
        dec 	si              ;store characters in reverse order
        mov 	[si],dl
        CMP 	AX,0            
        je 		print_num       ;IF AX=0, END OF THE PROCEDURE
    jmp asc_loop            	;ELSE REPEAT
    ;end of asc_loop

    print_num:
    	; mov 	dh, 17 			;set row = 17
    	; mov 	dl, 47			;set col = 47
    	; call 	_set_cursor 	;set cursor

    	;set the location of scoretext before this
    	display scoretext 	;display "SCORE: " label

    	;display string form of 'score'
    	mov 	ah, 9
    	mov 	dx, si 			; print string starting at last si location
    	int 	21h
    	ret
printscoretext endp

;determines if key is still paused
;if paused, display "Press any arrow to continue" on game screen
;else, clear "paused_msg"
;--------------------------------------------------------
_printpause proc near
	;set cursor for printing paused_msg
	mov 	dh, 22 				;set row = 22
    mov 	dl, 47				;set col = 47
    call 	_set_cursor 		;set cursor

	cmp 	ispaused, 1 		;check if ispaused is true
	jne  	_notpaused 			;if not true, clear paused_msg
	display paused_msg 		 	;display message
	ret

    _notpaused:
    	display clear_pausedmsg
    	ret	
_printpause endp

;start of _printscorearea; prints the scores on the score area or box
;--------------------------------------------------------
_printscorearea proc near
	;print highscore
	mov 	dh, 15 				;set row = 15
    mov 	dl, 47				;set col = 47
    call 	_set_cursor 		;set cursor
    display highscore 			;display the "HIGHSCORE: " label
    display HIGHSCORE_RAWSTRING ;print what was read from 'hiscore.txt'

	;print current score
	mov 	dh, 17 			;set row = 17
    mov 	dl, 47			;set col = 47
    call 	_set_cursor 	;set cursor
	call 	printscoretext

	;print current letter goal
	mov 	dh, 19 				;set row = 19
    mov 	dl, 47				;set col = 47
    call 	_set_cursor 		;set cursor
    display goaltext 			;display "GOAL: " label
	xor bx, bx 					;clear bx
	mov bl, nextgoalindex 		;store nextgoalindex to bl
	mov dl, GOAL_RAWSTRING[bx] 	;store to dl the current letter goal
	mov ah, 02h					;interrupt to print what is in dl
	int 21h 					;print what is in dl
	
	;print paused_msg if paused
	call _printpause
	call _hidecursor 			;hide blinking cursor
	ret
_printscorearea endp

;checks for collision between food and snake body
;--------------------------------------------------------
_checkcollision proc near
	;set cursor location to head of snake
	mov dh, rows[0]
	mov dl, cols[0]
	call _set_cursor

	;get values at that location
	mov ah, 08h
	mov bh, 00
	int 10h

	call _hidecursor 			;hide cursor

	;if the body is in there, game over (Snate bumps to itself)
	mov ah, blocksquare 		;store blocksquare val to ah
	cmp al, ah 					;compare if al equal to block square
	je game_over	 			;if yes, game over

	;else, continue
	xor bx, bx 					;clear bx
	mov bl, nextgoalindex 		;store nextgoalindex to bl

	cmp bx, RAWGOALLEN 			;check if nextgoalindex is still less than RAWGOALLEN
	jae level_complete 			;if above or equal, level_complete

	;else, continue
	mov dl, GOAL_RAWSTRING[bx] 	;store to dl the current letter goal

	;ensure that al is within [A, Z]; if not, do nothing
	cmp al, 'A'
	jb no_collision
	cmp al, 'Z'
	ja no_collision

	;if within [A, Z], compare if equal to current goal
	cmp al, dl
	je update_stuff 			;if equal to current goal, update stuff
	jne game_over 				;else, exit

	update_stuff:
		inc score 				;increase score
		inc snakelen 			;increase snake's length
		inc nextgoalindex 		;update next goal index
		call _spawnfood 		;spawn foods again
		ret
		
	game_over:
		mov gameinputkey, 01h 	;set to esc so that it can go to the game over screen
		mov islevelcomplete, 0 	;set islevelcomplete to false
		ret

	level_complete:
		mov gameinputkey, 01h 	;set to esc so that it can go to the game over screen
		mov islevelcomplete, 1  ;set islevelcomplete to true

	no_collision:
		ret
_checkcollision endp

;sets gameinputkey to appropriate key to achieve the ff:
;a) if pastinput is up, player cannot go DOWN
;b) if pastinput is down, player cannot go UP
;c) if pastinput is left, player cannot go RIGHT
;d) if pastinput is right, player cannot go LEFT
;-------------------------------------------
_setinputkey proc near
	mov al, gameinputkey

	set_up:
		cmp al, 48H 			;compare if input key is up = 48h
		jne set_down 			;if not equal, go to "set_down"
		cmp pastinput, 50H 	 	;check if pastinput is down = 50h
		je same 				;if equal, go to "same"
		jne movenew 			;if not equal, go to "movenew"

	set_down:
		cmp al, 50H 			;compare if input key is down = 50h
		jne set_left 			;if not equal, go to "set_left"
		cmp pastinput, 48H 		;check if pastinput is up = 48h
		je same 				;if equal, go to "same"
		jne movenew 			;if not equal, go to "movenew"

	set_left:
		cmp al, 4BH 			;compare if input key is left = 4bh
		jne set_right 			;if not equal, go to "set_right"
		cmp pastinput, 4DH 		;check if pastinput is right = 4dh
		je same 				;if equal, go to "same"
		jne movenew 			;if not equal, go to "movenew"
	
	set_right:
		cmp al, 4DH   			;compare if input key is right = 4dh
		jne set_spacebar 		;if not equal, go to "set_spacebar"
		cmp pastinput, 4BH 		;check if pastinput is left = 4bh
		je same 				;if equal, go to "same"
		jne movenew 			;if not equal, go to "movenew"

	set_spacebar:
		cmp al, 39H 			;compare if input key is spacebar = 39h
		jne set_escape 			;if not equal, go to "set_escape"
		mov gameinputkey, 39h 	;if equal, set gameinputkey to 39h to pause
		ret 					;return

	set_escape:
		cmp al, 01H 			;check if equal to ESC = 01h
		jne movenew 			;if not equal, go to "movenew"
		
		mov gameinputkey, 01h 	;else, set gameinputkey to 01h
		ret

	;set pastinput to gameinputkey
	movenew:
		mov dl, gameinputkey 	;it is important to set the past input key
		mov pastinput, dl   	;because it is important in moving the snake later
		ret

	;set gameinputkey to pastinput
	same:
		mov dl, pastinput
		mov gameinputkey, dl
		ret

_setinputkey endp

;start of _arrow_up; if arrow up is pressed, update snake head coordinates
;--------------------------------------------------------
_arrow_up proc near
	mov dh, rows[0] 		;store rows[0] to dh
	mov temprow, dh 		;store prev rows[0] to temprow; used for updating rows[1] to rows[snakelen]
	mov dl, cols[0] 		;store prev rows[0] to temprow; used for updating cols[1] to cols[snakelen]
	mov tempcol, dl

	;check if new possible rows[0] is equal to up_range
	mov al, up_range
	cmp al, dh 				;compare up_range to new possible rows[0] value
	je _RESET_Y1 			;if equal, reset to down_range
	dec dh 					;else, decrement rows[0]
	mov rows[0], dh 		;update rows[0] to new value
	jmp finish1

	_RESET_Y1:
		mov al, down_range
		mov rows[0], al 	;set rows[0] to down_range value
		jmp finish1

	finish1:
		call transfer_updates 	;update cols and rows arrays according to change in head (at index 0)
		ret
_arrow_up endp

;start of _arrow_down; if arrow down is pressed, update snake head coordinates
;--------------------------------------------------------
_arrow_down proc near
	mov dh, rows[0] 			;store rows[0] to dh
	mov temprow, dh 			;store prev rows[0] to temprow for updating rows[1] to rows[snakelen]
	mov dl, cols[0] 			;store prev rows[0] to temprow; used for updating cols[1] to cols[snakelen]
	mov tempcol, dl

	;check if new possible rows[0] is equal to down_range
	mov al, down_range
	cmp al, dh 					;compare down_range to new possible rows[0] value
	je _RESET_Y2 				;if equal, reset to up_range
	inc dh 						;else, increment rows[0]
	mov rows[0], dh 			;update rows[0] to new value
	jmp finish2

	_RESET_Y2:
		mov al, up_range
		mov rows[0], al 		;set rows[0] to down_range value
		jmp finish2

	finish2:
		call transfer_updates 	;update cols and rows arrays according to change in head (at index 0)
		ret
	
_arrow_down endp

;start of _arrow_left; if arrow left is pressed, update snake head coordinates
;--------------------------------------------------------
_arrow_left proc near
	mov dl, cols[0] 	;store cols[0] to dl
	mov tempcol, dl 	;store prev cols[0] to tempcol for updating cols[1] to cols[snakelen]
	mov dh, rows[0] 	;store prev rows[0] to temprow for updating rows[1] to rows[snakelen]
	mov temprow, dh

	;check if new possible cols[0] is equal to left_range
	mov al, left_range
	cmp al, dl 			;compare left_range to new possible cols[0] value
	je _RESET_X3 		;if equal, reset to right_range
	dec dl 				;else, decrement cols[0]
	mov cols[0], dl 	;update cols[0] value
	jmp finish3

	_RESET_X3:
		mov al, right_range 
		mov cols[0], al ;set cols[0] to right_range
		jmp finish3

	finish3:
		call transfer_updates 	;update cols and rows arrays according to change in head (at index 0)
		ret
_arrow_left endp

;start of _arrow_right; if arrow right is pressed, update snake head coordinates
;--------------------------------------------------------
_arrow_right proc near	
	mov dl, cols[0] 	;store cols[0] to dl
	mov tempcol, dl 	;store prev cols[0] to tempcol for updating cols[1] to cols[snakelen]
	mov dh, rows[0] 	;store prev rows[0] to temprow for updating rows[1] to rows[snakelen]
	mov temprow, dh

	;check if new possible cols[0] is equal to right_range
	mov al, right_range
	cmp al, dl 			;compare right_range to new possible cols[0] value
	je _RESET_X4 		;if equal, reset to left_range
	inc dl 				;else, increment cols[0]
	mov cols[0], dl 	;update cols[0] value
	jmp finish4

	_RESET_X4:
		mov al, left_range 
		mov cols[0], al ;set cols[0] to left_range
		jmp finish4

	finish4:
		call transfer_updates 	;update cols and rows arrays according to change in head (at index 0)
		ret
_arrow_right endp

;updates rows[1] to rows[snakelen] values according to temprow (initially the update in rows[0])
;updates cols[1] to cols[snakelen] values according to tempcol (initially the update in cols[0])
;used in responding to the arrows keys, so that the snake will have a moving effect
;called after updating rows[0] or cols[0]
;--------------------------------------------------------
transfer_updates proc near
	mov si, 1 					;since we start from 1 (since index 0 is already updated)
	do_update:
		mov dh, rows[si] 		;store to dh the current value at si
		mov al, temprow 		;store temprow at al
		mov rows[si], al 		;update si loc with the curr value at temprow
		mov temprow, dh 		;update temprow with curr value at si so that the next si will have access to this value

		mov dl, cols[si] 		;store to dh the current value at si
		mov al, tempcol 		;store tempcol at al
		mov cols[si], al 		;update si loc with the curr value at tempcol (in al)
		mov tempcol, dl 		;update tempcol with curr value at si so that the next si will have access to this value

		mov al, snakelen		;store snakelen at al
		xor ah, ah 				;make sure ah has no value
		cmp si, ax 				;check if si is equal to snakelen (in ax)
		je _done 				;if yes, finish

		inc si 					;else, continue and increment si
	jmp do_update

	_done:
		ret
transfer_updates endp

;display the texts in game over screen and determines where
;the player wants to go next: play again = 3 (game screen), quit = 1 (title screen)
;--------------------------------------------------------
_gameoverscreen proc near
	call converthighscoretonum

	;if highscorenum is >= score, jmp to proceed3
	mov ax, score
	cmp highscorenum, ax
	jae proceed3

	;else, write new highscore to 'highscore.txt'
	newhighscore:
		CALL CREATEFILE
		CALL WRITEFILE
		CLOSEFILE WRITE_FH

	proceed3:
		call printgameoverstrings
		call gameoverselection
	ret
_gameoverscreen endp

;creates file and sets file handle for writing
;issues an error message when no file is created
;--------------------------------------------------------
CREATEFILE PROC NEAR
  MOV AH, 3CH           		;request create file
  MOV CX, 00       				;normal attribute
  LEA DX, HIGHSCORE_FILENAME  	;load path and file name
  INT 21H
  JC  _ERROR1           		;if there's error in creating file, carry flag = 1, otherwise 0
  MOV WRITE_FH, AX 				;else set ax to filehandle
  RET

  _ERROR1:
    DISPLAY ERROR_CREATE
    DISPLAY NEWLINE
    RET
CREATEFILE ENDP

;writes to a file and display errors like:
;a) error writing in a file
;b) length of record written does not match with the actual length
;--------------------------------------------------------
WRITEFILE PROC NEAR
  MOV AH, 40H           ;request write record
  MOV BX, WRITE_FH      ;set bx to write file handle
  MOV CX, 5      		;record length = 5
  LEA DX, scorestr  	;address of "scorestr" to be written on file
  INT 21H
  JC  _ERROR2           ;if carry flag = 1, there's error in writing (nothing is written)
  CMP AX, 5      		;after writing, set AX to size of chars nga na write
  JNE _ERROR3 			;if not equal, display IMPROPER_WRITE
  RET
  
  _ERROR2:
    DISPLAY ERROR_WRITE
    DISPLAY NEWLINE
    RET

  _ERROR3:
    DISPLAY IMPROPER_WRITE
    DISPLAY NEWLINE
    RET
WRITEFILE ENDP

;converts a string (i.e. HIGHSCORE_STR) into actual number equivalent
;set si to "string to convert+(length-1)" before calling
;set cl to actual length of string before calling
;--------------------------------------------------------
converthighscoretonum proc near
	lea si, HIGHSCORE_STR+5 	;important!
	mov dx, 00 					;for tracking the final value
	mov cl, 5 					;expected len of highscore
	xor bx, bx 					;clear bx
	mov bl, 1 					;multiplier

	iterate2:
		xor ax, ax 	;clear ax

		;convert current char to number equivalent
		mov al, [si]
		sub al, 48 

		;check if al is within [0, 9]; if not, proceed to next
		cmp al, 0
		jb proceed2
		cmp al, 9
		ja proceed2

		else_do:
			;multiply ax with bx
			mul bl
			add dx, ax

			;multiplies bx by 10 so it becomes: 1, 10, 100, ..
			mov ax, bx
			mov bl, 10
			mul bl
			mov bx, ax

		;update si, decreasingly
		proceed2:
			dec si 		;since we started from scorestr+4
			loop iterate2

	final:
		;set dx to number
		mov highscorenum, dx
		ret
converthighscoretonum endp

;displays the texts found in game over screen (i.e. Game Over, highscore, score, Play Again, and QUIT)
;--------------------------------------------------------
printgameoverstrings proc near
	MOV		BH, 0AH   ;black background (0), light green foreground (A)
	call _clearscreen

	;display snake ascii art
	mov dh, 2 				;row = 2
	mov dl, 0 				;col = 0
	call _set_cursor
	display snake


	mov bl, 0ch 			;set color attribute to light red in printing the scores
	mov dh, 10				;row = 10
	mov dl, 34 				;column = 34
	call _set_cursor

	cmp islevelcomplete, 1 	;check if level was completed
	je complete_dothis 		;if completed, jump to complete_dothis

	;else display 'Game Over'
	printwithcolor gameovermsg 	;display message
	jmp go_continue 		;continue

	;if level is completed, display 'Level Complete'
	complete_dothis:
		printwithcolor lvlcompletemsg

	go_continue:
		;display highscore
		mov dh, 12 							;set row = 12
    	mov dl, 31							;set col = 31
    	call _set_cursor 					;set cursor
    	printwithcolor highscore 			;display the "HIGHSCORE: " label
    	printwithcolor HIGHSCORE_RAWSTRING  ;print what was read from 'hiscore.txt'

		;display score
		mov dh, 13 			;set row = 13
    	mov dl, 31			;set col = 31
    	call _set_cursor 	;set cursor
		call printscoretext

		mov bl, 3			;set color attribute to cyan in printing the options
		;display play again
		mov dh, 16 			;set row = 16
    	mov dl, 34			;set col = 34
    	mov selectrow, dh 	;select also current x and y 
		mov selectcol, dl 	;coordinate of 'select' indicator
    	call _set_cursor
    	printwithcolor playagainstring

		;display quit
		mov dh, 18 			;set row = 18
    	mov dl, 34			;set col = 34
    	call _set_cursor
    	printwithcolor menustring
    ret
printgameoverstrings endp

;sets '>' to proper cursor location
;DOES THE FOLLOWING: can quit (sets screennum=1)
;can play again or go to 'actual game' (sets screenum=3)
;-------------------------------------------
gameoverselection proc near

	;determines where the '>' indicator should be set
	;and performs necessary actions respectively
	setindicator2:
		mov inputkey, 00 ;para ka-usa ra mureact ang pag-key press

		;display 'select' indicator
		mov dh, selectrow
		mov dl, selectcol
		sub dl, 2  		 ;so that it will not overwrite 'Play Again' etc.
		call _set_cursor
		display select
		call _hidecursor
		mov bp, 2
		mov si, 2
		call _delay

		;get key
		call _getkey
		cmp inputkey, 48h ;UP2
		je UP2
		cmp inputkey, 50h ;DOWN2
		je DOWN2
		cmp inputkey, 1ch ;ENTER2
		je ENTER2
		jmp setindicator2

		UP2:
			call _beepsound
			cmp selectrow, 16
			jbe setindicator2  ;if equal to 16, do nothing

			;if currently above 16 (i.e. 18), deselect
			;and reset row to (selectrow - 2)
			call deselect
			mov al, selectrow
			sub al, 2
			mov selectrow, al
			jmp setindicator2

		DOWN2:
			call _beepsound
			cmp selectrow, 18
			jae setindicator2

			;if currently below 18 (i.e. 16), deselect
			;and reset row to (selectrow + 2)
			call deselect
			mov al, selectrow
			add al, 2
			mov selectrow, al
			jmp setindicator2

		ENTER2:
			call _beepsound
			;3 possibilities: naa sa how to play, start, quit
			cmp selectrow, 16
			je play_again 		;if equal to 13, go to 'actual game' screen
			cmp selectrow, 18 	;meaning it's pointing to 'start'
			je choose_title 	;if equal to 15, go to 'title' screen
			jmp setindicator2 	;else, loop balik

	play_again:
		mov screennum, 3 ;equal to 'actual game'
		ret

	choose_title:
		mov screennum, 1 ;equal to 'title' screen
		ret
gameoverselection endp

			


			end main