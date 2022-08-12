// 322805029 Roni Gotlib
.section    .rodata
printf_pstrlen:
    .string "first pstring length: %d, second pstring length: %d\n"
scanf_char:
    .string " %c%*c"
printf_replace_char:
    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
printf_defult:
    .string "invalid option!\n"
printf_len_str:
    .string "length: %d, string: %s\n"
scanf_index:
    .string "%d"
print_pstrijcmp:
    .string "compare result: %d\n"




.align 8    # Align address to multiple of 8
.L10:
.quad   .L1 # Case 50: loc_A
.quad   .L9 # invalid input 51: loc_def
.quad   .L2 # Case 52: loc_B
.quad   .L3 # Case 53: loc_C
.quad   .L4 # Case 54: loc_D
.quad   .L5 # Case 55: loc_E
.quad   .L9 # invalid input 56: loc_def
.quad   .L9 # invalid input 57: loc_def
.quad   .L9 # invalid input 58: loc_def
.quad   .L9 # invalid input 59: loc_def
.quad   .L1 # Case 60: loc_A
.quad   .L9 # invalid input > 60: loc_def

.text
.global run_func
run_func:
    pushq   %rbp                    # push the registers to the stack
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15
    movq    %rsp, %rbp


# Set up the jump table access
    leaq    -50(%rdi), %rdi         # Compute xi = x-50
    cmpq    $10, %rdi               # Compare xi:10
    ja      .L9                     # if >, goto default-case
    jmp      *.L10(,%rdi,8)         # Goto jt[xi]

# Case 50 or Case 60
.L1:                                #loc_A
    movq    %rsi, %rdi              # pstrlen 1
    call    pstrlen
    movq    %rax, %r12              # len of pstrlen 1

    movq    %rdx, %rdi              # pstrlen 2
    xorq    %rax, %rax
    call    pstrlen
    movq    %rax, %r13              # len of pstrlen 2

    movq    %r12, %rsi              # len 1
    movq    %r13, %rdx              # len 2
    movq    $printf_pstrlen, %rdi   # print message
    xorq    %rax, %rax              # rax = 0
    call    printf

    jmp .L0                         # jump to done


# Case 52
.L2:                                # loc_B
    movq    %rsi, %r12              # r12 = p1
    movq    %rdx, %r13              # r13 = p2
    and     $0xf0, %spl             # alignes the stack pointer

    xorq    %rdi, %rdi
    movq    $scanf_char, %rdi
    movq    %rsp, %rsi
    xorq    %rax, %rax
    call    scanf
    movq    (%rsp), %r14            # old char

    xorq    %rdi, %rdi
    movq    $scanf_char, %rdi
    movq    %rsp, %rsi
    xorq    %rax, %rax
    call    scanf
    movq    (%rsp), %r15            # new chars

    #pstr1:
    movq    %r12, %rdi              # pstr1
    movq    %r14, %rsi              # old char
    movq    %r15, %rdx              # new char
    call    replaceChar
    movq    %rax, %r12              # new pstr1
    addq    $1,    %r12

    #pstr2:
    movq    %r13, %rdi              # pstr2
    movq    %r14, %rsi              # old char
    movq    %r15, %rdx              # new char
    call    replaceChar
    movq    %rax, %r13              # new pstr2
    addq    $1,   %r13

    movq    $printf_replace_char, %rdi
    movq    %r14, %rsi              # old char
    movq    %r15, %rdx              # new char
    movq    %r12, %rcx              # pstr1
    movq    %r13, %r8               # pstr2
    xorq    %rax, %rax
    call    printf                  # print the message


    jmp .L0                         # jump to done

# Case 53
.L3:                                # loc_C
    movq    %rsi, %r12              # r12 = dst pstr
    movq    %rdx, %r13              # r13 = src pstr
    and     $0xf0, %spl

    xorq    %rdi, %rdi
    movq    $scanf_index, %rdi
    movq    %rsp, %rsi
    xorq    %rax, %rax
    call    scanf
    movq    (%rsp), %r14            # r14 = i index

    xorq    %rdi, %rdi
    movq    $scanf_index, %rdi
    movq    %rsp, %rsi
    xorq    %rax, %rax
    call    scanf
    movq    (%rsp), %r15            # r15 = j index

    movq    %r12, %rdi              # first parameter - dst
    movq    %r13, %rsi              # sec parameter - src
    movq    %r14, %rdx              # third parameter - i
    movq    %r15, %rcx              # fourth parameter - j
    call    pstrijcpy
    movq    %rax, %r12              # r12 = new dst

    xorq    %rsi, %rsi
    movq    $printf_len_str, %rdi
    movb    (%r12), %sil            # len of new dst
    addq    $1, %r12                # increase the str to print without the len
    movq    %r12, %rdx              # new dst
    xorq    %rax, %rax
    call    printf

    xorq    %rsi, %rsi
    movq    $printf_len_str, %rdi
    movb    (%r13), %sil            # len of src
    addq    $1, %r13                # increase the str to print without the len
    movq    %r13, %rdx              # src
    xorq    %rax, %rax
    call    printf


    jmp .L0                         # jump to done

# Case 54
.L4: #loc_D
    movq    %rsi, %r12              # r12 = p1
    movq    %rdx, %r13              # r13 = p2
    and     $0xf0, %spl

    movq    %r12, %rdi              # pstrlen 1
    call    swapCase
    movq    %rax, %r12              # r12 = swap of p1

    xorq    %rsi, %rsi
    movq    $printf_len_str, %rdi
    movb    (%r12), %sil            # len of swap p1
    addq    $1, %r12                # increase the str to print without the len
    movq    %r12, %rdx              # swap p1
    xorq    %rax, %rax
    call    printf

    movq    %r13, %rdi              # pstrlen 2
    call    swapCase
    movq    %rax, %r13              # r13 = swap of p2

    xorq    %rsi, %rsi
    movq    $printf_len_str, %rdi
    movb    (%r13), %sil            # len of swap p2
    addq    $1, %r13                # increase the str to print without the len
    movq    %r13, %rdx              # swap p2
    xorq    %rax, %rax
    call    printf

    jmp .L0                         # jump to done


# Case 55
.L5:                                 # loc_E
     movq    %rsi, %r12              # r12 = pstr 1
     movq    %rdx, %r13              # r13 = pstr 2
     and     $0xf0, %spl

     xorq    %rdi, %rdi
     movq    $scanf_index, %rdi
     movq    %rsp, %rsi
     xorq    %rax, %rax              # rax = 0
     call    scanf                   # scannig i index
     movq    (%rsp), %r14            # r14 = i index

     xorq    %rdi, %rdi
     movq    $scanf_index, %rdi
     movq    %rsp, %rsi
     xorq    %rax, %rax              # rax = 0
     call    scanf                   # scannig j index
     movq    (%rsp), %r15            # r15 = j index

     movq    %r12, %rdi              # first parameter - pstr 1
     movq    %r13, %rsi              # sec parameter - pstr 2
     movq    %r14, %rdx              # third parameter - i
     movq    %r15, %rcx              # fourth parameter - j
     call    pstrijcmp
     movq    %rax, %r12              # r12 = result

     xorq   %rsi, %rsi
     movq   %r12, %rsi
     movq   $print_pstrijcmp, %rdi
     xorq   %rax, %rax               # rax = 0
     call   printf                   # print the message

     jmp .L0                         # jump to done

# Defult Case 
.L9:                                # loc_def
    xorq    %rdi, %rdi
    movq    $printf_defult, %rdi
    xorq    %rax, %rax
    call    printf                  # print "invalid option message"


# run_func_done
.L0:                    # done:
                        # pop the register and exit from the function
    movq    %rbp, %rsp
    popq    %r15
    popq    %r14
    popq    %r13
    popq    %r12
    popq    %rbp
    ret                 # exit the function
