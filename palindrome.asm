# Pontificia Universidad Javeriana, Cali
# Ingenieria de Sistemas y Computacion
# Arquitectura del computador I
# Cuarto Semestre
# Antonio Yu

.data
	array: .space 20
	true: .asciiz "Is a palindrome."
	false: .asciiz "Not a palindrome."
.text
	
	addi           $v0, $zero, 8         # Calls the service to read a string.
	la             $a0, array            # Stores the given string into a space.
	addi           $a1, $a1, 20          # Maximum number of characters to read.
	syscall
	la             $a1, array            # Loads the address of the array.
	addi           $t2, $t2, 0           # Declares the initial size of the array.
	
	arraySize:                           # Gets the size of the array.
		lb         $t1, 0($a1)           # Loads each position [i] into the register.
		beq        $t1, 0, main          # If the position [i] of the array is null, it will end the cycle.
		addi       $a1, $a1, 1           # Goes to the next position of the array.
		addi       $t2, $t2, 1           # Adds 1 for each non-null character in the array.
		j          arraySize             # Continues the cycle.
		
	main:                                # Loads all the needed variables.
		subi       $t2, $t2, 1           # Subtract 1 to not count the backspace as a character.
		addi       $t5, $t2, 0           # Stores the size of the array to iterate from [size - 1] to [0].
		la         $t3, array            # Loads the array into a register. Will iterate from [0] to [size].
		la         $t4, array            # Loads the array into a second register. Will iterate from [size] to [0].
		add        $t4, $t4, $t2         # Adds [size] to the array address, indicating that it will start at the last position.
		
	loop:                                # Contains the loop to iterate through the array.
		beqz       $t2, trueState        # If the iterator from [0] to [size - 1] is 0, then it is a palindrome.
		beqz       $t5, trueState        # If the iterator from [size - 1] to [0] is 0, then it is a palindrome.
		lb         $a1, 0($t3)           # Loads the character in the position [i] of the array.
		lb         $a2, 0($t4)			 # Loads the character in the position [size - i] of the array.
		blt        $a1, 97, next		 # If the first loaded character is not an alphabetic lower case, it will skip it.
		bgt        $a1, 122, next        # If the first loaded character is not an alphabetic lower case, it will skip it.
		blt        $a2, 97, before       # If the second loaded character is not an alphabetic lower case, it will skip it.
		bgt        $a2, 122, before		 # If the second loaded character is not an alphabetic lower case, it will skip it.
		bne        $a1, $a2, falseState  # If both characters are different, the phrase is not a palindrome.
		
	continue:                            # Iterates through the array.
		addi       $t3, $t3, 1           # Iterates from [0] to [size - 1].
		subi       $t4, $t4, 1           # Iterates from [size - 1] to [0].
		subi       $t2, $t2, 1           # Reduces the number of iterations from [0] to [size - 1].
		subi       $t5, $t5, 1			 # Reduces the number of iterations from [size - 1] to [0].
		j          loop                  # Repeats the loop.
		
	next:                                # Skips the non-alphabetic lower case character from [0] to [size - 1].
		addi       $t3, $t3, 1           # Goes to the next position of the array.
		subi       $t2, $t2, 1           # Reduces the number of iterations from [0] to [size - 1].
		j          loop                  # Repeats the loop.
	
	before:                              # Skips the non-alphabetic lower case character from [size - 1] to [0].
		subi       $t4, $t4, 1           # Goes to the previous position of the array.
		subi       $t5, $t5, 1           # Reduces the number of iterations from [size - 1] to [0].
		j          loop                  # Repeats the loop.
	
	falseState:                          # Prints "Not a palindrome".
		addi       $v0, $zero, 4         # Calls the system to print a string.
		la         $a0, false            # Argument to the string to print.
		syscall
		j          exit                  # Exits the program.
	
	trueState:                           # Prints "Is a palindrome".
		addi       $v0, $zero, 4         # Calls the system to print a string.
		la         $a0, true             # Argument to the string to print.
		syscall
		j          exit                  # Exits the program.
	
	exit:
		addi $v0, $zero, 10              # Calls the system to exit the program.
		syscall