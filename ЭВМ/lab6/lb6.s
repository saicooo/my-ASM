.text # раздел с инструкциями программы
.global _start
_start:
    .equ a, 22 # задаются константы
    .equ b, 7
    .equ c, 6
    .equ threshold, 428
    addi s0, x0, a # константы a, b, c и threshold размещаются
    addi s1, x0, b # в регистры s0, s1
    addi s2, x0, c # s2 и t3 соответственно 
    addi t3, x0, threshold
    la a0, condition # вывод строки по адресу в а0
    addi a7, x0, 4 # с помощью системного вызова PrintString
    ecall # (a7=4)
    la a0, sum_cond # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall 
    li a0, 60 # вывод символа <
    addi a7, x0, 11
    ecall
    li a0, 32 # вывод пробела
    addi a7, x0, 11
    ecall
    mv a0, t3 # вывод числа из t3(threshold)
    addi a7, x0, 1
    ecall
    la a0, then # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall
    la a0, result # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall
    la a0, res1 # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall
    la a0, else # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall
    la a0, result # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall
    la a0, res2 # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall
    add s3, s0, s1 # теперь s3 = s0 + s1 = a + b
    add s3, s3, s2 # теперь s3 = s3 + s2 = a + b + c
    addi s4, x0, 10 # s4 = 9, это счётчик для элементов массива
    sw s3, 0(x1) # значение из s3 сохраняется в память по адресу из x1
    la a0, array # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall

    sub s3, s3, s2   #s3 = a + b + c - c = a + b 
    sub s3, s3, s2   #s3 = a + b - c
    
loop: # цикл для инициализации массива в памяти
    lw s6, 0(x1) # в s6 сохраняется значение из памяти по адресу из x1, т.е. a[i]
    mv a0, s6
    addi a7, x0, 1
    ecall
    li a0, 32
    addi a7, x0, 11
    ecall
    addi x1, x1, 4 # x1 = x1 + 4
    add s6, s6, s3 # s6 = s6 + s3 = a[i] + a + b -c
    sw s6, 0(x1) # значение из s6 сохраняется в память по адресу из x1
    addi s4, s4, -1 # s4 = s4 -1, уменьшение счётчика
    bnez s4, loop # повторение цикла, пока s4 != 0
    
    add x1, x0, x0
    lw s7, 20(x1) # в регистры s7, s8, s9 сохраняются
    lw s8, 28(x1) # arr[5], arr[7], arr[2] соответственно
    lw s9, 8(x1)
    add s8, s7, s8 # s8 = arr[5] + arr[7]
    add s8, s8, s9 # s8 = arr[5] + arr[7] + arr[2]
    li a0, 10 # вывод переноса строки
    addi a7, x0, 11
    ecall
    la a0, sum_cond # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall
    li a0, 61 # вывод символа =
    addi a7, x0, 11
    ecall
    li a0, 32 # вывод пробела
    addi a7, x0, 11
    ecall
    mv a0, s8 # вывод значения из s8
    addi a7, x0, 1
    ecall
    li a0, 10 # вывод пробела
    addi a7, x0, 11
    ecall
    la a0, result # вывод строки по адресу в а0
    addi a7, x0, 4 
    ecall
    blt s8, t3, condition_1 # если значение в s8 < значения в t3(threshold), то осуществляется переход на метку first
    lw s11, 36(x1) # в s11 загружается arr[9]
    and s7, s11, s2 # s7 = arr[9] & c
    mv a0, s7 # вывод значения из s7
    addi a7, x0, 1
    ecall 
    jal x0, done # безусловный переход на метку done
condition_1:
    lw s10, 28(x1) # в s10 загружается arr[7]
    or a5, s10, s7 # a5 = arr[7] | arr[5]
    mv a0, a5 # вывод значения из a5
    addi a7, x0, 1
    ecall 
done:
    addi a0, x0, 0 # завершение программы системным вызовом
    addi a7, x0, 93 # Exit (a7=93) с кодом возврата в регистре а0 
    ecall
.data # раздел с данными для переменных программы
condition: .asciz "Condition:\nif "
sum_cond: .asciz "arr[5] + arr[7] + arr[2] "
res1: .asciz "arr[7] | arr[5]"
res2: .asciz "arr[9] & 6"
then: .asciz "\nthen: "
else: .asciz "\nelse: "
result: .asciz "result = "
array: .asciz "\nArray: "
