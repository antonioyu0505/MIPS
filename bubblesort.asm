# Pontificia Universidad Javeriana, Cali
# Ingenieria de Sistemas y Computacion
# Arquitectura del computador I
# Cuarto Semestre
# Antonio Yu

.data
	array: .space 400

.text
	
	addi        $t2, $0, 100       # Creates a counter = 100, which will be the number of times we will create a random number.
	addi        $t3, $0, 0         # Creates a counter that will iterate through the 'array' to fill it up with random numbers.
	
	generateRandom:                # For loop to fill up an array of randomly generated numbers, up to 100.
		beqz    $t2,  outerLoop    # Condition to stop the loop.
		addi    $t0, $zero, 100    # Generates the upper threshold for the numbers randomly generated.
		addi    $v0, $zero, 42     # Calls the service to generate a random number between 0 and the threshold.
		addi    $a1, $t0, 0        # Gives the threshold to the service.
		syscall
		sw      $a0, array($t3)    # Stores the random number in the 'array'.
		subi    $t2, $t2, 1        # Subtract from t2 register to avoid infinite loop.
		addi    $t3, $t3, 4        # Add to t3 register to iterate correctly on the 'array'.
		j       generateRandom     # Repeats the cycle.
	
	outerLoop:                     # Outer loop, iterates through the array a number of [size - 1] times.
		subi    $a2, $t0, 1        # Subtract 1, because it must compare [i] with [i + 1].
		beqz    $a2, exit          # If the outer loop counter is 0, it means we are done sorting the array.
		la      $a3, array         # Loads address of the array into the register to begin looping.
		jal     innerLoop          # Jump to the inner loop, to begin swapping elements.
		subi    $t0, $t0, 1        # Subtract 1 every time the loop does a full iteration on the array.
		j       outerLoop          # Repeat the loop.
		
	innerLoop:                     # Inner loop that will compare and swap elements of the array.
		lw      $s0, 0($a3)        # Loads the number in the position [i] of the array into the register s0.
		lw      $s1, 4($a3)        # Loads the number in the position [i + 1] of the array into the register s1.
		bgt     $s1, $s0, next     # Checks if s1 > s0, if so, will continue iterating. If not, will swap elements.
		sw      $s0, 4($a3)        # Stores the number in [i + 1] into the position [i] of the array.
		sw      $s1, 0($a3)        # Stores the number in [i] into the position [i + 1] of the array.
		
	next:                          # Iterates the array and checks if the inner loop is still on-going.
		addi    $a3, $a3, 4        # Goes to the next position of the array.
		subi    $a2, $a2, 1        # Reduce the number of iterations through the array.
		bgtz    $a2, innerLoop     # If the number of iterations is not 0, we will continue looping through the array
		jr      $ra                # If the number of iterations is 0, we will restart the inner loop of the array.
	
	exit:
		addi    $v0, $zero, 10     # Exits the program
		syscall
