	.arch armv6
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu vfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"bigintadd.c"
	.text
	.align	2
	.global	BigInt_add
	.type	BigInt_add, %function
BigInt_add:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r0, #0
	stmfd	sp!, {r3, r4, r5, r6, r7, lr}
	beq	.L12
	cmp	r1, #0
	beq	.L13
	cmp	r2, #0
	beq	.L14
	ldr	r7, [r1]
	ldr	r3, [r0]
	cmp	r7, r3
	movlt	r7, r3
	cmp	r7, #0
	ble	.L5
	mov	r4, #0
	mov	lr, r4
	mov	r6, r2
.L6:
	ldr	r5, [r0, #4]!
	ldr	ip, [r1, #4]!
	add	r3, lr, r5
	cmp	r5, r3
	movls	lr, #0
	movhi	lr, #1
	add	r4, r4, #1
	adds	ip, r3, ip
	movcs	lr, #1
	cmp	r4, r7
	str	ip, [r6, #4]!
	bne	.L6
	cmp	lr, #1
	beq	.L15
.L5:
	str	r7, [r2]
	mov	r0, #1
	ldmfd	sp!, {r3, r4, r5, r6, r7, pc}
.L15:
	cmp	r7, #32768
	addne	r3, r2, r7, asl #2
	addne	r7, r7, #1
	strne	lr, [r3, #4]
	bne	.L5
.L8:
	mov	r0, #0
	ldmfd	sp!, {r3, r4, r5, r6, r7, pc}
.L12:
	ldr	r0, .L16
	ldr	r1, .L16+4
	mov	r2, #43
	ldr	r3, .L16+8
	bl	__assert_fail
.L14:
	ldr	r0, .L16+12
	ldr	r1, .L16+4
	mov	r2, #45
	ldr	r3, .L16+8
	bl	__assert_fail
.L13:
	ldr	r0, .L16+16
	ldr	r1, .L16+4
	mov	r2, #44
	ldr	r3, .L16+8
	bl	__assert_fail
.L17:
	.align	2
.L16:
	.word	.LC0
	.word	.LC1
	.word	.LANCHOR0
	.word	.LC3
	.word	.LC2
	.size	BigInt_add, .-BigInt_add
	.section	.rodata
	.align	2
.LANCHOR0 = . + 0
	.type	__PRETTY_FUNCTION__.4668, %object
	.size	__PRETTY_FUNCTION__.4668, 11
__PRETTY_FUNCTION__.4668:
	.ascii	"BigInt_add\000"
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"oAddend1 != ((void *)0)\000"
.LC1:
	.ascii	"bigintadd.c\000"
.LC2:
	.ascii	"oAddend2 != ((void *)0)\000"
.LC3:
	.ascii	"oSum != ((void *)0)\000"
	.ident	"GCC: (Raspbian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",%progbits
