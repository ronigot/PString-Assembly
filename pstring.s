.data
error:
    .string "invalid input!\n"

.text
.global pstrlen
pstrlen:
    xorq    %rax, %rax      # rax = 0
    movzbq  (%rdi), %rax    # pstr[0] = len
    ret

.global replaceChar
replaceChar:
    xorq    %rax, %rax      # rax = 0, the retValue
    xorq    %r8, %r8        # %r8 = 0, is runnig on the pstring
    pushq   %r8
    movq    %rdi, %r8
    leaq    1(%r8), %r8     # x++
.L1:
    cmpb    %sil, (%r8)     # comapre *x : oldChar
    jne     .L2             # if *x != oldchar, goto L2
    movb    %dl, (%r8)      # *x = newChar
.L2:
    leaq    1(%r8), %r8     # x++
    cmpb    $0, (%r8)       # compare *x : \0
    jne     .L1             # if !=, goto loop

    popq    %r8
    movq    %rdi, %rax      # retValue = newPstr
    ret

.global pstrijcpy
pstrijcpy:
    movq    %rdi, %r8       # put dst pstring in r8
    movq    %rdi, %r10      # put dst pstring in r10 in order to return the string unchaned
                            # in case of invalid input
    movq    %rsi, %r9       # put src pstring un r9
    push    %r8
    push    %r9
    push    %r10

    cmpb    (%rdi), %dl     # compare i : len(p1)
    jae     .exp            # if i > len(p1), goto exp_case
    cmpb    (%rdi), %cl     # compare j : len(p1)
    jae     .exp            # if j > len(p1), goto exp_case
    cmpb    (%rsi), %dl     # compare i : len(p2)
    jae     .exp            # if i > len(p1), goto exp_case
    cmpb    (%rsi), %cl     # compare j : len(p2)
    jae     .exp            # if j > len(p1), goto exp_case

    add     %dl, %r8b       # x(dst) = x(dst) + i
    addq    $1, %r8
    add     %dl, %r9b       # x(src) = x(src) + i
    addq    $1, %r9
    movb    %dl, %r11b      # counter += i
    xorq    %rax, %rax      # rax = 0

.L0:
    movb    (%r9), %al      # copy the char from the src str to the dst str
    movb    %al, (%r8)
    cmpb    %r11b, %cl      # check if i = j
    je      .end            # if yes, go to end
    addq    $1, %r11        # increment i
    addq    $1, %r8         # increment dst str
    addq    $1, %r9         # increment src str
    jmp     .L0
.exp:
    xorq    %rdi, %rdi
    movq    $error, %rdi

    push    %rbp
    movq    %rsp, %rbp
    movq    (%rsp), %rsi
    and     $0xf0, %spl     # alignes the stack pointer

    xor     %rax, %rax
    call    printf          # print an error message

    movq    %rbp, %rsp
    popq    %rbp

    popq    %r10            # pop the registers from the stack
    popq    %r9
    popq    %r8
    xorq    %rax, %rax
    movq    %r10, %rax
    ret                     # exit the function and return the string

.end:
    popq    %r10            # pop the registers from the stack
    popq    %r9
    popq    %r8
    xorq    %rax, %rax
    movq    %rdi, %rax
    ret                     # exit the function and return the string

.global swapCase
swapCase:
    push    %r8
    movq    %rdi, %r8           # put the pstring in r8
    leaq    1(%r8), %r8         # x++
    xorq    %rax, %rax
.Loop:
    cmpb    $0, (%r8)           # compare *x : \0
    je      .endPstr            # if =, goto endPstr
    movb    (%r8), %al
    cmpb    $65, %al
    jb      .continue_loop      # if x[i] < 'A', goto continue loop. not a letter
    cmpb    $122, %al
    ja      .continue_loop      # if x[i] > 'z', goto continue loop
    cmpb    $91, %al
    jb      .capital            # if x[i] <= 'Z' goto capital,
                                # we already know that x[i] >= 'A', so we have a capital letter
    cmpb    $96, %al
    ja      .lower_case         # if x[i] >= 'a' goto capital,
                                # we already know that x[i] <= 'z', so we have a lower-case letter
    jmp     .continue_loop      # goto continue loop. not a letter

.capital:
    addb    $32, %al            # swap the letter to a lower-case letter
    movb    %al, (%r8)
    jmp     .continue_loop      # continue the loop

.lower_case:
    subb    $32, %al            # swap the letter to a capital-case letter
    movb    %al, (%r8)
    jmp     .continue_loop      # continue the loop

.continue_loop:
    leaq    1(%r8), %r8         # x++
    jmp     .Loop

.endPstr:
    popq    %r8                 # pop the register
    xorq    %rax, %rax
    movq    %rdi, %rax
    ret                         # exit the function and return the swap string


.global pstrijcmp
pstrijcmp:
    movq    %rdi, %r8       # put pstring1 in r8
    movq    %rsi, %r9       # put pstring2 un r9
    push    %r8
    push    %r9
    xorq    %rax, %rax

    cmpb    (%rdi), %dl     # compare i : len(p1)
    jae     .exp_case       # if i > len(p1), goto exp_case
    cmpb    (%rdi), %cl     # compare j : len(p1)
    jae     .exp_case       # if j > len(p1), goto exp_case
    cmpb    (%rsi), %dl     # compare i : len(p2)
    jae     .exp_case       # if i > len(p1), goto exp_case
    cmpb    (%rsi), %cl     # compare j : len(p2)
    jae     .exp_case       # if j > len(p1), goto exp_case


    add     %dl, %r8b       # x1 = x1 + i
    addq    $1, %r8
    add     %dl, %r9b       # x2 = x2 + i
    addq    $1, %r9

.loop_ij:

    movb    (%r8), %al
    cmpb    %al, (%r9)      # compare p1[i] : p2[i]
    jb      .p1_is_bigger   # if <, go to p1_is_bigger
    ja      .p2_is_bigger   # if >, go to p2_is_bigger

    cmpb    %dl, %cl        # check if i = j
    je      .equal          # if =, goto equal

    leaq    1(%r8), %r8     # increment str1
    leaq    1(%r9), %r9     # increment str2
    addb    $1, %dl         # increment i

    jmp     .loop_ij



.exp_case:
    xorq    %rdi, %rdi
    movq    $error, %rdi    # error msg - the first argument of frintf

    push    %rbp
    movq    %rsp, %rbp
    movq    (%rsp), %rsi
    xor     %rax, %rax
    call    printf          # print an error message

    xorq    %rax, %rax      # rax = 0
    subq    $2, %rax        # rax = 0 - 2 = -2

    movq    %rbp, %rsp
    popq    %rbp            # pop the registers
    popq    %r8
    popq    %r9
    ret                     # exit the function and return -2

.equal:
    xorq    %rax, %rax      # rax = 0
    popq    %r8
    popq    %r9
    ret                     # exit the function and return 0

.p1_is_bigger:
    xorq    %rax, %rax      # rax = 0
    addq    $1, %rax        # rax = 1
    popq    %r8
    popq    %r9
    ret                     # exit the function and return 1

.p2_is_bigger:
    xorq    %rax, %rax      # rax = 0
    subq    $1, %rax        # rax = -1
    popq    %r8
    popq    %r9
    ret                     # exit the function and return -1



