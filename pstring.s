	.section	.rodata	#read only data section
formatCheck:    .string "%s\n"
formatC:    .string "%c\n"
formatCCC: .string "check\n"
formatInt: .string "%d\n"
formatInvalidInput:   .string  "invalid input!\n"
	########
	.text	#the beginnig of the code
.globl	pstrlen, replaceChar, pstrijcpy, swapCase, pstrijcmp
	
	
	.type	pstrlen, @function	
pstrlen:	# the main function:
	pushq	%rbp		#save the old frame pointer
	movq	%rsp,	%rbp	#create the new frame pointer

    # %rdi = &p
    xorq %rax, %rax     #make sure %rax is zero
    movzbq 0(%rdi), %rax    #put the return value in %rax

	movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)


	.type	replaceChar, @function
replaceChar:
	pushq	%rbp		#save the old frame pointer
    movq	%rsp,	%rbp	#create the new frame pointer

    movq %rdi, %r11         #save pointer to beginning of the string in the memory
    xorq %r9 ,%r9
    movzbq 0(%rdi), %r9     #put in %r9 the size of the string
    incq %rdi       #add one to be in the first letter of the string
    .loop:
    cmpq $0 , %r9  #check if the itaeration are more than the string length
    je .endLoop

    movzbq 0(%rdi), %rcx    #put the current char in %rcx
    cmpq %rcx, %rsi         #compare the current char with the new char
    je .same                #jump if the same

    incq %rdi   #go to the next letter in the string
    decq %r9   #count the iteration
    jmp .loop

    .same:
    movb %dl, (%rdi)   #insert the new char to to the string
    incq %rdi   #go to the next letter in the string
    decq %r9   #count the iteration
    jmp .loop
    .endLoop:

    movq	%r11, %rax	#return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
    popq	%rbp		#restore old frame pointer (the caller function frame)
    ret			#return to caller function (OS)
	

	.type	pstrijcpy, @function
pstrijcpy:
	pushq	%rbp		#save the old frame pointer
    movq	%rsp,	%rbp	#create the new frame pointer
    pushq %rbx

    # %rdi = &dst, %rsi = &src, %rdx = char i, %rcx = char j
    movq %rdi, %r11

    #movq $formatInt, %rdi
    #movq %rdx, %rsi
    #xorq %rax, %rax
    #call printf
    #
    #movq $formatC, %rdi
    ##xorq %rsi, %rsi
    ##movl -16(%rbp), %esi
    #movq %rcx, %rsi
    ##movq (%rsi), %rsi
    #xorq %rax, %rax
    #call printf


    #movq $formatC, %rdi
    ##xorq %rsi, %rsi
    ##movl -16(%rbp), %esi
    #movq %rdx, %rsi
    ##movq (%rsi), %rsi
    #xorq %rax, %rax
    #call printf

    movzbq 0(%rdi), %r8     #move the length of dst to %r8

    cmpq   %r8, %rdx        # check if length dst < i
    ja .invalidInput

    cmpq   %r8, %rcx        # check if length dst < j
    ja .invalidInput

    movzbq 0(%rsi), %r9     #move the length of src to %r9

    cmpq   %r9, %rdx        # check if length dst < i
    ja .invalidInput

    cmpq   %r9, %rcx        # check if length dst < j
    ja .invalidInput

    #done checks valid input

    movq %rdx, %r8  #move the value of i to %r8
    incq %rsi   #add one byte for looking on the first letter of the pstring
    incq %rdi   #add one byte for looking on the first letter of the pstring
    .promote:
    cmpq $0, %r8    #checks if there were enough iterations
    je .conn
    incq %rsi   #add one byte for looking on the next letter of the pstring
    incq %rdi   #add one byte for looking on the next letter of the pstring
    decq %r8    #decrease the counter of the iterations by one
    jmp .promote

    .conn:
    subq %rdx, %rcx     #calculates j - i
    incq %rcx       # increase the count iterations by 1
    .cpy:
    cmpq $0, %rcx      #checks if there were enough iterations
    je .endFuncp

    movzbq 0(%rsi), %r9     #move the current char in src to %r9
    movb %r9b, (%rdi)       # copy the char to the same place in dst
    incq %rdi       # move to the next letter in dst
    inc %rsi        # move to the next letter in src
    decq %rcx       #decrease the counter
    jmp .cpy        #jump for another iteration in the loop

    jmp .endFuncp   # jump to the end of the function

    .invalidInput:
    movq $formatInvalidInput, %rdi   #transfer the format to printf
    xorq %rax, %rax     #make sure %rax  is zero
    call printf

    .endFuncp:

    movq	%r11, %rax      #put the result after the copy in %rax
    popq    %rbx            # restore the old value of %rbx
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
    popq	%rbp		#restore old frame pointer (the caller function frame)
    ret			#return to caller function (OS)



	.type	swapCase, @function
swapCase:
		pushq	%rbp		#save the old frame pointer
        movq	%rsp,	%rbp	#create the new frame pointer

        movq %rdi, %r11

        movzbq 0(%rdi), %r8     #put p length to %r8
        incq %r11       #look on the first letter of p

        .swapLoop:
        cmpq $0, %r8       #check if there were enough iterations
        je .endSwap      #jump to the end of the swap process

        movzbq 0(%r11), %r9     #move the current char to %r9
        cmpq $64, %r9    #check if tha ascii value is more than 64
        ja .above64
        incq %r11   #move to the next letter
        decq %r8    #count the iteration
        jmp .swapLoop

        .above64:
        cmpq $90, %r9    #check if the ascii value is less or equal 90
        jle .big
        cmpq $96, %r9
        ja .above96
        incq %r11   #move to the next letter
        decq %r8    #count the iteration
        jmp .swapLoop

        .above96:
        cmpq $122, %r9  #check if the ascii value is less or equal 90
        jle .little
        incq %r11   #move to the next letter
        decq %r8    #count the iteration
        jmp .swapLoop

        .little:
        subq $32, %r9
        movb %r9b, (%r11)
        incq %r11   #move to the next letter
        decq %r8    #count the iteration
        jmp .swapLoop

        .big:
        addq $32, %r9
        movb %r9b, (%r11)
        incq %r11   #move to the next letter
        decq %r8    #count the iteration
        jmp .swapLoop






        .endSwap:
        movq	%rdi, %rax	#return the pstring after the change
        movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
        popq	%rbp		#restore old frame pointer (the caller function frame)
        ret			#return to caller function (OS)


	.type	pstrijcmp, @function
pstrijcmp:	
		pushq	%rbp		#save the old frame pointer
        movq	%rsp,	%rbp	#create the new frame pointer
        pushq %rbx

        #check i,j are valid values
        movzbq 0(%rdi), %r8     #move the length of dst to %r8

        cmpq   %r8, %rdx        # check if length p1 < i
        ja .notValid

        cmpq   %r8, %rcx        # check if length p1 < j
        ja .notValid

        movzbq 0(%rsi), %r9     #move the length of p2 to %r9

        cmpq   %r9, %rdx        # check if length p2 < i
        ja .notValid

        cmpq   %r9, %rcx        # check if length p2 < j
        ja .notValid

        #done checks valid input

       movq %rdx, %r8   #save the value of i in %r8
       movq %rcx, %r9   #save the value of j in %r9

       subq %rdx, %rcx  #calulates j - i, and insert the result into %rcx
       incq %rcx    #increment the value of %rcx by 1

       incq %rdi    #look on the first letter of p1
       incq %rsi    #look oon the first letter of p2
       .oneStep:
       cmpq $0, %rdx    #checks if there were enough iterations
       xorq %r10, %r10  #make sure %r10 is zero and use it as a counter
       xorq %r11, %r11  #make sure %r11 is zero and use it as a counter
       je .continue
       incq %rsi   #add one byte for looking on the next letter of the pstring
       incq %rdi   #add one byte for looking on the next letter of the pstring
       decq %rdx    #decrease the counter of the iterations by one
       jmp .oneStep


       .continue:
       cmpq $0, %rcx     #checks of there were enough iterations
       je .checkReturn

       movzbq 0(%rdi), %rbx     #move the current char in p1 to %rbx
       addq %rbx, %r10   #adds the ascii value of the current char in p1 to %r10
       movzbq 0(%rsi), %rbx     #move the current char in p2 to %rbx
       addq %rbx, %r11   #adds the ascii value of the current char in p2 to %r11

       incq %rdi    #look on the next letter in p1
       incq %rsi    #look on the next letter in p2
       decq %rcx    #count the iteration
       jmp  .continue

        .notValid:
        movq $formatInvalidInput, %rdi      #transfer print format to printf
        xorq %rax, %rax     #make sure %rax is zero
        call printf
        movq $-2, %rax      #insert the return value to %rax
        jmp .endOfFunction


       .checkReturn:
       cmpq %r11, %r10  #check %r11 < %r10
       je .return0  #if equal
       ja .return1  #if %r11 < %r10
       jmp .returnNeg    #if %r11 > %r10


       .return0:
       xorq %rax, %rax
       jmp .endOfFunction

       .return1:
       movq $1, %rax
       jmp .endOfFunction

       .returnNeg:
       movq $-1, %rax

        .endOfFunction:
        popq %rbx
        movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
        popq	%rbp		#restore old frame pointer (the caller function frame)
        ret			#return to caller function (OS)
