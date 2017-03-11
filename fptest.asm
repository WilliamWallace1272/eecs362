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


.proc _fptest
.global _fptest
_fptest:
    
    add r3, r0, #15
    movi2fp f1, r3
    movi2fp f31, r3
    lw r4, _f(r0)
    movi2fp f2, r4
    movfp2i r4, f2
    beqz r4, done
    nop;
    nop;
    add r15, r0, #32
done:
    nop ; delay slow
    trap #0x300

.endproc _fptest
