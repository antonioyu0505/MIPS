# Pontificia Universidad Javeriana, Cali
# Ingenieria de Sistemas y Computacion
# Arquitectura del computador I
# Cuarto Semestre
# Antonio Yu

.data
	array: .space 28
	start: .asciiz "\nYou must type a letter each time until you guess the word or you run out of lives. You have 10 lives. Good luck."
	used: .asciiz "\nLetters used: "
	input: .asciiz "\nType a letter: "
	win: .asciiz "\nYou win. Congratulations."
	lose: .asciiz "\nYou lose. Better luck next time."
	correct: .asciiz "\nCorrect. You guessed right."
	incorrect: .asciiz "\nFail. You guessed wrong."
	game: .asciiz "\n _ _ _ _ _"
	
	words:
		hello: .asciiz "hello"
		mouse: .asciiz "mouse"
		light: .asciiz "light"
		power: .asciiz "power"
		graph: .asciiz "graph"
		timer: .asciiz "timer"
		clock: .asciiz "clock"
# Variables used $a1, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8
.text
	generateWord:
		addi 				$v0, $0, 42				# Calls the service to generate a random number.
		addi 				$a1, $0, 7				# Gives the upper threshold of the generator.
		syscall
		move 				$s0, $a0				# Moves the number to a variable.
		mul					$s0, $s0, 6				# Multiplies the given number by 6 to get the position in the words array.
	gameStart:
		addi 				$v0, $0, 4				# Prints the rules of the game.
		la 					$a0, start				# Gives the string to print.
		syscall
		addi				$s2, $0, 10				# Loads the total amount of player lives.
		addi				$s3, $0, 1				# Condition to win.
		addi				$s5, $0, 0				# Iterator to fill up the array of already used characters.
		addi				$t3, $0, 1				# Iterator to show the word.
	loop:
		la 					$s1, words($s0)			# Chooses a word from the words array.
		beqz				$s2, printsGame			# Checks if the player already lost.
		beqz				$s3, gameWin			# Checks if the player already won.
		addi				$v0, $0, 4				# Calls the system to print a string.
		la					$a0, game				# Prints the "game" string.
		syscall
		addi				$v0, $0, 4				# Calls the system to print a string.
		la					$a0, input				# Prints the "input" string.
		syscall
		addi				$v0, $0, 12				# Reads the input character
		syscall
		move				$t0, $v0				# Moves the character to a temporal register.
		addi				$s4, $0, 5				# Condition to start comparing.
		addi				$s6, $0, 0				# Flag to check if a given letter is right.
		addi				$s7, $0, 0				# Variable to know the position of the current index of the word.
		addi				$t5, $0, 2				# Loads the condition to check if the user won.
		addi				$t6, $0, 95				# Loads integer 95, which is "_" in ascii.
		la					$t7, game				# Loads the address of the "game" array.
	compare:
		beqz				$s4, isWrong			# Checks if the given letter is wrong.
		lb					$t1, 0($s1)				# Loads a character from the picked word.
		addi				$s1, $s1, 1				# Goes to the next position of the picked word.
		addi				$s7, $s7, 1				# Increases the current index of the word.
		subi				$s4, $s4, 1				# Reduces the number of characters to guess.
		beq					$t0, $t1, right			# Compares the character to each character in the word.
		j					compare					# Loops the comparison function.
	right:
		addi				$v0, $0, 4				# Calls the system to print a string.
		la					$a0, correct			# Prints the "correct" string.
		syscall
		j					changeGame				# Changes the state of the game.
	changeGame:
		addi				$s6, $0, 1				# Changes the flag so the system knows the user guessed right.
		mul					$t2, $s7, 2				# Multiplies the index by two.
		sb					$t0, game($t2)			# Shows the input letter in the strings.
		jal					addLetter				# Adds the input letter to the "used" string.
		j					hasWon					# Starts comparing again.
	hasWon:
		beq 				$t5, 12, userWon		# If it already reached the end of the array, it will start comparing again.
		lb					$t8, 2($t7)				# Loads a character from the "game" array.
		addi				$t5, $t5, 2				# Increases the counter of the "game" array.
		addi				$t7, $t7, 2				# Goes to the next position of the "game" array.
		beq					$t8, $t6, addCondition	# If there's a "_" in the "game" array, the user has not won yet.
		j 					hasWon
	addCondition:
		addi				$s3, $s3, 1				# Adds 1 to s3 if it finds a "_" in the "game" array.
		j					compare					# Jumps to loop.
	userWon:
		addi				$s3, $0, 0				# Becomes zero if the user already won.
		addi				$v0, $0, 4				# Calls the system to print a string.
		la					$a0, game				# Prints the "game" string.
		syscall
		j					loop					# Jumps to loop.
	isWrong:
		beqz				$s6, wrong				# Checks the flag to know if the user guessed right or wrong.
		j					loop					# If not, it will start looping again.
	wrong:
		addi				$v0, $0, 4				# Calls the system to print a string.
		la					$a0, incorrect			# Prints the "incorrect" string.
		syscall
		subi				$s2, $s2, 1				# Reduces the number of lives by 1.
		jal 				addLetter				# Adds the input letter to the array.
		j 					loop					# Loops again.
	addLetter:
		sb					$t0, array($s5)			# Adds the letter to the array.
		addi				$s5, $s5, 1				# Increases the iterator by 1.
		addi				$v0, $0, 4				# Calls the system to pring a string.
		la					$a0, used				# Prints the "used" string.
		syscall
		addi				$v0, $0, 4				# Calls the system to print a string
		la					$a0, array				# Prints the array of letters used.
		syscall
		jr					$ra
	printsGame:
		beq					$t3, 6, gameLose		# Checks if all of the array has been iterated.
		lb					$t4, 0($s1)				# Loads the character of the word.
		mul					$t5, $t3, 2				# Multiplies the index by two.
		sb					$t4, game($t5)			# Puts the letter from the word to the "game" string.
		addi 				$s1, $s1, 1				# Goes to the next position of the word.
		addi				$t3, $t3, 1				# Increases the iterator by 1.
		j 					printsGame				# Loops printsGame.
	gameLose:
		addi				$v0, $0, 4				# Calls the system to print a string.
		la					$a0, game				# Prints the "game" string.
		syscall
		addi 				$v0, $0, 4				# Calls the service to print a string.
		la					$a0, lose				# Prints the "lose" string.
		syscall
		j					exit					# Ends the program.
	gameWin:
		addi				$v0, $0, 4				# Calls the service to print a string.
		la 					$a0, win				# Prints the "win" string.
		syscall
		j					exit					# Ends the program.
	exit:
		addi				$v0, $0, 10				# Calls the system to terminate the program.
		syscall
