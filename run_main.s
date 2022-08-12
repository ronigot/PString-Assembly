// 322805029 Roni Gotlib
.data
scanf_num:
    .string  "%hhu"
scanf_str:
    .string  "%s"
scanf_option:
    .string  "%d"
.text
.global run_main
run_main:
    pushq   %rbp                # save rbp
    pushq   %r12                # push 2 registers for the psrings
    pushq   %r13
    movq    %rsp, %rbp          # save rsp

    subq    $544, %rsp

    leaq    -512(%rbp), %r12    # p1
    leaq    -256(%rbp), %r13    # p2

    movq    $scanf_num, %rdi    # scanning the len of the first pstr
    movq    %r12, %rsi
    xorq    %rax, %rax          # rax = 0
    call    scanf

    movq    $scanf_str, %rdi    # scanning the first str
    leaq    1(%r12), %rsi
    xorq    %rax, %rax
    call    scanf

    movq    $scanf_num, %rdi    # scanning the len of the second pstr
    movq    %r13, %rsi
    xorq    %rax, %rax          # rax = 0
    call    scanf

    movq    $scanf_str, %rdi    # scanning the second str
    leaq    1(%r13), %rsi
    xorq    %rax, %rax
    call    scanf

    movq    $scanf_option, %rdi # scanning the option
    leaq    -516(%rbp), %rsi
    xorq    %rax, %rax
    call    scanf

    movl    -516(%rbp), %edi    # the option
    movq    %r12, %rsi          # pstring 1
    movq    %r13, %rdx          # pstring 2
    call    run_func

    movq    %rbp, %rsp          # restore the caller's rsp
    popq    %r13                # pop the registers
    popq    %r12
    popq    %rbp                # restore the caller's rbp
    ret                         # exit the function
