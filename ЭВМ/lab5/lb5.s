.text                     # раздел с инструкциями программы
.global _start
_start:
	.equ a, 22            # задаются константы
	.equ b, 7
	.equ c, 6
	addi s0, x0, a        # константы a, b, c размещаются
	addi s1, x0, b        # в регистры s0, s1
	addi s2, x0, c        # и s2 соответственно
	li a2, 10            # размещение переменных
	li a3, 101           # x1, y1, z1 в регистры
	li a4, 11              # a2, a3, a4 соответственно
	li a5, 576           # размещение переменных
	li a6, 89            # x2, y2, z2 в регистры
	li a7, 3398            # a5, a6, a7 соответственно
	mv s4, a7             # сохранение значения из а7
	la a0, formula        # вывод строки по адресу в а0
	addi a7, x0, 4        # с помощью системного вызова PrintString
	ecall                 # (a7=4)
	mv a0, a2             # перенос числа из а2 в а0
	addi a7, x0, 1        # вывод его в 10-чной сс системным вызовом
	ecall                 # PrintInt (a7=1)
	li a0, 32             # в а0 ascii код пробела
	addi a7, x0, 11       # вывод символа системным вызовом
	ecall                 # PrintChar (a7=11)
	mv a0, a3             # вывод числа из а3
	addi a7, x0, 1
	ecall
	li a0, 32
	addi a7, x0, 11
	ecall
	mv a0, a4             # вывод числа из а4
	addi a7, x0, 1
	ecall
	li a0, 10             # вывод символа переноса строки
	addi a7, x0, 11
	ecall
	la a0, data           # вывод строки
	addi a7, x0, 4
	ecall
	mv a0, a5             # вывод числа из а5
	addi a7, x0, 1
	ecall
	li a0, 32
	addi a7, x0, 11
	ecall
	mv a0, a6             # вывод числа из а6
	addi a7, x0, 1
	ecall
	li a0, 32
	addi a7, x0, 11
	ecall
	mv a7, s4             # восстановление значения в а7
	mv a0, a7             # вывод числа из а7
	addi a7, x0, 1
	ecall
	li a0, 10
	addi a7, x0, 11
	ecall
	mv a7, s4
	call calc_expression  # вызов процедуры calc_expression
	la a0, results        # вывод строки
	addi a7, x0, 4
	ecall
	mv a0, a1             # вывод числа из а1
	addi a7, x0, 1
	ecall
	li a0, 10
	addi a7, x0, 11
	ecall
	mv a0, a2             # вывод числа из а2
	addi a7, x0, 1		
	ecall
	addi a0, x0, 0        # завершение программы системным вызовом
	addi a7, x0, 93       # Exit (a7=93) с кодом возврата в регистре а0                 
	ecall
calc_expression:
	neg s1, s1            # теперь в s1 находится (-b)
#вычисление выражения для (x1, y1, z1)
	xor a2, a2, s1		  # теперь в a2 находится (x1 ^ (-b))
	xor a4, a4, s2		  # теперь в a4 находится (z1 ^ c)
    add a3, a3, s0        # теперь в a3 находится (y1 + a)
	and a2, a2, a4		  # теперь в a2 находится (x1 ^ (-b)) & (z1 ^ c)
	or a1, a3, a2		  # теперь в a1 находится ((x1 ^ (-b)) & (z1 ^ c)) | (y1 + a)
#вычисление выражения для (x2, y2, z2)
	xor a5, a5, s1		  # теперь в a5 находится (x2 ^ (-b))
	xor a7, a7, s2		  # теперь в a7 находится (z2 ^ c)
	add a6, a6, s0		  # теперь в a6 находится (y2 + a)
    and a5, a5, a7		  # теперь в a5 находится (x2 ^ (-b)) & (z2 ^ c)
    or a2, a5, a6		  # теперь в a2 находится ((x2 ^ (-b)) & (z2 ^ c)) | (y2 + a)
	ret                   # возврат из процедуры
.data                     # раздел с данными для переменных программы
formula: .asciz "Formula: ((x ^ (-b)) & (z ^ c)) | (y + a)\nInput data:\n{x1, y1, z1} = "
data: .asciz "{x2, y2, z2} = "
results: .asciz "Results:\n"
