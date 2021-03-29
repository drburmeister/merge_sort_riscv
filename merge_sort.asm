# If unsure about an instruction or system-call (i.e., environment-call), always check:
# [instructions]  https://github.com/TheThirdOne/rars/wiki/Supported-Instructions 
# [system calls]  https://github.com/TheThirdOne/rars/wiki/Environment-Calls 
# Author : Dennis Burmeister
#Description Merge Sort RISC-V Assembly Implementation
#Date : 3/25/21

.data

#Length of the array
Size:	.word 13

#Values in the array
Vals:	.word 13, 101, 79, 23, 154, 4, 11, 38, 89, 45, 17, 94, 5

#Print a new line in the output when called to 
newLine:	.asciz "\n"

.text

main:			# Main function

        addi    x2, x2, -4	# Create room in the stack
        sw      ra, 8(x2)	# Store the return address
        sw      s0, 12(x2)	# Store frame pointer
        addi    s0, x2, 4	# Increment frame pointer in respect to stack
        
        lui     a4, %hi(Size)	# Load the highest address of the size 
        lw      a4, %lo(Size)(a4)	# Load the lowest  address of the size
        addi    a4, a4, -1	# Set the lowest address to Size - 1
        mv      a2, a4		# Save a copy of Size - 1
        li      a1, 0		# Load 1 into a1 for the counter of the for loop
        lui     a4, %hi(Vals)	# Load the highest address of the value array
        addi    a0, a4, %lo(Vals)	# Increment a0 to react the highest address of the size
        
        call    mergeSort	# Jump to mergeSort	
        sw      zero, -16(s0)	# Store '0' into the memory address (Reset s0)
        j       printArray	# Jump to the print method for after sorting
        
mergeSort:			# mergesort starts

        addi    x2, x2, -32	# Create room in the stack
        sw      ra, 24(x2)	# Store the return address
        sw      s0, 20(x2)	# Store frame pointer
        addi    s0, x2, 32	# Increment frame pointer in respect to stack
        
        sw      a0, -36(s0)	# Store address for int x[]
        sw      a1, -20(s0)	# Store address for left
        sw      a2, -24(s0)	# Store address for right
        lw      a3, -20(s0)	# Load address for left
        lw      a4, -24(s0)	# Load address for right
        bge     a3, a4, return	# Check if left >= right and if so call return
        
        lw      a3, -24(s0)	# Load address for right
        lw      a4, -20(s0)	# Load address for left
        sub     a4, a3, a4	# right - left
        addi    a4, a4, 1	# right - left + 1
        srli    a4, a4, 1	# (right - left + 1) >> 1
        lw      a3, -20(s0)	# Load address for left
        add     a4, a3, a4	# middle = ((right - left + 1) >> 1) + left
        sw      a4, -16(s0)	# Store address for middle
        addi    a4, a4, -1	# Middle - 1
        mv      a2, a4		# Save a copy of middle - 1
        call    mergeSort	# Recursive mergesort call 
        			# Parameters: a2 = middle - 1; a1 = left; a0 = x
        lw      a0, -36(s0)	# Load address of the array into a0
        lw      a1, -16(s0)	# Load address of middle into a1
        lw      a2, -24(s0)	# Load address of right into a2

        
        call    mergeSort	# Recursive mergesort call 
        			# Parameters: a2 = right; a1 = middle; a0 = x
        
        lw      a0, -36(s0)	# Load address of the array into a0
        lw      a1, -20(s0)	# Load address for left into a1
        lw      a2, -16(s0)	# Load address for middle into a2
        lw      a5, -24(s0)	# Load address for right into a5
       
        call    merge		# Call/Start to merge
        			# Parameters: a5 = right; a2 = middle; a1 = left; a0 = x
        j       endMergeSort	# Jump to the end of merge sort
        
return:
# Empty return for when left >= right    
  
endMergeSort:		# End of merge sort function
        lw      ra, 24(x2)	# Load return address
        lw      s0, 20(x2)	# Load left address
        addi    x2, x2, 32	# Readjust the stack pointer
        jr      ra		# Jump return with the return address
merge:
        addi    x2, x2, -36	# Offset stack pointer to make room for new data
        sw      s0, 40(x2)	# Store s0 onto stack
        addi    s0, x2, 36	# Return stack pointer to previous position
        
        sw      a0, -44(s0)	# Store a0 to stack (x[] base address)
        sw      a1, -48(s0)	# Store a1 to stack (left)
        sw      a2, -40(s0)	# Store a2 to stack (middle)
        sw      a5, -36(s0)	# Store a5 to stack (right)
        lw      a4, -48(s0)	# Load a4 from stack (leftind = left)
        sw      a4, -16(s0)	# Store a4 to stack  (leftind)
        lw      a4, -40(s0)	# Load a4 from stack (rightind = middle)
        sw      a4, -8(s0)	# Store return address from a4
        lw      a4, -40(s0)	# Load s0 into a4
        addi    a4, a4, -1	# Decrement a4
        
        sw      a4, -12(s0)	# Store a4 into frame pointer
        lw      a4, -36(s0)	# Load right from the stack
        j       whileLoop	# Jump to the outer loop
        
xLeftlessthanxRigtht:

        lw      a4, -16(s0)	# Load middle address
        slli    a4, a4, 2	# Shift a4 by 4
        lw      a3, -44(s0)	# Load array from the stack
        add     a4, a3, a4	# Store address of element at index a4 to a4
        
        lw      a3, 0(a4)	# Load element to a3
        lw      a4, -8(s0)	# Load return address to a4
        slli    a4, a4, 2	# Shift return address by 4
        lw      a5, -44(s0)	# Load array base address
        add     a4, a5, a4	# Store address of element at index a4 to a4
        lw      a4, 0(a4)	# Load the element into a4
        
        bgt     a3, a4, lltr_else	# If x[leftind] <= x[rightind] condition branch if false
        lw      a4, -16(s0)	# Load address of middle to a4
        addi    a4, a4, 1	# Increment middle address
        sw      a4, -16(s0)	# Store new middle address
        j       whileLoop	# Jump to the while loop
        
lltr_else:			# Function for if x[leftind] > x[rightind]
		
        lw      a4, -8(s0)	# Load return address into a4
        slli    a4, a4, 2	# Multiply return address by 4
        lw      a3, -44(s0)	# Load array base address to a3
        add     a4, a3, a4	# Store x[rightind] into temp
        
        lw      a4, 0(a4)	# Load element at address a4
        sw      a4, -20(s0)	# Store a4 as the left address
        lw      a4, -8(s0)	# Load array base to a4
        addi    a4, a4, -1	# Decrement a4 by 1
        sw      a4, -4(s0)	# Store a4 as the new leftind
        j       innerForLoop	# Jump into the inner for loop
        
shift:			# Method that computes x[i + 1] = x[i]

        lw      a4, -4(s0)	# Load the leftind value to a4
        slli    a4, a4, 2	# Multiply by 4 (word size)
        lw      a3, -44(s0)	# Load array base address
        add     a3, a3, a4	# Shift the base by index
        lw      a4, -4(s0)	# Reload index
        addi    a4, a4, 1	# i = i + 1
        slli    a4, a4, 2	# Multiply by 4 (word size)
        lw      a5, -44(s0)	# Load the base address of x array
        add     a4, a5, a4	# a4 is the address of x[i +1]
        
        lw      a3, 0(a3)	# Load value at a3 address (x[i])
        sw      a3, 0(a4)	# Store copy of a3 
        lw      a4, -4(s0)	# Load x[i + 1]
        addi    a4, a4, -1	# Decrement a4
        sw      a4, -4(s0)	# Store x[i] into x[i +1]
        
innerForLoop: # For loop that shifts element of rightind to leftind

        lw      a3, -4(s0)	# Load the current index into a3
        lw      a4, -16(s0)	# Load the middle address into a4
        bge     a3, a4, shift	# Loop if leftind >= i
        
        lw      a4, -16(s0)	# Load leftind to a4
        slli    a4, a4, 2	# Multiply a4 by 4 (word size)
        lw      a3, -44(s0)	# Load base temp variable value
        add     a4, a3, a4	# Load value at index temp
        lw      a3, -20(s0)	# Load the left address to a3
        sw      a3, 0(a4)	# Store temp variable to x[leftind]
       
        lw      a4, -16(s0)	# Load leftind to a4
        addi    a4, a4, 1	# leftind++
        sw      a4, -16(s0)	# Store new leftind
        
        lw      a4, -12(s0)	# Load endleft to a4
        addi    a4, a4, 1	# endleft++
        sw      a4, -12(s0)	# Store new endleft
        
        lw      a4, -8(s0)	# Load rightind to a4
        addi    a4, a4, 1	# rightend++
        sw      a4, -8(s0)	# Store new rightend
        
whileLoop:			# Function that handles the outer while loop

        lw      a3, -16(s0)	# Load leftind
        lw      a4, -12(s0)	# Load rightind
        bgt     a3, a4, mergeEnd	# Condition for if leftind > rightind
        			# Will jump to merge end if leftind > rightind
        lw      a3, -8(s0)	# Load rightind to a3
        lw      a4, -36(s0)	# Load endright to a4
        ble     a3, a4, xLeftlessthanxRigtht
        # Condition for if rightind <= leftin, if so jump to xLeftlessthanxRigtht

mergeEnd:			# Function that ends the merge function

        lw      s0, 40(x2)	# Load s0 from the stack
        addi    x2, x2, 36	# Re-align the stack pointer
        jr      ra		# Return to return address

printLoop:	# Function for printing the sorted array

        lui     a4, %hi(Vals)	# Load the highest address of the value array
        addi    a3, a4, %lo(Vals)	# Load the lowest address of the value array
        lw      a4, -16(s0)	# Load the index 
        slli    a4, a4, 2	# Increment the index by 4 (one word)
        add     a4, a3, a4	# Set the address of the array to point at the i-th element
        lw      a4, 0(a4)	# Load the value of the array at the index position 
        mv      a1, a4		# Save a copy of a4 to a1
        lui     a4, %hi(newLine)	# Load the highest address of the new line
        addi    a0, a4, %lo(newLine) # Load the lowest address of the new line
      
        li      a7, 4		# Load the size of a word
        la      a0,newLine	# Print a eol/new line
        ecall    		# Call to risc-v instruction to print
        li	    a7, 1		# Load the size to print an int
        mv 	    a0, a1		# Load current value in array
        ecall		# Call to risc-v instruction to print
        lw      a4, -16(s0)	# Load the index in the array
        addi    a4, a4, 1	# i++
        sw      a4, -16(s0)	# Store new index
printArray:
        lui     a4, %hi(Size)	# Load the highest address of the value array
        lw      a4, %lo(Size)(a4)	# Load the highest address of the value array
        lw      a3, -16(s0)	# Load the index in the array
        blt     a3, a4, printLoop	# Check if the index > max, if not continue loop
        lw      ra, 8(x2)	# Load return address from main:
        lw      s0, 12(x2)	# Load frame pointer from main:
        addi    x2, x2, 4	# Increment Stack pointer by a word
        li	     a7, 10		# Load the size to terminate the program
        ecall		# Call to risc-v instruction to terminate