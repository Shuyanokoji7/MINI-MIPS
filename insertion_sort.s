.data
numbers: .word 8, 100, 0, 3, 7, 9, 2    # array to be sorted
length:  .word 7                       # number of elements

.text
.globl main

main:
    la $a0, numbers        # $a0 points to base of array
    lw $t7, length         # $t7 = array length (7)
    li $t0, 1              # $t0 = i = 1

loop_i:
    bge $t0, $t7, end      # if i >= length, end sort
    sll $t1, $t0, 2        # $t1 = i * 4 (byte offset)
    add $t1, $t1, $a0      # $t1 = address of numbers[i]
    lw  $t2, 0($t1)        # $t2 = key = numbers[i]
    addi $t3, $t0, -1      # $t3 = j = i - 1

loop_j:
    blt $t3, 0, insert_key     # if j < 0, go to insert
    sll $t4, $t3, 2            # $t4 = j * 4
    add $t4, $t4, $a0          # $t4 = address of numbers[j]
    lw  $t5, 0($t4)            # $t5 = numbers[j]
    ble $t5, $t2, insert_key   # if A[j] <= key, insert

    sw $t5, 4($t4)             # A[j+1] = A[j]
    addi $t3, $t3, -1
    j loop_j

insert_key:
    sll $t4, $t3, 2
    add $t4, $t4, $a0
    sw $t2, 4($t4)             # A[j+1] = key
    addi $t0, $t0, 1
    j loop_i

end:
    # optional: infinite loop or exit syscall
    li $v0, 10                 # syscall to exit
    syscall
