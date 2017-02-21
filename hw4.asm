##############################################################
# Homework #4
# name: NAVIN_ABICHANDANI
# sbuid: 110313627
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

preorder:
	move $t0, $a0
	la $t1, ($a1)
	move $t2, $a2
	
	lh $t3, ($a0)  #Value of node
	
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $a0, 16($sp)
	sw $a1, 20($sp)
	sw $a2, 24($sp)
	sw $ra, 28($sp)
	move $a0, $t2
	move $a1, $t3
	jal itof
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $a0, 16($sp)
	lw $a1, 20($sp)
	lw $a2, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	
	move $a0, $t2
	la $a1, newline
	li $a2, 1
	li $v0, 15
	syscall

	
	
	lh $t4, 2($t0) #2nd half of node
	li $t5, 65280
	and $t4, $t4, $t5
	srl $t4, $t4, 8 #nodeIndex - holds left node 
	
	beq $t4, 255, not_left
	
	li $t5, 4
	mul $t6, $t4, $t5 #left node address
	add $t6, $t6, $t1
	addi $sp, $sp, -32
	sw $t0, 0($sp) 
	sw $t1, 4($sp) 
	sw $t2, 8($sp)
	sw $t3, 12($sp) 
	sw $t4, 16($sp) 
	sw $t5, 20($sp) 
	sw $t6, 24($sp) 
	sw $ra, 28($sp)
	move $a0, $t6
	move $a1, $t1
	move $a2, $t2
	
	jal preorder
		
	lw $t0, 0($sp) 
	lw $t1, 4($sp) 
	lw $t2, 8($sp)
	lw $t3, 12($sp) 
	lw $t4, 16($sp) 
	lw $t5, 20($sp) 
	lw $t6, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	
not_left:
	lh $t4, 2($t0) #2nd half of node
	li $t5, 255
	and $t4, $t4, $t5 #holds right node
	 	
	beq $t4, 255, not_right
	
	li $t5, 4
	mul $t6, $t4, $t5 #right node address
	add $t6, $t6, $t1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	move $a0, $t6
	move $a1, $t1
	move $a2, $t2
	jal preorder	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	

not_right:
	jr $ra	
    
    
    
itof:
     move $t0, $a0
     move $t1, $a1

     andi $t2, $t1, 32768
     li $t9, 32768
     li $t7, 0 #reversed int
     li $t3, 0   #counter
     li $t5, '\0'
     beq $t2, $t9, is_Neg 
     j rev_loop
     
     
is_Neg:
     la $a1, word
     li $t9, '-'
     sw $t9, ($a1) 
     li $a2, 1
     li $v0, 15
     syscall
     
     li $t2, 4294967295
     xor $t1, $t1, $t2
     addi $t1, $t1, 1
     
rev_loop:
	li $t4, 10
	div $t1, $t4
	mfhi $t8
	mflo $t1
	mul $t7, $t7, $t4
	add $t7, $t7, $t8
	addi $t3, $t3, 1
	beq $t1, $t5, itOf_loop
	j rev_loop

itOf_loop:
     beqz $t3, end_itof
     div $t7, $t4
     mflo $t7
     mfhi $t5
     addi $t5, $t5, '0'
     la $t6, word
     sb $t5, ($t6) 
     la $a1, word
     li $a2, 1
     li $v0, 15
     syscall
     addi $t3, $t3, -1
     j itOf_loop

end_itof:
	jr $ra 
	
              
                     
                            
                                    

##############################
# PART 2 FUNCTIONS
##############################

linear_search:
    move $t0, $a0
    move $t1, $a1
    
    li $t2, 0 #counter
    li $t3, 0 #byte counter
    li $t5 , 8
    div $t1, $t5
    mfhi $t9  #max amt of bits
    mflo $t8
    beqz $t9, lin_search_cont
    addi $t8, $t8, 1 
    
lin_search_cont:
    li $t6, 1 
    lb $t4, ($t0)
    
search_loop:
   beq $t2, $t1, not_in_arr
   and $t7, $t4, $t6
   beqz $t7, in_arr
   addi $t2, $t2, 1 
   sll $t6, $t6, 1 
   div $t2, $t5
   mfhi $t9
   beqz $t9, next_b
   j search_loop
   
next_b:
   li $t6, 1
   addi $t0, $t0, 1
   lb $t4, ($t0)
   addi $t3, $t3, 1
   j search_loop
       
    
in_arr:
    move $v0, $t2
    jr $ra
    
not_in_arr:
    li $v0, -1
    jr $ra



set_flag:
    move $t0, $a0 #flag array
    move $t1, $a1 #index 
    move $t2, $a2 #set value
    move $t3, $a3 #max size
    
    andi $t2, $t2, 1   #Gets LSB of $t2
    bgt $t1, $t3, not_suc
    bltz $t1, not_suc
    li $t4, 8
    
    div $t1, $t4 
    mflo $t5 #holds array index
    mfhi $t6 #holds bit pos in index
    
    add $t0, $t0, $t5
    li $t7, 1  #val of pos in byte
    li $t8, 0  #sll counter
   
sll_loop:
    beq $t8, $t6, put_set_val
    sll $t7, $t7, 1
    addi $t8, $t8, 1
    j sll_loop
	

put_set_val:
    lb $t9, ($t0)
    beq $t2, 1, ins_1
    li $t5, 255
    sub $t7, $t5, $t7
    and $t9, $t9, $t7
    j suc

ins_1:
    or  $t9, $t9, $t7
    
suc:
    sb $t9, ($t0)
    move $a0, $t0
    li $v0, 1
    jr $ra

	
not_suc:
     li $v0, 0
     jr $ra
    
    


find_position:
    move $t0, $a0 #nodes array
    move $t1, $a1 #curr_index 
    move $t2, $a2 #new_val
    
    li $t3, 65535   #holds 16 1's in binary
    and $t2, $t2, $t3  #Gets halfword
    li $t5, 32768  #holds 1 followed by 15 0's in binary
    andi $t4, $t2, 32768 #Checks MSB
    beq $t4, $t5, signed_half #If MSB is 1, it is neg, so jump
    j after_new_new_val

signed_half:
    li $t3, 4294901760 
    or $t2, $t2, $t3 #or it w/ 1111 1111 1111 1111 0000 0000 0000 0000 to sign extend it
    
after_new_new_val:
	#At this point, $t2 is sign extended has the 12 LSB of $a2

    li $t3, 4  #size of element
    mul $t8, $t1, $t3  #offset = index × size_of_element
    add $t0, $t0, $t8 #Sets pointer to node[curr_index]
    li $t3, 0
    lh $t3, ($t0)  #$t3 is node[curr_index]
    blt $t2, $t3, is_left # newValue < nodes[currIndex].value
    j is_right  #jump to else
    
is_left:   #$t3 is node[val]
    lb $t5, 3($t0)
    andi $t5, $t5, 0xff
    
    beq $t5, 255, no_left_child
    j is_left_child
no_left_child:
     move $v0, $t1 
     li $v1, 0
     jr $ra
     
is_left_child:
	move $a0, $a0
	move $a1, $t5
	move $a2, $t2
	
	addi $sp, $sp, -4
	sw $ra, ($sp)
	jal find_position
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra   



is_right:
      lb $t5, 2($t0)
      andi $t5, $t5, 0xff
      beq $t5, 255, no_right_child
      j is_right_child

no_right_child:
     move $v0, $t1 
     li $v1, 1
     jr $ra
     
is_right_child:       
     move $a0, $a0
     move $a1, $t5
     move $a2, $t2
     
     addi $sp, $sp, -4
     sw $ra, ($sp)
     jal find_position
     lw $ra, ($sp)
     addi $sp, $sp, 4
     
     jr $ra   
     
      
        

add_node:
    move $t0, $a0 #nodes arr
    move $t1, $a1 #rootIndex
    move $t2, $a2 #new_val
    move $t3, $a3 #newIndex
    lw $t4, 4($sp) #flags array
    lw $t5, 0($sp) #maxSize
    
    
    andi $t1, $t1, 0xFF  #rootIndex = toUnsignedByte(rootIndex)
    andi $t3, $t3, 0xFF  #newIndex = toUnsignedByte(newIndex)
    
    bge $t1, $t5, greater_than_max  #RootIndex || new index > maxSize, return 0
    bge $t3, $t5, greater_than_max
    
    li $t9, 65535 #1111 1111 1111 1111
    and $t2, $t2, $t9  #Removes most significant 16 bits and saved in $t2
    li $t9, 32768 #1000 0000 0000 0000
    and $t6, $t2, $t9 #checks if MSB is a 1 or not
    beq $t9, $t6, is_neg_val #if 1, sign extend
    j after_is_neg_val #else skip it

is_neg_val:
    li $t9, 4294901760  #1111 1111 1111 1111 0000 0000 0000 0000
    or $t2, $t2, $t9

after_is_neg_val:   #At this point, $t2 is sign extended
    li $t8, 8
    div $t1, $t8 
    mflo $t7 #Quotient - arr element
    mfhi $t8 #Rem - bit
    add $t4, $t4, $t7
    lb $t9, ($t4)
    
    ror $t9, $t9, $t8
    andi $t7, $t9, 1
    rol $t9, $t9, $t8  
    
    beqz $t7, newIndRoot
    
    addi $sp, $sp, -28
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)
    sw $t5, 20($sp)
    sw $ra, 24($sp)
    
    move $a0, $a0
    move $a1, $t1
    move $a2, $t2
    
    jal find_position
    
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $t4, 16($sp)
    lw $t5, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    
    move $t6, $v0  #$t6 = parentIndex
    move $t7, $v1  #1 = right, 0 = left
   
    li $t9, 4
    mul $t7, $t6, $t9   #parentIndex x 4
    move $t0, $a0
    add $t0, $t0, $t7 
    move $t9, $v1  #1 = right, 0 = left
    beq $t9, 1, is_Right_Child
    j is_Left_Child
    
       

is_Right_Child:
    addi $t0, $t0, 2
    sb $t3, ($t0)
    j after_child

is_Left_Child:
    addi $t0, $t0, 3
    sb $t3, ($t0)
    j after_child
  
  
newIndRoot:
    move $t3, $t1   #newIndex = rootIndex
    
after_child:
    move $t0, $a0
    li $t9, 4
    mul $t8, $t3, $t9  # newIndex x 4
    add $t0, $t0, $t8
    sh $t2, ($t0)
    addi $t0, $t0, 2
    li $t9, 0xFF
    sb $t9, ($t0)
    addi $t0, $t0, 1
    sb $t9, ($t0)
    
    move $a0, $t4
    move $a1, $t3
    li $a2, 1
    move $a3, $t5
    
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    jal set_flag
    
    lw $ra, ($sp)
    addi $sp, $sp, 4
    
    jr $ra
 


greater_than_max:
        li $v0, 0    
	jr $ra

##############################
# PART 3 FUNCTIONS
##############################

get_parent:
    move $t0, $a0  #nodes array
    move $t1, $a1  #current index
    move $t2, $a2  #child value
    move $t3, $a3  #child index 
    
    li $t4, 65535 #1111 1111 1111 1111
    and $t3, $t3, $t4  #childIndex = toUnsignedByte(childIndex)
    li $t4, 255  #1111 1111
    and $t2, $t2, $t4
    li $t9, 32768 #1000 0000 0000 0000
    and $t6, $t2, $t9 #checks if MSB is a 1 or not
    beq $t6, $t9, is_neg_value
    j after_is_neg_value
   
is_neg_value:
    li $t9, 4294901760  #1111 1111 1111 1111 0000 0000 0000 0000
    or $t2, $t2, $t9

after_is_neg_value:   #$t2 contains signextended child value
    li $t9, 4
    mul $t4, $t1, $t9 #current index x 4
    add $t0, $t0, $t4 
    lh $t5, ($t0)  #nodes[currIndex].value
    blt $t2, $t5, get_to_left
    j get_to_right 
    
get_to_left:
    lb $t5, 3($t0) #left index
    andi $t5, $t5, 0xFF
    beq $t5, 255, ret_1_less
    beq $t5, $t3, equal_child_left   
    
    
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    move $a1, $t5
    jal get_parent
   
    lw $ra, ($sp)    
    addi $sp, $sp, 4
    
    jr $ra     


equal_child_left:
    move $v0, $t1
    li $v1, 0
    jr $ra

get_to_right:   
    lb $t5, 2($t0) #right index
    andi $t5, $t5, 0xFF
    beq $t5, 255, ret_1_less
    beq $t5, $t3, equal_child_right
   
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    move $a1, $t5
    jal get_parent
   
    lw $ra, ($sp)    
    addi $sp, $sp, 4
    
    jr $ra
    
equal_child_right:
    move $v0, $t1
    li $v1, 1   
    jr $ra
    
ret_1_less:
    li $v0, -1    
    jr $ra



find_min:
    move $t0, $a0 #nodes arr
    move $t1, $a1 #curr index
    
    li $t3, 4
    mul $t4, $t1, $t3  #index * 4  
    
    add $t0, $t0, $t4
    addi $t0, $t0, 2
    lb $t8, ($t0) #right node
    addi $t0, $t0, 1
    lb $t9, ($t0) #left node
    
    andi $t9, $t9, 0xFF
    
    beq $t9, 255, is_minimum
    
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    move $a1, $t9
    jal find_min
    lw $ra, ($sp)
    addi $sp, $sp, 4
    
    jr $ra
    
    
    
is_minimum:
    move $v0, $t1
    andi $t8, $t8, 0xFF
    beq $t8, 255, ret_is_leaf
    li $v1, 0        
    jr $ra
        
ret_is_leaf:
    li $v1, 1        
    jr $ra


delete_node:
    move $t0,$a0   #Nodes array
    move $t1, $a1  #Root index
    move $t2, $a2  #Delete Index
    move $t3, $a3  #flags
    lw $t4, 0($sp) #Max Size
    
    andi $t1, $t1, 255   #Gets unsigned byte of root index
    andi $t2, $t2, 255   #Gets unsigned byte of delete index
    
    bge $t1, $t4, ret_zero_delete
    bge $t2, $t4, ret_zero_delete
    
    li $t5, 8
    div $t1, $t5  #div root ind by 8
    mfhi $t5  #index
    mfhi $t6  #bit
    
    add $t3, $t3, $t5 # add index to flags arr
    lb $t7, ($t3) #load bit in flags array
    ror $t7, $t7, $t6 #Makes bit in 1st position
    
    andi $t8, $t7, 1 #and with 1
    rol $t7, $t7, $t6 #rotate back to default position
    beq $t8, 0, ret_zero_delete #if 0, end
   
    move $t3, $a3 #reset offset of flags arr
    
    li $t5, 8 
    div $t2, $t5 #Delete index / 8
    mflo $t5  #index
    mfhi $t6  #bit
    
    add $t3, $t3, $t5 #add t3 with index
    lb $t7, ($t3)  #load bit of $t3
    ror $t7, $t7, $t6 #make bit in 1st position
    
    andi $t8, $t7, 1 #and with 1
    rol $t7, $t7, $t6 #rotate back to default position
    beq $t8, 0, ret_zero_delete #if 0, end
    
    move $t3, $a3 #reset offset of flags arr
    
    li $t5, 4
    mul $t6, $t2, $t5 #deleteIndex x 4
    
    add $t0, $t0, $t6 #moves offset of nodes arr to delete index
    lh $t9, ($t0)   #nodes[deleteIndex].value
    
    addi $t0, $t0, 2 #moves offset to right node of deleteIndex
    lb $t6, ($t0) 
    andi $t6, $t6, 0xFF
    bne $t6, 0xFF, check_has_one_child  #if byte is not 255, go to else if
    
    addi $t0, $t0, 1 #move offset to left node of deleteIndex
    lb $t6, ($t0)
    andi $t6, $t6, 0xFF
    bne $t6, 0xFF, check_has_one_child #if byte is not 255, go to else if
    
    addi $sp, $sp, -44
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $t0, 16($sp)
    sw $t1, 20($sp)
    sw $t2, 24($sp)
    sw $t3, 28($sp)
    sw $t4, 32($sp)
    sw $t9, 36($sp)
    sw $ra, 40($sp)
    
    move $a0, $t3  #moves flag arr to $a0
    move $a1, $t2  #moves delete index to $a1
    li $a2, 0
    move $a3, $t4  #moves max size to $a3
    
    jal set_flag
             
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $t0, 16($sp)
    lw $t1, 20($sp)
    lw $t2, 24($sp)
    lw $t3, 28($sp)
    lw $t4, 32($sp)
    lw $t9, 36($sp)
    lw $ra, 40($sp)
    addi $sp, $sp, 44
    
    beq $t1, $t2, ret_one_delete
    move $t0, $a0
    
    addi $sp, $sp, -40
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $t0, 16($sp)
    sw $t1, 20($sp)
    sw $t2, 24($sp)
    sw $t3, 28($sp)
    sw $t4, 32($sp)
    sw $ra, 36($sp)
    

    move $a1, $t1  #moves root index to $a1
    move $a2, $t9  #moves nodes[deleteIndex].value to $a2
    move $a3, $t2  #moves delete index to $a3
    
    jal get_parent
    
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $t0, 16($sp)
    lw $t1, 20($sp)
    lw $t2, 24($sp)
    lw $t3, 28($sp)
    lw $t4, 32($sp)
    lw $ra, 36($sp)
    addi $sp, $sp, 40
    
    move $t5, $v0  #parent node
    move $t6, $v1  #leftOrRight
    
    beq $t6, 0, delete_left_parent
    
    li $t9, 4
    mul $t5, $t5, $t9   #mul parent node by 4
    add $t0, $t0, $t5  #add with nodes arr
    addi $t0, $t0, 2
    li $t9, 255
    sb $t9, ($t0)
    j ret_one_delete

delete_left_parent:
    li $t9, 4
    mul $t5, $t5, $t9   #mul parent node by 4
    add $t0, $t0, $t5  #add with nodes arr
    addi $t0, $t0, 3
    li $t9, 255
    sb $t9, ($t0)
    j ret_one_delete
    
    
check_has_one_child: 
    move $t0, $a0
    li $t9, 4
    mul $t5, $t2, $t9  #mul delete index x 4
    add $t0, $t0, $t5
    addi $t0, $t0, 2
    lb $t6, ($t0)
    andi $t6, $t6, 0xFF
    beq $t6, 255, left_is_there
    beq $t6, -1, left_is_there
    addi $t0, $t0, 1
    lb $t6, ($t0)  
    beq $t6, 255, right_is_there
    beq $t6, -1, right_is_there
    j after_has_one
    
left_is_there:
    addi $t0, $t0, 1
    lb $t6, ($t0)
    j is_one
    
right_is_there:
    addi $t0, $t0, -1
    lb $t6, ($t0)
    j is_one
    
is_one:  #at this point, $t6 is child index
    beq $t1, $t2, is_is_one
    j in_has_one
    
is_is_one:
    move $t0, $a0
    li $t9, 4
    mul $t5, $t6, $t9
    add $t5, $t0, $t5 
    lw $t5, ($t5)   #$t5 = childNode
    
    move $t0, $a0
    
    mul $t7, $t9, $t2  #deleteIndex x 4
    add $t0, $t0, $t7
    sw $t5, ($t0)
    
    addi $sp, $sp, -48
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $t0, 16($sp)
    sw $t1, 20($sp)
    sw $t2, 24($sp)
    sw $t3, 28($sp)
    sw $t4, 32($sp)
    sw $t5, 36($sp)
    sw $t6, 40($sp)
    sw $ra, 44($sp)
    
    move $a0, $t3  #moves flag arr to $a0
    move $a1, $t6  #moves child index to $a1
    li $a2, 0  #li 0 to $a2
    move $a3, $t4  #moves max size to $a3
    
    jal set_flag
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $t0, 16($sp)
    lw $t1, 20($sp)
    lw $t2, 24($sp)
    lw $t3, 28($sp)
    lw $t4, 32($sp)
    lw $t5, 36($sp)
    lw $t6, 40($sp)
    lw $ra, 44($sp)
    addi $sp, $sp, 48
    
    j ret_one_delete
    
in_has_one:   #$t6 = child index 
    move $t0, $a0
    li $t9, 4
    mul $t8, $t2, $t9
    add $t0, $t0, $t8
    lh $t9, ($t0) #$t9 = nodes[deleteIndex].value
    move $t0, $a0

    addi $sp, $sp, -48
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $t0, 16($sp)
    sw $t1, 20($sp)
    sw $t2, 24($sp)
    sw $t3, 28($sp)
    sw $t4, 32($sp)
    sw $t5, 36($sp)
    sw $t6, 40($sp)
    sw $ra, 44($sp)
    
    move $a0, $t0  #nodes
    move $a1, $t1  #root index
    move $a2, $t9  #delete index val
    move $a3, $t2  #delete index
    
    jal get_parent
    
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $t0, 16($sp)
    lw $t1, 20($sp)
    lw $t2, 24($sp)
    lw $t3, 28($sp)
    lw $t4, 32($sp)
    lw $t5, 36($sp)
    lw $t6, 40($sp)
    lw $ra, 44($sp)
    addi $sp, $sp, 48
    move $t5, $v0  #t5 = parentIndex
    move $t7, $v1  #leftOrRight
    
    beqz $t7, del_left_1_node 
    li $t9, 4
    mul $t9, $t9, $t5  #parentInd x 4
    add $t0, $t0, $t9
    addi $t0, $t0, 2
    sb $t6, ($t0)
    j end_of_else_if

del_left_1_node:
    li $t9, 4
    mul $t9, $t9, $t5  #parentInd x 4
    add $t0, $t0, $t9
    addi $t0, $t0, 3
    sb $t6, ($t0)
    
end_of_else_if:
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    move $a0, $t3
    move $a1, $t2 
    li $a2, 0
    move $a3, $t4
    
    jal set_flag
   
    lw $ra, ($sp)
    addi $sp, $sp, 4
    
    j ret_one_delete
    
    
after_has_one:
    move $t0, $a0
    li $t9, 4
    mul $t5, $t2, $t9
    add $t0, $t0, $t5
    addi $t0, $t0, 2
    lb $t6, ($t0)  #nodes[deleteIndex].right
    move $t0, $a0

    addi $sp, $sp, -48
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $t0, 16($sp)
    sw $t1, 20($sp)
    sw $t2, 24($sp)
    sw $t3, 28($sp)
    sw $t4, 32($sp)
    sw $t5, 36($sp)
    sw $t6, 40($sp)
    sw $ra, 44($sp)
    
    move $a0, $a0
    move $a1, $t6
    
    jal find_min
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $t0, 16($sp)
    lw $t1, 20($sp)
    lw $t2, 24($sp)
    lw $t3, 28($sp)
    lw $t4, 32($sp)
    lw $t5, 36($sp)
    lw $t6, 40($sp)
    lw $ra, 44($sp)
    addi $sp, $sp, 48
    
    move $t5, $v0 #min_index
    move $t6, $v1 #min_is_leaf
    
    li $t9, 4
    mul $t9, $t9, $t5
    add $t0, $t0, $t9
    lh $t9, ($t0)  #nodes[minIndex].value
    

    addi $sp, $sp, -48
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $t0, 16($sp)
    sw $t1, 20($sp)
    sw $t2, 24($sp)
    sw $t3, 28($sp)
    sw $t4, 32($sp)
    sw $t5, 36($sp)
    sw $t6, 40($sp)
    sw $ra, 44($sp)
    
    move $a0, $a0
    move $a1, $t2
    move $a2, $t9
    move $a3, $t5
    
    jal get_parent
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $t0, 16($sp)
    lw $t1, 20($sp)
    lw $t2, 24($sp)
    lw $t3, 28($sp)
    lw $t4, 32($sp)
    lw $t5, 36($sp)
    lw $t6, 40($sp)
    lw $ra, 44($sp)
    addi $sp, $sp, 48
    
    move $t7, $v0  #parentInd
    move $t8, $v1  #leftOrRight
    
    beqz $t6, no_min_is_leaf  #checks if isLeaf
    beq $t8, 1, min_is_leaf_right
    
    li $t9, 4
    move $t0, $a0
    mul $t9, $t9, $t7
    add $t0, $t0, $t9
    addi $t0, $t0, 3
    li $t9, 255
    sb $t9, ($t0)
    move $t0, $a0
    j else_end
    
min_is_leaf_right:
    move $t0, $a0
    li $t9, 4
    mul $t9, $t9, $t7
    add $t0, $t0, $t9
    addi $t0, $t0, 2
    li $t9, 255
    sb $t9, ($t0)
    move $t0, $a0
    j else_end
     
    
no_min_is_leaf:
    move $t0, $a0
    beq $t8, 1 no_min_is_leaf_right  #do not need $t8 after this
    li $t8, 4
    mul $t8, $t8, $t5
    add $t0, $t0, $t8
    addi $t0, $t0, 2
    lb $t8, ($t0)  #$t8 = nodes[minIndex].right
    move $t0, $a0
    
    li $t9, 4
    mul $t9, $t9, $t7
    add $t0, $t0, $t9
    addi $t0, $t0, 3
    sb $t8, ($t0)  
    j else_end

no_min_is_leaf_right:
    move $t0, $a0
    beq $t8, 1 no_min_is_leaf_right  #do not need $t8 after this
    li $t8, 4
    mul $t8, $t8, $t5
    add $t0, $t0, $t8
    addi $t0, $t0, 2
    lb $t8, ($t0)  #$t8 = nodes[minIndex].right
    move $t0, $a0
    
    li $t9, 4
    mul $t9, $t9, $t7
    add $t0, $t0, $t9
    addi $t0, $t0, 2
    sb $t8, ($t0)  
    j else_end


else_end: #t6, t7, t8, t9 are free
    li $t9, 4
    mul $t8, $t9, $t5
    add $t0, $t0, $t8
    lh $t8, ($t0)  # nodes[minIndex].value
    
    move $t0, $a0
    li $t9, 4
    mul $t7, $t9, $t2
    add $t0, $t0, $t7
    sh $t8, ($t0)
    
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    move $a0, $a3
    move $a1, $t5
    li $a2, 0
    move $a3, $t4
    
    jal set_flag
    lw $ra, ($sp)
    addi $t4, $t4, 4


ret_one_delete:
    li $v0, 1
    jr $ra

ret_zero_delete:
    li $v0, 0
    jr $ra

##############################
# EXTRA CREDIT FUNCTION
##############################

add_random_nodes:
    move $t0, $a0  #nodes array
    move $t1, $a1  #max size
    move $t2, $a2  #root Index
    move $t3, $a3  #flags array
    lw $t4, 4($sp) #seed
    lw $t5, 0($sp) #fd
    
    blt $t2, 0, random_ret
    bge $t2, $t1, random_ret
    
    addi $sp, $sp, -8
    sw $a0, ($sp)
    sw $a1, 4($sp)
    
    li $a0, 0
    move $a1, $t4
    
    li $v0, 40
    syscall 
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    addi $sp, $sp, 8
    
    addi $sp, $sp, -36
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $t0, 8($sp)
    sw $t1, 12($sp)
    sw $t2, 16($sp)
    sw $t3, 20($sp)
    sw $t4, 24($sp)
    sw $t5, 28($sp)
    sw $ra, 32($sp)
    
    move $a0, $t3
    move $a1, $t1
    
    jal linear_search
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $t0, 8($sp)
    lw $t1, 12($sp)
    lw $t2, 16($sp)
    lw $t3, 20($sp)
    lw $t4, 24($sp)
    lw $t5, 28($sp)
    lw $ra, 32($sp) 
    addi $sp, $sp, 36
    
    
    move $t6, $v0  #new_index
    
new_index_loop:
    beq $t6, -1, get_out_new_index_loop
     
    addi $sp, $sp, -8
    sw $a0, ($sp)
    sw $a1, 4($sp)
    
    li $a0, 0
    li $a1, 65535
    
    li $v0, 42
    syscall
    
    move $t7, $a0  # newVal
    addi $t7, $t7, -32768
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    addi $sp, $sp, 8
    
    addi $sp, $sp, -48
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $t0, 8($sp)
    sw $t1, 12($sp)
    sw $t2, 16($sp)
    sw $t3, 20($sp)
    sw $t4, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)
    sw $t7, 36($sp)
    sw $a2, 40($sp)
    sw $ra, 44($sp)
    
    move $a0, $a0
    move $a1, $t2
    move $a2, $t7
    
    jal find_position
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $t0, 8($sp)
    lw $t1, 12($sp)
    lw $t2, 16($sp)
    lw $t3, 20($sp)
    lw $t4, 24($sp)
    lw $t5, 28($sp)
    lw $t6, 32($sp)
    lw $t7, 36($sp)
    lw $a2, 40($sp)
    lw $ra, 44($sp)
    addi $sp, $sp, 48
    
    move $t8, $v0  #parentIndex
    move $t9, $v1  #leftOrRight
    
    addi $sp, $sp, -12 #write(fd, "New value: ", 11)
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    
    move $a0, $t5
    la $a1, newVal
    li $a2 11
    
    li $v0, 15
    syscall
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    addi $sp, $sp, 12
    
    
    
    addi $sp, $sp, -52 #itof(fd, newValue)
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $t0, 8($sp)
    sw $t1, 12($sp)
    sw $t2, 16($sp)
    sw $t3, 20($sp)
    sw $t4, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)
    sw $t7, 36($sp)
    sw $t8, 40($sp)
    sw $t9, 44($sp)
    sw $ra, 48($sp)
    
    move $a0, $t5
    move $a1, $t7
    
    jal itof
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $t0, 8($sp)
    lw $t1, 12($sp)
    lw $t2, 16($sp)
    lw $t3, 20($sp)
    lw $t4, 24($sp)
    lw $t5, 28($sp)
    lw $t6, 32($sp)
    lw $t7, 36($sp)
    lw $t8, 40($sp)
    lw $t9, 44($sp)
    lw $ra, 48($sp)
    addi $sp, $sp, 52
    
    addi $sp, $sp, -12 #write(fd, "\n", 1)
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    
    move $a0, $t5
    la $a1, newline
    li $a2 1
    
    li $v0, 15
    syscall
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    addi $sp, $sp, 12
    
    addi $sp, $sp, -12 #write(fd, "Parent index: ", 14)
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    
    move $a0, $t5
    la $a1, parent
    li $a2 14
    
    li $v0, 15
    syscall
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    addi $sp, $sp, 12
    
    
    addi $sp, $sp, -52 #itof(fd, parentIndex)
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $t0, 8($sp)
    sw $t1, 12($sp)
    sw $t2, 16($sp)
    sw $t3, 20($sp)
    sw $t4, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)
    sw $t7, 36($sp)
    sw $t8, 40($sp)
    sw $t9, 44($sp)
    sw $ra, 48($sp)
    
    move $a0, $t5
    move $a1, $t8
    
    jal itof
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $t0, 8($sp)
    lw $t1, 12($sp)
    lw $t2, 16($sp)
    lw $t3, 20($sp)
    lw $t4, 24($sp)
    lw $t5, 28($sp)
    lw $t6, 32($sp)
    lw $t7, 36($sp)
    lw $t8, 40($sp)
    lw $t9, 44($sp)
    lw $ra, 48($sp)
    addi $sp, $sp, 52
    
    addi $sp, $sp, -12 #write(fd, "\n", 1)
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    
    move $a0, $t5
    la $a1, newline
    li $a2 1
    
    li $v0, 15
    syscall
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    addi $sp, $sp, 12
    
    addi $sp, $sp, -12 #write(fd, "Left (0) or right (1): ", 23)
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    
    move $a0, $t5
    la $a1, leftright
    li $a2, 23
    
    li $v0, 15
    syscall
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    addi $sp, $sp, 12
    
    
    addi $sp, $sp, -52 #itof(fd, leftOrRight);
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $t0, 8($sp)
    sw $t1, 12($sp)
    sw $t2, 16($sp)
    sw $t3, 20($sp)
    sw $t4, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)
    sw $t7, 36($sp)
    sw $t8, 40($sp)
    sw $t9, 44($sp)
    sw $ra, 48($sp)
    
    move $a0, $t5
    move $a1, $t9
    
    jal itof
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $t0, 8($sp)
    lw $t1, 12($sp)
    lw $t2, 16($sp)
    lw $t3, 20($sp)
    lw $t4, 24($sp)
    lw $t5, 28($sp)
    lw $t6, 32($sp)
    lw $t7, 36($sp)
    lw $t8, 40($sp)
    lw $t9, 44($sp)
    lw $ra, 48($sp)
    addi $sp, $sp, 52
    
    
    addi $sp, $sp, -12 # write(fd, "\n\n", 2)
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    
    move $a0, $t5
    la $a1, newline2
    li $a2, 2
    
    li $v0, 15
    syscall
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    addi $sp, $sp, 12
    
    addi $sp, $sp, -60 ######### ADDNODE ########
    sw $a1, ($sp)
    sw $a3, 4($sp)
    sw $t0, 8($sp)
    sw $t1, 12($sp)
    sw $t2, 16($sp)
    sw $t3, 20($sp)
    sw $t4, 24($sp)
    sw $t5, 28($sp)
    sw $t6, 32($sp)
    sw $t7, 36($sp)
    sw $t8, 40($sp)
    sw $t9, 44($sp)
    sw $a0, 48($sp)
    sw $a2, 52($sp)
    sw $ra, 56($sp)
    
    move $a0, $t0
    move $a1, $t2
    move $a2, $t7
    move $a3, $t6
    jal add_node
    
    lw $a1, ($sp)
    lw $a3, 4($sp)
    lw $t0, 8($sp)
    lw $t1, 12($sp)
    lw $t2, 16($sp)
    lw $t3, 20($sp)
    lw $t4, 24($sp)
    lw $t5, 28($sp)
    lw $t6, 32($sp)
    lw $t7, 36($sp)
    lw $t8, 40($sp)
    lw $t9, 44($sp)
    lw $a0, 48($sp)
    lw $a2, 52($sp)
    lw $ra, 56($sp)
    addi $sp, $sp, 60
    
    addi $sp, $sp, -24 ######### NEWINDEX ########
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $t0, 8($sp)
    sw $t2, 12($sp)
    sw $t5, 16($sp)
    sw $ra, 20($sp)
    
    move $a0, $t3 
    move $a1, $t1
    
    jal linear_search
    
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    lw $t0, 8($sp)
    lw $t2, 12($sp)
    lw $t5, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    
    move $t6, $v0
    
    j new_index_loop

get_out_new_index_loop:
    li $t9, 4
    mul $t2, $t2, $t9
    add $t2, $t2, $t0
    
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    move $a0, $t2
    move $a1, $t0
    move $a2, $t5
    
    jal preorder

    lw $ra, ($sp)
    addi $sp, $sp, 4
    
    jr $ra
        
random_ret:   
    jr $ra



#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
word: .space 12
newline: .asciiz "\n" 
newVal: .asciiz "New value: "
newline2: .asciiz "\n\n"
parent: .asciiz "Parent index: "
leftright: .asciiz "Left (0) or right (1): "
#place any additional data declarations here

