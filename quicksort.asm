; Linked by DLX-LD.
.text 0x1000
.data 0x2000
; Compiled by GCC
.global _A

.align 2
_A:
.byte 65
.byte 71
.byte 102
.byte 19
.byte 111
.byte 4
.byte 122
.byte 70
.byte 0
.byte 9
.byte 58
.byte 26
.byte 48
.byte 66
.byte 8
.byte 88
.byte 100
.byte 52
.byte 2
.byte 91
.byte 5
.byte 111
.byte 48
.byte 1
.byte 28
.byte 127
.byte 126
.byte 53
.byte 10
.byte 81
.byte 68
.byte 37
.byte 99
.byte 21
.byte 26
.byte 121
.byte 28
.byte 14
.byte 124
.byte 57
.byte 71
.byte 28
.byte 55
.byte 13
.byte 107
.byte 72
.byte 2
.byte 1
.byte 25
.byte 39
.byte 27
.byte 17
.byte 103
.byte 24
.byte 126
.byte 35
.byte 95
.byte 118
.byte 103
.byte 41
.byte 17
.byte 12
.byte 106
.byte 25
.byte 12
.byte 0
.byte 7
.byte 31
.byte 49
.byte 127
.byte 55
.byte 26
.byte 2
.byte 59
.byte 23
.byte 26
.byte 14
.byte 17
.byte 32
.byte 112
.byte 62
.byte 126
.byte 90
.byte 13
.byte 14
.byte 117
.byte 118
.byte 2
.byte 53
.byte 72
.byte 66
.byte 31
.byte 10
.byte 14
.byte 28
.byte 21
.byte 100
.byte 115
.byte 12
.byte 58


.text
.align 2
.global _main
_main:
;  Function 'main'; 0 bytes of locals, 0 regs to save.
	addui r29,r0,0x1000                 ;pc = 1000
	addui r1,r0,0x1000
	sw	-4(r29),r30; push fp            ;[0ffc] = old r30
	add	r30,r0,r29; fp = sp             ;r30 = 1000
	sw	-8(r29),r31; push ret addr      ;[0ff8] = old r31
	subui	r29,r29,#8; alloc local storage
	jal	___main                         ;jump to 0x12b8
	nop; delay slot nop
	addi	r29,r29,#-16                ;pc = 1020, r29 = 0fe8
	add	r1,r0,r29                       ;r1 = 0fe8
	lhi	r2,((_A)>>16)&0xffff
	addui	r2,r2,(_A)&0xffff  
	sw	(r1),r2                         ;[0fe8] = 0x2000
	addi	r2,r0,#0                    
	sw	4(r1),r2                        ;[0fec] = 0
	addi	r2,r0,#31
	sw	8(r1),r2                        ;pc = 1040, [0ff0] = 31
	jal	_quick_sort                     ;jump to 0x1064
	nop; delay slot nop
	addi	r29,r29,#16
	addi	r1,r0,#0
	j	L1_LF0
	nop; delay slot nop
L1_LF0:
	jal	_exit
	nop
.align 2
.global _quick_sort
_quick_sort:
;  Function 'quick_sort'; 8 bytes of locals, 2 regs to save.
	sw	-4(r29),r30; push fp            ;[0fe4] = 1000
	add	r30,r0,r29; fp = sp             ;r30 = 0fe8
	sw	-8(r29),r31; push ret addr      ;[0fe0] = 104c
	subui	r29,r29,#24; alloc local storage ;r29 = 0fd0
	sw	0(r29),r2                       ;[0fd0] = old r2
	sw	4(r29),r3                       ;[ofd4] = old r3
	lw	r1,4(r30)                       ;r1 = 0
	lw	r2,8(r30)                       ;r2 = 31, pc = 1080
	slt	r1,r1,r2                        ;r1 = (r1 < r2)
	beqz	r1,L3_LF0                   ;if(r1) jump
	nop; delay slot nop
	addi	r29,r29,#-16                ;r29 = 0fc0
	add	r1,r0,r29                       ;r1 = 0fc0
	lw	r2,(r30)                        ;r2 = 0x2000
	sw	(r1),r2                         ;[0fc0] = 2000
	lw	r2,4(r30)                       ;r2 = 0
	sw	4(r1),r2                        ;[0fc4] = 0
	lw	r2,8(r30)                       ;r2 = 31
	sw	8(r1),r2                        ;[0fc8] = 31, pc = 10a8
	jal	_partition                      ;jump to 1140
	nop; delay slot nop
	addi	r29,r29,#16
	sw	-12(r30),r1
	addi	r29,r29,#-16
	add	r1,r0,r29
	lw	r2,(r30)
	sw	(r1),r2
	lw	r2,4(r30)
	sw	4(r1),r2
	lw	r2,-12(r30)
	sw	8(r1),r2
	jal	_quick_sort
	nop; delay slot nop
	addi	r29,r29,#16
	addi	r29,r29,#-16
	add	r1,r0,r29
	lw	r2,(r30)
	sw	(r1),r2
	lw	r2,-12(r30)
	addi	r3,r2,#1
	sw	4(r1),r3
	lw	r2,8(r30)
	sw	8(r1),r2
	jal	_quick_sort
	nop; delay slot nop
	addi	r29,r29,#16
L3_LF0:
	j	L2_LF0
	nop; delay slot nop
L2_LF0:
	lw	r2,0(r29)
	lw	r3,4(r29)
	lw	r31,-8(r30)
	add	r29,r0,r30
	lw	r30,-4(r30)
	jr	r31
	nop
.align 2
.global _partition
_partition:
;  Function 'partition'; 16 bytes of locals, 2 regs to save.
	sw	-4(r29),r30; push fp            ;pc = 1140
	add	r30,r0,r29; fp = sp
	sw	-8(r29),r31; push ret addr
	subui	r29,r29,#32; alloc local storage
	sw	0(r29),r2                       ;pc = 1150
	sw	4(r29),r3
	lw	r1,(r30)                        ;r1 = 2000
	lw	r2,4(r30)                       ;r2 = 0
	add	r1,r1,r2                        ;r1 = 2000
	lb	r2,(r1)                         ;r2 = x41
	sb	-17(r30),r2                     ;[r30 - 17] = x41
	lw	r1,4(r30)                       ;r1 = 0
	addi	r2,r1,#-1                   ;r2 = ffff ffff
	sw	-12(r30),r2                     ;[r30 - 12] = ffff ffff
	lw	r1,8(r30)                       ;r1 = 31_d
	addi	r2,r1,#1                    ;r2 = 32_d, pc = 117c
	sw	-16(r30),r2                     ;[r30-16] = 32_d
L5_LF0:
	j	L7_LF0                          ;jump to 1194
	nop; delay slot nop
	j	L6_LF0
	nop; delay slot nop
L7_LF0:
L8_LF0:
	lw	r2,-16(r30)                     ;pc = 1194, r2 = 32_d
	addi	r1,r2,#-1                   ;r1 = 31_d
	add	r2,r0,r1                        ;r2 = 31_d
	sw	-16(r30),r2                     ;[r30 - 16] = 31_d
L10_LF0:
	lw	r1,(r30)                        ;r1 = 2000
	lw	r2,-16(r30)                     ;r2 = 31_d
	add	r1,r1,r2                        ;r1 = 201f
	lb	r2,(r1)                         ;r2 = x25 
	lbu	r1,-17(r30)                     ;r1 = x41
	sgt	r2,r2,r1                        ;r2 = 0
	bnez	r2,L11_LF0
	nop; delay slot nop                 ;pc = 11c0
	j	L9_LF0                          ;jump to 11d4
	nop; delay slot nop
L11_LF0:
	j	L8_LF0
	nop; delay slot nop
L9_LF0:
	nop                                 ;pc = 11d4
L12_LF0:
	lw	r2,-12(r30)                     ;r2 = ffff ffff
	addi	r1,r2,#1                    ;r1 = 0
	add	r2,r0,r1                        ;r2 = 0
	sw	-12(r30),r2                     ;[r30 - 12] = 0
L14_LF0:
	lw	r1,(r30)                        ;r1 = 2000
	lw	r2,-12(r30)                     ;r2 = 0
	add	r1,r1,r2                        ;r1 = 2000
	lb	r2,(r1)                         ;r2 = x41
	lbu	r1,-17(r30)                     ;r1 = x41
	slt	r2,r2,r1                        ;r2 = 0, pc = 11fc
	bnez	r2,L15_LF0
	nop; delay slot nop
	j	L13_LF0                         ;jump to 1218
	nop; delay slot nop
L15_LF0:
	j	L12_LF0
	nop; delay slot nop
L13_LF0:                                ;pc = 1218
	lw	r1,-12(r30)                     ;r1 = 0
	lw	r2,-16(r30)                     ;r2 = 31_d
	slt	r1,r1,r2                        ;r1 = 1
	beqz	r1,L16_LF0
	nop; delay slot nop                 ;pc = 1228
	lw	r1,(r30)                        ;r1 = 2000
	lw	r2,-16(r30)                     ;r2 = 31_d
	add	r1,r1,r2                        ;r1 = 201f
	lb	r2,(r1)                         ;r2 = x25
	sb	-18(r30),r2                     ;[r30 - 18] = x25
	lw	r1,(r30)                        ;r1 = 2000
	lw	r2,-16(r30)                     ;r2 = 31_d
	add	r1,r1,r2                        ;r1 = 201f, pc = 1248
	lw	r2,(r30)                        ;r2 = 2000
	lw	r3,-12(r30)                     ;r3 = 0
	add	r2,r2,r3                        ;r2 = 2000
	lb	r3,(r2)                         ;r3 = x41
	sb	(r1),r3                         ;[2000] = x41
	lw	r1,(r30)                        ;r1 = 2000
	lw	r2,-12(r30)                     ;r2 = 0
	add	r1,r1,r2                        ;r1 = 2000
	lb	r2,-18(r30)                     ;r2 = x25
	sb	(r1),r2                         ;[2000] = x25, pc = 1270
	j	L17_LF0                         ;jump to 1288
	nop; delay slot nop
L16_LF0:
	lw	r1,-16(r30)
	j	L4_LF0
	nop; delay slot nop
L17_LF0:
	j	L5_LF0                          ;pc = 1288, jump to 1184
	nop; delay slot nop
L6_LF0:
L4_LF0:
	lw	r2,0(r29)
	lw	r3,4(r29)
	lw	r31,-8(r30)
	add	r29,r0,r30
	lw	r30,-4(r30)
	jr	r31
	nop
;;; Ethan L. Miller, 1999.  Released to the public domain
;;;
;;; Most of the traps are called in files from libtraps.


.align 2
.global _exit
_exit:
	trap	#0x300
	jr	r31
	nop

; for the benefit of gcc.
.global ___main
___main:
	nop
	jr	r31
	nop
.text
.global _etext
_etext:
.align 3
.data
.global _edata
_edata:
