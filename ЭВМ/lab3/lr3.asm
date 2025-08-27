.MODEL		SMALL
.STACK		100H
.DATA		
a	DW	0
b	DW	0
i	DW	0
k	DW	0
i1	DW	0
i2	DW	0
res	DW	0
.CODE
START:
	mov	ax, @data
	mov	ds, ax
	
	mov	a, ax
	mov	b, bx
	mov	i, cx
	mov	k, dx

	sal	cx, 1		; i*2

	cmp 	ax, b
	jg	a_greater_b

	add	cx, i		; 2*i+i
	mov	i2, 10
	sub	i2, cx		; fn2 = 10 - 3*i
	sal	cx, 1		; i*6
	mov	i1, 6
	sub	i1, cx		; fn1 = -(6*i-6) = 6 - 6*i
	jmp	count_fn3

a_greater_b:
	sal	cx, 1		; i*4
	mov	i1, 20
	sub	i1, cx		; fn1 = 20 - 4*i
	mov 	i2, 5
	sub	i2, cx		; fn2 = -(4*i-5) = 5-4*i


count_fn3:
	cmp	i1, 0
	jge	i1_greater_0
	
	neg	i1		; |i1|

i1_greater_0:
	cmp	k, 0
	je	min_i1_0

	cmp	i2, 0
	jge	i2_greater_0
	
	neg	i2		; |i2|

i2_greater_0:
	mov	ax, i1
	add	ax, i2
	mov	res, ax
	jmp 	ending

min_i1_0:
	cmp 	i1, 6
	jl	min_i1
	
	mov	res, 6
	jmp	ending

min_i1:
	mov	ax, i1
	mov	res, ax

ending:
	mov	ah, 4ch
	int	21h
END START	