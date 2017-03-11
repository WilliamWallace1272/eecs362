; Start instrs at address 0
.text 0x0000
; Start data somewhere else
.data 0x2000
.global _f
_f:
.word 0
.word 1

; Instructions
.text


.proc _multtest
.global _multtest
_multtest:
    
    add r3, r0, #15
    add r4, r0 , #3
    sub r1, r4, r3 ; r1 = -12
    movi2fp f0, r1
    movi2fp f1, r3
    movi2fp f2, r4
    mult f3, f2,f1 ; f3 = 45
    multu f4, f3, f0 ; f4 = 45 * 12 (unsigned) 0x21c 
    
    trap #0x300

.endproc _fptest
