.model small
.stack 500h
.data
EOFLINE EQU '$'		; конец строки
str1head	db	80, 0
str1	db	80	DUP('*'), 0Ah, 0Dh, EOFLINE
keep_ip		dw	0	; для хранения смещения
keep_cs		dw	0	; и сегмента прерывания
str2	db	80	DUP('*'), 0Ah, 0Dh, EOFLINE	; буфер для строки результата
greeting	db	'Enter your line: $'
const_num	dw	69h	; константа для инвертирования ASCII-цифр
const_letter	db	20h	; константа для конвертирования ASCII-русских букв
flag	db	0	
.code

input proc	; процедура ввода строки
	push	ax
	push	bx
	mov	ah, 0ah
	push	dx
	int	21h
	pop	bp
	xor	bx, bx
	mov	bl, ds:[bp+1]	; в bx количество введных символов
	add	bx, bp
	add	bx, 2
	mov	word ptr[bx+1], 240ah	; добавить в конец 0ah и $
	pop	bx
	pop	ax
	ret
input endp

print proc	; процедура вывода строки
	push	ax
	mov	ah, 9
	int	21h
	pop	ax
	ret
print endp

new_1ch proc	;прерывание 1ch
	
	mov	flag, 1	

	push	si
	push	di
	push	bx
	push	ax

	push	ds
	pop 	es

	mov	bx, 0
	lea	si, str1
	lea	di, str2
check:
	cmp	bl, str1head+1	; проверка на конец строки
	jne	check_num
	jmp	ending
check_num:
	mov	ax, 0h
	mov	al, [si+bx]
	cmp	al, 30h		; проверка символа на цифру 0-9
	jl	check_a_p
	cmp	al, 39h
	jg	check_a_p
	mov	ah, 00h
	neg	ax
	add	ax, const_num
	jmp	check_end
check_a_p:
	cmp	al, 80h	
	jl	check_end
	cmp	al, 8fh
	jg	check_r_ya
	add	al, 20h
check_r_ya:
	cmp	al, 90h
	jl	check_end
	cmp	al, 9fh
	jg	check_end
	add	al, 50h
check_end:
	mov	[di+bx], al
	add	bx, 1
	loop	check
ending:	
	mov	[di+bx], 240ah

	pop	ax
	pop	bx
	pop	di
	pop	si
	iret
new_1ch endp

main proc far
	push	ds
	sub	ax, ax
	push	ax

	mov	ax, @data
	mov	ds, ax

	mov	dx, offset greeting	; вывод строки приветствия
	call	print

	mov	dx, offset str1head
	call	input
	mov	dl, 0ah
	mov	ah, 02h
	int	21h

	mov	ah, 35h
	mov	al, 1ch
	int	21h
	mov	keep_ip, bx	; сохранение смещения
	mov	keep_cs, es	; сохранение сегмента
	
	push	ds
	mov	dx, offset new_1ch	; смещение для процедуры
	mov	ax, seg new_1ch		;сегмент процедуры
	mov	ds, ax
	mov	ah, 25h
	mov	al, 1ch			; установка вектора 1ch
	int	21h
	pop	ds

end_1ch_loop:
	mov	al, flag
	cmp	al, 1
	jne	end_1ch_loop	

	lea	dx, str2	; установка в dx адреса str2
	call	print		; вывод результата

	cli
	push	ds		; восстановление прерывания
	mov	dx, keep_ip
	mov	ax, keep_cs
	mov	ds, ax
	mov	ah, 25h
	mov	al, 1ch
	int 	21h
	pop	ds
	sti
	
	ret
main endp
end main	
	