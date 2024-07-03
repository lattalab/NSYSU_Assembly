.TEX:
	.ascii	"test result: \000"
	.text
	.align	2
	.global	main
.L6:
	.word	.TEX
main:
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r0, .L6
	bl	printf
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L2
.L5:
	ldr	r3, [fp, #-20]
	add	r3, r3, #4
	ldr	r2, [r3, #0]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #64
	bls	.L3
	ldr	r3, [fp, #-20]
	add	r3, r3, #4
	ldr	r2, [r3, #0]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #90
	bhi	.L3
	ldr	r3, [fp, #-20]
	add	r3, r3, #4
	ldr	r2, [r3, #0]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, #32
	mov	r0, r3
	bl	putchar
	b	.L4
.L3:
	ldr	r3, [fp, #-20]
	add	r3, r3, #4
	ldr	r2, [r3, #0]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #96
	bls	.L4
	ldr	r3, [fp, #-20]
	add	r3, r3, #4
	ldr	r2, [r3, #0]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #122
	bhi	.L4
	ldr	r3, [fp, #-20]
	add	r3, r3, #4
	ldr	r2, [r3, #0]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	mov	r0, r3
	bl	putchar
.L4:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L2:
	ldr	r3, [fp, #-20]
	add	r3, r3, #4
	ldr	r2, [r3, #0]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L5
	mov	r0, #10
	bl	putchar
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, lr}
	bx	lr


