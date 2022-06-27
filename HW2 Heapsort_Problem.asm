#############################################################
#     HW2: Heapsort to sort numbers in increasing order		#
#     학번:               12181539                              		#
#     이름:               조권호                              		#
#############################################################
#
#  Data segment
#
	.data
	count:		.word 0			# number of elements in integer array
	array: 		.word 0:40		# data buffer for integer array
	input:		.space 64		# buffer for input string
	message1: 	.asciiz "Enter numbers be sorted: "	# output message 1
	message2:	.asciiz "Sorted output: "			# output message 2
	
#
#  Text segment
#
	.text
main:    
		jal	data_input		# data_input으로 이동
		
		#	$a0: input address
		la	$a1,array 	# load array address as $a1
		lw	$a2,count 	# load count as $a2
		li	$t0,0 		# temp
		jal	setArray 	# setArray으로 이동
				
		jal	heapSort	# heapSort로 이동		
		
		la	$a2,array 	# load array address
		lw	$a3,count 	# load count number
		li	$t5,0 		# temp
		jal	printArray 	# printArray로 이동

_end:		
		li 	$v0,10      	# system call for exit       
        	syscall   			# EXIT!

#
# Build heap (프로그램 필요)
#
heapSort:						# for loop_0 to build heap
		addiu	$sp,$sp,-16 	# push stack
		sw	$s2,12($sp) 	# store $s2
		sw	$s1,8($sp) 	# store $s1
		sw	$s0,4($sp) 	# store $s0
		sw	$ra,0($sp) 	# store $ra

#initialize index for build_heap loop
		lw	$s0,count 	# $s0=count
		srl	$s0,$s0,1 	# $s0=count/2
		addi	$s0,$s0,-1 	# $s0=count/2-1
		
#initialize index for extract_heap loop
		lw	$s1,count 	# $s1=count
		addi	$s1,$s1,-1 	# s1=count-1
		
		j	build_heap 	# build_heap로 이동
		
loop_build_heap:
		addi	$s0,$s0,-1 	# i 하나씩 감소
		
build_heap:
		blt	$s0,0,extract_heap 	# if $s0 less than 0-> extract_heap
		
		move	$a0,$s0 	# copy
		lw	$a1,count 	# load count to $a1
		jal	heapify 	# heapify로 이동 =>(arr,n,i)
		
		j	loop_build_heap 	# loop_build_heap로 이동
		
loop_extract_heap:
		addi	$s1,$s1,-1 	# i 하나씩 감소

#
# One by one extraction from heap  (프로그램 필요)
#

extract_heap:
		ble	$s1,0,end_heapSort 	# ifi less, equal than 0 -> end_heapSort
		
		sll	$s1,$s1,2 	# ix4
		la	$a3,array 	# load &arr[0] to $a3
		addu	$a3,$a3,$s1 	# $a3 = &arr[i]
		srl	$s1,$s1,2 	# i/4
		la	$a2,array 	# load &arr[0] to $a2
		jal	swap 		# swap실행 (&arr[0],&arr[i])
		
		move	$a1,$s1 	# $a1 = i
		li	$a0,0 		# $a0 = 0
		jal	heapify 	# heapify로 이동 => (arr,i,0)
		
		j	loop_extract_heap 	# loop_extract_heap로 이동

end_heapSort:
		lw	$s2,12($sp) 	# load $s2
		lw	$s1,8($sp) 	# load $s1
		lw	$s0,4($sp) 	# load $s0
		lw	$ra,0($sp) 	# load $ra
		addiu	$sp,$sp,16 	# pop stack
		jr	$ra 		# return to main
		
#
# Implement heapify  (프로그램 필요)
#
heapify: 	#arguments: int n=$a1, int i=$a0
		subiu	$sp,$sp,28 	# push stack
		sw	$s5,24($sp) 	# store $s5 to stack
		sw	$s4,20($sp) 	# store $s4 to stack
		sw	$s3,16($sp) 	# store $s3 to stack
		sw	$s2,12($sp) 	# store $s2 to stack
		sw	$s1,8($sp) 	# store $s1 to stack
		sw	$s0,4($sp) 	# store $s0 to stack
		sw	$ra,0($sp) 	# store $ra
		
		move	$s0,$a0 	# $s0= largest =i
		
		sll	$a0,$a0,1 	# 2xi
		addi	$s1,$a0,1 	# $s1= l = 2xi+1
		addi	$s2,$a0,2 	# $s2= r = 2x2+2
		srl	$a0,$a0,1 	# i/2
		
		sll	$s0,$s0,2 	# 4xlargest
		sll	$s1,$s1,2 	# 4xl
		sll	$s2,$s2,2 	# 4xr
		
		la	$s3,array 	# $s3 = &array[0]
		addu	$s3,$s3,$s0 	# $s3= &arr[largest]
		
		la	$s4,array 	# $s4 = &array[0]
		addu	$s4,$s4,$s1 	# $s4 = &arr[l]
		
		la	$s5,array 	# $s5 = &array[0]
		addu	$s5,$s5,$s2 	# s5 = array[r]
		
		srl	$s0,$s0,2 	# largest
		srl	$s1,$s1,2 	# l
		srl	$s2,$s2,2 	# r
		
#if 1
		bge	$s1,$a1,heapify_if2 	# if l bigger, equal than n-> heapify_if2
		lw	$t0,($s4) 	# $t0 = arr[l]
		lw	$t1,($s3) 	# $t1 = arr[largest]
		ble	$t0,$t1,heapify_if2 	# ifarr[l] less, equal than arr[largest])->heapify_if2
		
		move	$s0,$s1 	# largst=l
		la	$s3,($s4) 	# arr[largest]=arr[l]

heapify_if2:
		bge	$s2,$a1,heapify_if3 	# if r bigger, equal than n-> heapify_if3
		lw	$t0,($s5) 	# $t0 = arr[r]
		lw	$t1,($s3) 	# $t1 = arr[largest]
		ble	$t0,$t1,heapify_if3 	# if arr[r] less, eqaul than arr[largest]) -> heapify_if3
		
		move	$s0,$s2 	# largst=r
		la	$s3,($s5) 	# arr[largest]=arr[r]

heapify_if3:
		beq	$s0,$a0,end_heapify 	# if largest eqaul i -> end heapify
		
		sll	$t0,$a0,2 	# $t0 = 4xi
		sll	$t1,$s0,2 	# $t1 = 4xlargest
		
		la	$a2,array 	# $a2 = &array[0]
		addu	$a2,$a2,$t0 	# $a2 = &array[i]
		la	$a3,array 	# $a3 = &array[0]
		addu	$a3,$a3,$t1 	# $a3 = &array[largest]
		jal	swap 		# swap (&arr[i],&arr[largest])
		
		move	$a0,$s0 	# use largest
		jal	heapify 	# heapify(arr,n,largest)
		
end_heapify:
		lw	$s5,24($sp) 	# load $s5 from stack
		lw	$s4,20($sp) 	# load $s4 from stack
		lw	$s3,16($sp) 	# load $s3 from stack
		lw	$s2,12($sp) 	# load $s2 from stack
		lw	$s1,8($sp) 	# load $s1 from stack
		lw	$s0,4($sp) 	# load $s0 from stack
		lw	$ra,0($sp) 	# load %ra
		addiu	$sp,$sp,28 	# pop stack
		jr	$ra 		# return

#
#  swap function  (프로그램 필요)
#
swap: #arguments:$a2,$a3
		lw	$t2,0($a2) 	# load 1st to $t2
		lw	$t3,0($a3) 	# load 2nd to $t3
		sw	$t2,0($a3) 	# change $a3 to $a2
		sw	$t3,0($a2) 	# change $a2 to $a3
		jr	$ra

#
#  Accept input data
#
data_input:
		la 	$a0,message1  		# print 
		li 	$v0,4				# "Enter numbers be sorted: "input (e.g.):"
		syscall
		
		la 	$a0,input			# load input buffer from keyboard         
		li  	$a1,64				# max string length = 60  
		li  	$v0,8 	    		# read string
		syscall
		
		jr	$ra	#return to main

# setArray
# read string and store on 'array'
# $a0: base address of input string / $a1: base address of array / $a2: count
loop_set:
		sw	$t0,0($a1) 	# store read value to array
		li	$t0,0 		# reset $t0 =0
		addi	$a2,$a2,1 	# count 하나씩 더함
		la	$a1,4($a1) 	# 다음 정수
		la	$a0,1($a0) 	# 다음 문자
	
setArray:
		lb	$t1,0($a0) 	# fetch character from input string
		beq	$t1,32,loop_set 	# if(space)-> loop_set
		beq	$t1,10,end_setArray 	# if(enter -> end setArray
	
		addi	$t1,$t1,-48 	# 문자->숫자
		mul	$t0,$t0,10 	# 10 x next number
		add	$t0,$t0,$t1 	# add number
		addiu	$a0,$a0,1 	# next character address
		j	setArray 	# loop

end_setArray:
		sw 	$t0,0($a1) 	# store last number to array
		addi	$a2,$a2,1 	# count for last number
		sw	$a2,count 	# store count number to count
		jr	$ra 		# return to main

#printArray
plus:
		beq	$t5,$a3,_end 	# if($t5==count) -> _end
		addi	$a2,$a2,4 	# next array element

printArray:
		lw	$a0,0($a2) 	# load interger
		li	$v0,1		# print integer
		syscall
	
		li 	$a0,32 		# 32: ' ' (space)
		li 	$v0,11 		# print character
		syscall
	
		addi 	$t5,$t5,1 	# $t5 하나씩 더함
		j 	plus 		# jump to plus
	
