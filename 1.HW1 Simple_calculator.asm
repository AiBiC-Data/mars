###################################
#  HW1: Simple string calculator  #
###################################
#
#  Data segment
#
		.data
input:		.asciiz  "Enter input (e.g. 1+2): "	# accept input expression
error:		.asciiz  "Input error!" 
sol:    	.asciiz  "Answer = "	# label for "Anmswer: " 
plus: 		.asciiz  "+"		# label for "+"
minus:		.asciiz  "-"		# label for "-"
multiply:	.asciiz	  "*"		# label for "*"
divide:		.asciiz  "/"		# label for "/"	
exp:		.word 	 0:15   	# define buffer for input string
size: 		.word  	 15			# size of buffer

#
#  Text segment
#
		.text
main:	la 	$a0,input  		# print 
		li 	$v0,4			# "Enter input (e.g.):"
		syscall
		la 	$a0,exp			# load Buffer for input string         
		la  $a1,size		# load size to $a1  
		li  $v0,8 	    	# read string
		syscall
		
		jal load_input		# load operand1, 2, operator
		jal	operator		# decide operation
		jal	print			# print result
		
_end:	li 	$v0,10      	# system call for exit       
        syscall   			# EXIT!
		
#
#  Subroutine to load operands & operator, and to print the result 
#

Loop1:		la	$a0,1($a0)	# 1byte increment $a0: address of next character of string

load_input:	lb	$t0,0($a0)     	#Load charcter's ascii value from $a0 to $to
		blt	$t0,48,load_operator	#if ($t0<48('0'))->go to load_operator
		bgt	$t0,57,load_operator	#if ($t0>57('9'))-> go to load_operator 		
		addi 	$t0,$t0,-48 	# ascii to integer          
		mul	$s0,$s0,10	# multiply $s0*10 
		add	$s0,$s0,$t0	#$add interger s0*10+$t0
		j	Loop1		#go to Loop1
		
load_operator:		lb 	$t1,0($a0)		# load operand 2 to $t1
			la	$a0,1($a0)		# pointing first number of operand2
			lb	$t0,0($a0)		# Load next charcter of string
			j	load_operand2		#go to kable Load_operand2
			
Loop2:		mul	$s1,$s1,10	#multiply $s0*10			    

load_operand2:	addi	$t0,$t0,-48	#change $t0 character->integer
		add	$s1,$s1,$t0	#add integer $s0*10+$t0
		la	$a0,1($a0)	#1byte increment $a0: address of next character of string
		lb	$t0,0($a0)	#Load charcter's ascii value from $a0 to $t0
		beq	$t0,10,end_load_input	#if ($t0 !=10(\n))->go to end_load_input
		blt	$t0,48,not_allowed	#if ($t0<48('0'))->go to not_allowed
		bgt	$t0,57,not_allowed	#if ($t0>48('9'))->go to not_allowed
		j	Loop2		#jump to Loop2
		
end_load_input:	jr	$ra	#go to return address		 		   
		 		               
operator:	lb 		$t5,plus		# load "+" to $t5
		lb		$t6,minus		# load "-" to $t6
		lb		$t7, multiply		# load "*" to $t7
		lb		$t8, divide		# load "/" to $t8
		beq 	$t1,$t5,add_op	# goto add operation  
		beq 	$t1,$t6,sub_op	# goto sub operation  
		beq 	$t1,$t7,mul_op	# goto mul operation  
		beq 	$t1,$t8,div_op	# goto div operation  

not_allowed:	la 		$a0,error    	# print
		li 		$v0,4			# "Input error"
		syscall
		b		_end


add_op:   	add 	$s2,$s0,$s1		# operand1 + operand2
        	jr 		$ra				# return from subroutine 
        	
sub_op:  	sub 	$s2,$s0,$s1		# operand1 - operand2
		jr 		$ra				# return from subroutine 
			
mul_op:   	mul  	$s2,$s0,$s1		# operand1 * operand2
        	jr 		$ra				# return from subroutine 
        	
div_op:  	div	$s2,$s0,$s1		# operand1 / operand2
		jr 		$ra				# return from subroutine 


print: 		la 		$a0,sol    		# load "=" to $a0
		li 		$v0,4			# print "="
		syscall
		la 		$a0,0($s2)  	# load result to $a0
		li 		$v0,1       	# print result		
		syscall
		jr 		$ra				# return from subroutine 

