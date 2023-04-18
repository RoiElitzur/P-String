	.section	.rodata	#read only data section
formatCheck:    .string "%s\n"
formatScanLength:   .string "%d"
formatScanOpt:   .string "%d"
formatScanString:   .string "%s\0"
formatPrintString:   .string "%s\n"
	########
	.text	#the beginnig of the code
.globl	run_main

	.type	run_main, @function
run_main:	# the main function:
	pushq	%rbp		#save the old frame pointer
	movq	%rsp,	%rbp	#create the new frame pointer

	subq $528, %rsp     #sub %rsp for scanning pstrings

    movq $formatScanLength, %rdi        #scan the length of p1
    leaq -256(%rbp), %rsi       #transfer to scanf the adderss
    xorq %rax, %rax     #make sure %rax is zero
    call scanf

    movq $formatScanString, %rdi        #scan the string of p1
    leaq -255(%rbp), %rsi       #transfer to scanf the adderss
    xorq %rax, %rax
    call scanf

    movq $formatScanLength, %rdi        #scan the length of p2
    leaq -512(%rbp), %rsi       #transfer to scanf the adderss
    xorq %rax, %rax     #make sure %rax is zero
    call scanf

    movq $formatScanString, %rdi        #scan the string of p2
    leaq -511(%rbp), %rsi       #transfer to scanf the adderss
    xorq %rax, %rax
    call scanf

    movq $formatScanOpt, %rdi        #scan the opt of the user
    leaq -528(%rbp), %rsi       #transfer to scanf the adderss
    xorq %rax, %rax     #make sure %rax is zero
    call scanf

    movzbq -528(%rbp), %rdi   #tranfer opt to func_select
    leaq   -256(%rbp), %rsi   #transfer &p1 to func_select
    leaq   -512(%rbp), %rdx   #transfer &p2 to func_select
    call run_func

    xorq %rax, %rax
	movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)







