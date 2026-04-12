.section .text

.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp,sp,-16 
    # added space in stack
    sd x1,8(sp)
    # stored return address original value
    sd s0,0(sp)
    # stored original value of s0
    # x10 has function argument ie int val save it in s0 then call malloc to allocate memory
    add s0,x10,x0 
    addi x10,x0,24
    # 24 cuz int 4 bits than padding of 4 bits and then left and right pointers so 8*3
    call malloc
    sw s0,0(x10) 
    # storing value at start then will save zeros for null left and right pointers
    sd x0,8(x10)
    sd x0,16(x10)
    # everything is stored return address value in x10 already in it just reset values from stack and then return 
    ld s0,0(sp)
    ld x1,8(sp)
    addi sp,sp,16
    ret

insert:
    addi sp,sp,-24
    sd x1,16(sp)
    sd s0,8(sp)
    sd s1,0(sp)
    # storing original values of x1,s0,s1
    add s0,x10,x0 # s0 has root pointer
    add s1,x11,x0 # s1 has value to be inserted
    add x10,x11,x0 # x10 has the value to be inserted now we will call make_node function
    call make_node
    # now x10 has address of new node created 
    add x5,s0,x0
    add x6,s1,x0
    # now x5 has root pointer and x6 has value
    beq x5,x0,rootisnull
    loop:
    lw x7,0(x5)
    # x7 now has root value
    blt x7,x6,insertright # rootval<val now go to right subtree
    beq x0,x0,insertleft #  rootval>val now go to left subtree
    insertright:
        ld x28,16(x5) # x28 has right pointer
        beq x28,x0,insertrightjusthere # right pointer is null just insert there else no it becomes new root
        add x5,x28,x0 # now x5 has new root pointer and then call loop
        beq x0,x0,loop
        insertrightjusthere:
            sd x10,16(x5)
            beq x0,x0,exit
    insertleft:
        ld x29,8(x5) # x28 has left pointer
        beq x29,x0,insertleftjusthere # left pointer is null just insert there else no it becomes new root
        add x5,x29,x0 # now x5 has new root pointer and then call loop
        beq x0,x0,loop
        insertleftjusthere:    
            sd x10,8(x5)
            beq x0,x0,exit
    rootisnull: # x10 already has address of new node made no changes since root is null just return that address back 
        ld x1,16(sp)
        ld s0,8(sp)
        ld s1,0(sp)
        addi sp,sp,24
        ret
    exit:
        add x10,s0,x0 # now x10 has root pointer 
        ld x1,16(sp)
        ld s0,8(sp)
        ld s1,0(sp)
        addi sp,sp,24
        ret

get:
    # x10 has root pointer x11 has value to be looked for
    get_loop:
        beq x10,x0,get_exit # value doesnt exist
        lw x7,0(x10) # x7 has root val
        blt x7,x11,get_right # rootval<val go to right subtree
        beq x7,x11,get_exit # rootval==val return this
        beq x0,x0,get_left # rootval>val got to left subtree
        get_right:
            ld x5,16(x10)
            add x10,x5,x0 # now x10 has new righ root pointer now call loop
            beq x0,x0,get_loop
        get_left:
            ld x5,8(x10)
            add x10,x5,x0 # now x10 has new left root pointer now call loop
            beq x0,x0,get_loop
    get_exit:
        ret

getAtMost:
    # x10 has value and x11 has root pointer
    addi x5,x0,-1 # x5 has -1 it will contain predecessor values
    beq x11,x0,getAtMost_exit # root is null so not exist
    # I will store value in x5 
    getAtMost_loop:
        # x11 is current root
        beq x11,x0,getAtMost_exit
        lw x6,0(x11) # x6 has root val
        blt x6,x10,right # rootval<val go to right subtree
        blt x10,x6,left # rootval>val go to left subtree
        beq x6,x10,found # rootval==val now go to right most node of 
        right:
        add x5,x6,x0 # x5 has predecessor value now change current to it's right pointer
        ld x11,16(x11)
        beq x0,x0,getAtMost_loop
        left:
        ld x11,8(x11) # got to left subtree no change in predecessor
        beq x0,x0,getAtMost_loop
        found:
            add x5,x10,x0
            beq x0,x0,getAtMost_exit
    getAtMost_exit:
    add x10,x5,x0 # x10 now has predecessor value and have to return in it
    ret
