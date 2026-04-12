.section .data
fmt_d: .string "%d"
fmt_space: .string " "
fmt_nl: .string "\n"

.section .text
.globl main

main:
    addi sp,sp,-48
    sd x1,40(sp)
    sd s0,32(sp)
    sd s1,24(sp)
    sd s2,16(sp)
    sd s3,8(sp)
    sd s4,0(sp)
    add s0,x10,x0 # s0 has argc
    add s1,x11,x0 # s1 has argv
    addi s2,s0,-1 # s2 has no of elements (./a.out removed so s0-1)
    slli x10,s2,2 # x10=n*4 for malloc arr
    call malloc
    add s3,x10,x0 # s3 has arr pointer
    slli x10,s2,2 # x10=n*4 for malloc ans
    call malloc
    add s4,x10,x0 # s4 has ans pointer
    addi x5,x0,0 # x5=i=0
    loop:
        bge x5,s2,loopend
        addi x6,x5,1 # x6=i+1
        slli x6,x6,3 # x6=(i+1)*8 argv pointers are 8 bytes
        add x6,s1,x6 # x6=address of argv[i+1]
        ld x10,0(x6) # x10=value of argv[i+1] (string)
        addi sp,sp,-16 # saves x5 as calling might change it
        sd x5,8(sp)
        call atoi # converts to integer
        ld x5,8(sp) # restore x5 after call
        addi sp,sp,16
        slli x7,x5,2 # x7=i*4 int offset
        add x28,s3,x7 # x28= address of arr[i]
        sw x10,0(x28) # arr[i]=integer
        addi x5,x5,1
        beq x0,x0,loop
    loopend:
        addi x29,x0,-1 # x29 is top of my stack 
        addi x30,x0,-1 # x30 stores -1 just for check to put in loop
        addi x5,s2,-1 # index of last element
        stackloop:
            blt x5,x0,loopendcontinuation
            slli x6,x5,2 # x6=i*4
            add x6,s3,x6 # x6=address of arr[i]
            lw x6,0(x6) # x6 is now value arr[i]
            innerloop:
                bge x30,x29,stackloopcontinuation # stack top<=-1 then loop end got to continue other
                lw x31,0(sp) # x31 is new index value at top of stack
                slli x31,x31,2 # x31*4 for int value 
                add x31,s3,x31 # address of array value
                lw x31,0(x31) # load array value
                blt x6,x31,stackloopcontinuation # same if value at top become lt than go to continue loop
                addi sp,sp,4
                addi x29,x29,-1
                beq x0,x0,innerloop
            stackloopcontinuation:
                beq x30,x29,notexist # greater element doesn't exist since stack is empty so just put -1 in ans array
                slli x7,x5,2
                add x7,s4,x7 # x7 has address of ans array
                lw x31,0(sp)
                sw x31,0(x7) # storing top value of stack in ans array
                addi sp,sp,-4 # putting arr[i] in stack now
                addi x29,x29,1
                sw x5,0(sp)
                addi x5,x5,-1
                beq x0,x0,stackloop
                notexist:
                    slli x7,x5,2
                    add x7,s4,x7 # x7 has address of ans array
                    sw x30,0(x7) # storing -1 in ans array
                    addi sp,sp,-4 # putting arr[i] in stack now
                    addi x29,x29,1
                    sw x5,0(sp)
                    addi x5,x5,-1
                    beq x0,x0,stackloop
        loopendcontinuation:
            stackresetloop:
                beq x30,x29,resetindex
                addi x29,x29,-1
                addi sp,sp,4
                beq x0,x0,stackresetloop
            resetindex:
                addi x5,x0,0 # x5=i=0
    loop2: 
        slli x6,x5,2 # x6=i*4
        add x6,s4,x6 # x6 correct address
        lw x11,0(x6) # x11 value in ans array
        addi sp,sp,-16 # saves x5 as calling might change it
        sd x5,8(sp)
        la x10,fmt_d
        call printf
        ld x5,8(sp) # restore x5 after call
        addi sp,sp,16
        addi x6,x5,1 # x6=i+1
        bge x6,s2,exit # last element 
        la x10,fmt_space
        addi sp,sp,-16 # saves x5 as calling might change it
        sd x5,8(sp)
        call printf
        ld x5,8(sp) # restore x5 after call
        addi sp,sp,16
        addi x5,x5,1 # index=x5+1
        beq x0,x0,loop2
    exit:
        la x10,fmt_nl
        call printf
        addi x10,x0,0 # return 0
        ld x1,40(sp)
        ld s0,32(sp)
        ld s1,24(sp)
        ld s2,16(sp)
        ld s3,8(sp)
        ld s4,0(sp)
        addi sp,sp,48
        ret
