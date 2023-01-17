.text
addi $r8, $r0, 8
addi $r1, $r0, 1
addi $r2, $r0, 2
addi $r9, $r0, 4
addi $r21, $r0, 26
addi $r12, $r0, 28
addi $r22, $r0, 30
addi $r10, $r0, 5
addi $r11, $r0, 3
addi $r18, $r0, 7
addi $r17, $r0, 64 
addi $r16, $r0, 4
addi $r19, $r0, 128
addi $r20, $r0, 192
start:
	blt $r29, $r8, mulBranch
	j else
mulBranch:
    jal degree
    bne $r25, $r0, steer_branch
	sub $r14, $r8, $r29
    addi $r3, $r0, 0
    addi $r4, $r0, 0
    mul_loop1:
        add $r3, $r14, $r3
        addi $r4, $r4, 1
        bne $r4, $r16, mul_loop1
        addi $r28, $r3, 0
    bne $r14, $r8, leftBranch
    addi $r24, $r0, 2
    j cont
else:
    jal degree
    bne $r25, $r0, steer_branch
	sub $r15, $r16, $r29
    addi $r5, $r0, 0
    addi $r6, $r0, 0
    mul_loop2:
        add $r5, $r15, $r5
        addi $r6, $r6, 1
        bne $r6, $r16, mul_loop2
        addi $r13, $r5, 0
	addi $r28, $r13, 32
	j leftBranch
steer_branch:
    addi $r28, $r0, 0
    addi $r24, $r0, 3
    j cont
leftBranch:
    bne $r25, $r0, cont
    blt $r29, $r8, rightBranch
    addi $r24, $r0, 1 
    j cont
rightBranch:
    bne $r25, $r0, cont
    addi $r24, $r0, 0
    j cont
cont:
	bne $r27, $r1, second_check
    addi $r5, $r0, 0
    addi $r6, $r0, 0
    mul_loop3:
        addi $r5, $r5, 64
        addi $r6, $r6, 1
        bne $r6, $r1, mul_loop3
        addi $r26, $r5, 0
    j next
second_check:
    bne $r27, $r2, third_check
    addi $r5, $r0, 0
    addi $r6, $r0, 0
    mul_loop4:
        addi $r5, $r5, 64
        addi $r6, $r6, 1
        bne $r6, $r2, mul_loop4
        addi $r26, $r5, 0
    j next
third_check:
    bne $r27, $r11, zero
    addi $r5, $r0, 0
    addi $r6, $r0, 0
    mul_loop5:
        addi $r5, $r5, 64
        addi $r6, $r6, 1
        bne $r6, $r11, mul_loop5
        addi $r26, $r5, 0
    j next
zero:
    addi $r26, $r0, 0
next:
    bne $r25, $r1, start
    addi $r26, $r0, 0
    j start
degree:
    bne $r29, $r0, non_zero
    addi $r23, $r0, 0
    jr $r31
non_zero:
    bne $r25, $r0, brake
    blt $r29, $r11, one #r11=3
    blt $r29, $r10, two  #r10=5
    blt $r29, $r18, three #r18 = 7
    blt $r29, $r21, four #r21=26
    blt $r29, $r12, three #r12 = 28
    blt $r29, $r22, two #r22 = 30
    addi $r23, $r0, 1
    jr $r31
brake:
    addi $r23, $r0, 0
    jr $r31
one:
    addi $r23, $r0, 1
    jr $r31
two: 
    addi $r23, $r0, 2
    jr $r31
three:
    addi $r23, $r0, 3
    jr $r31 
four: 
    addi $r23, $r0, 4
    jr $r31














