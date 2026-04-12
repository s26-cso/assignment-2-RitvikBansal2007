.section .rodata
    file: .string "input.txt"
    mode: .string "r"
    yes: .string "Yes\n"
    no: .string "No\n"

.globl main
.section .text

main:
    addi sp,sp,-64
    sd x1,56(sp)
    sd s0,48(sp) # s0 is file pointer
    sd s1,40(sp) # s1 is starting index of string
    sd s2,32(sp) # s2 is ending index of sring
    sd s3,24(sp) # s3 starting character of string
    sd s4,16(sp) # s4 is ending character of string
    # now opening file x10=input.txt x11=mode ie read=r
    la x10,file
    la x11,mode
    call fopen
    # now x10 has file pointer store it in s0
    add s0,x0,x10
    # now filepointer is in s0
    # now call fseek to get size of string
    add x10,x0,s0
    add x11,x0,x0
    addi x12,x0,2 # SEEK_END integer value is 2
    call fseek
    # now fseek set pointer at last character in string now using ftell to tell position from start 
    add x10,x0,s0
    call ftell
    # now x10 has value of total characters ie n
    # now indices s1 have to be zero and s2 to be n-1
    addi s1,x0,0
    addi s2,x10,-1
    loop:
        bge s1,s2,palindrome # s0>=s1 ie initial index>=last index than it is plaidrome since we will check condition if chars equal move both pointer if not equal no a plaindrome
        # seekset has integer value 0 and index is s1 so
        addi x10,s0,0
        addi x11,s2,0
        addi x12,x0,0
        call fseek
        # calling f get c ans storing char at starting index
        addi x10,s0,0
        call fgetc
        addi s3,x10,0
        # s3 now has starting char
        # now fseek to make pointer at back and moving by j index
        # seekset has integer value 0 and index is s2 so
        addi x10,s0,0
        addi x11,s1,0
        addi x12,x0,0
        call fseek
        # now pointer at index at end
        addi x10,s0,0
        call fgetc
        addi s4,x10,0
        bne s3,s4,notpalindrome
        addi s1,s1,1
        addi s2,s2,-1
        beq x0,x0,loop
    notpalindrome: # printing no
        lla x10,no
        call printf
        beq x0,x0,exit
    palindrome: # printing yes
        lla x10,yes
        call printf
        beq x0,x0,exit
    exit:
        addi x10,s0,0 # closing file
        call fclose
        li x10,0 # return 0
        ld x1,56(sp) # restoring values
        ld s0,48(sp)
        ld s1,40(sp)
        ld s2,32(sp)
        ld s3,24(sp)
        ld s4,16(sp)
        addi sp,sp,64
        ret
