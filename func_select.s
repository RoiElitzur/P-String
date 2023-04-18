# 206780652 Roi Elitzur
	.data #initializing global variables
	.section	  .rodata			#read only data section
    .align 8
.switchCase:
    .quad .default #case 30
    .quad .L31 #case 31
    .quad .L32L33 #case 32
    .quad .L32L33 #case 33
    .quad .default #case 34
    .quad .L35 #case 35
    .quad .L36 #case 36
    .quad .L37 #case 37
    

format31:   .string "first pstring length: %d, second pstring length: %d\n"     #printing case 31
formatPrintChar:    .string "%c\n"
formatScanChar:    .string   " %c"
formatScanInt:     .string "%d"
formatPrintInt:    .string "%d\n"
formatL36:     .string "length: %d, string: %s\n "
formatCheck:    .string "check\n"
format32_33:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format35:   .string "length: %d, string: %s\n"
formatInvalidOption:    .string "invalid option!\n"
format36:   .string "length: %d, string: %s\n"
format37:   .string "compare result: %d\n"


	.text	#the beginnig of the code
    .globl run_func 	#the label "main" is used to state the initial point of this program

	.type	run_func, @function
    run_func:
        push %rbp   #save the old address of %rbp
        movq %rsp, %rbp #move %rbp to be where %rsp

        # %rdi = opt, %rsi = &p1, %rdx = &p2
        movq %rsi, %r12     #save &p1 in %r12
        movq %rdx, %r13     #save &p2 in %r13
        movq %rdi, %r14     #save opt in %r14

        #  set up the jump table access
        leaq -30(%rdi), %rsi    #convert every case to be less 30 
        cmpq $7, %rsi   #copmare which case
        ja .default # if > 7 go to default case
        jmp *.switchCase(,%rsi,8)    #go to the specific case in the switch case
	

    .L31:
        movq %r12, %rdi     #transfer the address of p1 to pstrlen
        call pstrlen
        movq %rax, %rbx     #save the length of p1 in %rbx

        movq %r13, %rdi     #transfer the address of p2 to pstrlen
        call pstrlen
        movq %rax, %rdx     #transfer the length of p2 to printf
        movq %rbx, %rsi     #transfer the length of p1 to printf
        movq $format31, %rdi    #transfer the format to printf
        xorq %rax, %rax     #make sure %rax is zero for printf
        call printf

        jmp .finish

    .L32L33:
        sub $16, %rsp   #save place for the old char and new char, sace 16 even though need only to for align of 16.

        #movq $formatEnterChars, %rdi
        #xorq %rax, %rax
        #call printf
       
        movq $formatScanChar, %rdi  #insert the label to %rdi
        leaq -1(%rbp), %rsi     #send to scanf the address to put the scan char  
        xorq %rax, %rax     #insert zero to %rax
        call scanf
        
        
        movq $formatScanChar, %rdi      #insert the label to %rdi
        leaq -2(%rbp), %rsi      #send to scanf the address to put the scan char 
        xorq %rax, %rax     #insert zero to %rax
        call scanf
        
       #movq $formatScanChar, %rdi      #insert the label to %rdi
       #leaq -3(%rbp), %rsi      #send to scanf the address to put the scan char
       #xorq %rax, %rax     #insert zero to %rax
       #call scanf


       #movq $formatPrintChar, %rdi
       #xorq %rsi, %rsi
       #movb -1(%rbp), %sil
       #xorq %rax, %rax
       #call printf

        movq %r12, %rdi     #transfer p1 to replaceChar function
        xorq %rsi, %rsi     #make sure %rsi is zero
        movb -1(%rbp), %sil     #transfer old char to replace Char
        xorq %rdx, %rdx
        movb -2(%rbp), %dl       #transfer new char to replace Char
        call replaceChar

        movq %rax, %r14     #save the result in %r14

        #do the same operation for p2
         movq %r13, %rdi     #transfer p2 to replaceChar function
         xorq %rsi, %rsi     #make sure %rsi is zero
         movb -1(%rbp), %sil     #transfer old char to replace Char
         xorq %rdx, %rdx
         movb -2(%rbp), %dl       #transfer new char to replace Char
         call replaceChar

        movq $format32_33, %rdi     #transfer the format to printf
        xorq %rsi, %rsi         #make sure %rsi is zero
        movb -1(%rbp), %sil     #insert old char to %rsi
        xorq %rdx, %rdx     #make sure %rdx is zero
        movb -2(%rbp), %dl      #insert new char to %rsi
        movq %r14, %rcx         #transfer the result of p1 to printf
        incq %rcx       #pass on the num to get to the beginning of the string
        movq %rax, %r8  #transfer the result of p2 to printf
        incq %r8    #pass on the num to get to the beginning of the string
        xorq %rax, %rax
        call printf
        
        jmp .finish
    
    .L35:
        sub $16, %rsp   # allocates 16 bytes for scanning numbers
        
        
        movq $formatScanInt, %rdi   #transfer the scan format to scanf
        xorq %rsi, %rsi     #make sure %rsi is zero
        leaq -8(%rbp), %rsi     #move the address to scan to scanf
        xorq %rax, %rax     #insert zero to %rax
        call scanf

        movq $formatScanInt, %rdi   #transfer the scan format to scanf
        xorq %rsi, %rsi     #make sure %rsi is zero
        leaq -16(%rbp), %rsi    #move the address to scan to scanf
        xorq %rax, %rax     #insert zero to %rax
        call scanf

        movq %r12, %rdi     #transfer p1 as dst
        movq %r13, %rsi     #transfer p2 as src
        movzbq -8(%rbp), %rdx       #transfer i
        movzbq -16(%rbp), %rcx      #tranfer j
        call pstrijcpy

        movq $format35, %rdi    #transfer the print format to printf
        movzbq 0(%rax), %rsi    #transfer the length of the pstring to printf
        incq %rax
        movq %rax, %rdx     #transfer pointer to dst after the copy to printf
        xorq %rax, %rax     #make sure %rax is zero
        call printf

        movq $format35, %rdi    #transfer the print format to printf
        movzbq 0(%r13), %rsi    #transfer the length of the pstring to printf
        movq %r13, %rax     #copy the address of p2 to %rax
        incq %rax
        movq %rax, %rdx     #transfer pointer to src  to printf
        xorq %rax, %rax     #make sure %rax is zero
        call printf

        jmp .finish
    
    
    .L36:
        movq %r12, %rdi     #transfer &p1 to swapCase
        call swapCase

        movq $format36, %rdi    #transfer the print format to printf
        movzbq 0(%rax), %rsi    #transfer the length of the pstring to printf
        incq %rax
        movq %rax, %rdx     #transfer pointer to dst after the copy to printf
        xorq %rax, %rax     #make sure %rax is zero
        call printf

        movq %r13, %rdi     #transfer &p2 to swapCase
        call swapCase

        movq $format36, %rdi    #transfer the print format to printf
        movzbq 0(%rax), %rsi    #transfer the length of the pstring to printf
        incq %rax
        movq %rax, %rdx     #transfer pointer to dst after the copy to printf
        xorq %rax, %rax     #make sure %rax is zero
        call printf


        jmp .finish
    
    
    .L37:
        #scan two numbers from user  i ,j
        sub $16, %rsp   #sub %rsp for generate place for two int nums
        
        
        movq $formatScanInt, %rdi   #transfer the scan format to scanf
        xorq %rsi, %rsi     #make sure %rsi is zero
        leaq -8(%rbp), %rsi     #give scanf the address to insert the scan
        xorq %rax, %rax     #insert zero to %rax
        call scanf
        
        
        
        movq $formatScanInt, %rdi   #transfer the scan format to scanf
        xorq %rsi, %rsi     #make sure %rsi is zero
        leaq -16(%rbp), %rsi    #give scanf the address to insert the scan
        xorq %rax, %rax     #insert zero to %rax
        call scanf
        
        
        #movq $formatPrintInt, %rdi
        #xorq %rsi, %rsi
        #leaq -16(%rbp), %rsi
        #xorq %rax, %rax
        #call printf

        movq %r12, %rdi     #transfer p1
        movq %r13, %rsi     #transfer p2
        movzbq -8(%rbp), %rdx       #transfer i
        movzbq -16(%rbp), %rcx      #tranfer j
        call pstrijcmp

        movq $format37, %rdi    #transfer the print format to printf
        movq %rax, %rsi         #transfer the result of the compare to printf
        xorq %rax, %rax         #make sure %rax is zero
        call printf
       
        jmp .finish


    .default:
    movq $formatInvalidOption, %rdi     #transfer the print format to printf
    xorq %rax, %rax
    call printf




    .finish:
        

        	movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (main)
