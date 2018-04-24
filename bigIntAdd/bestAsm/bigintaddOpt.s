@ bigintadd.s
@Author Tiberiu Simion Voicu
@Define Rasspberry pi
.cpu cortex-a53
.fpu neon-fp-armv8
.syntax unified

@include header files
#include "bigint.h"
#include "bigintprivate.h"

@Data Section
.Data
.align 4
.equ MAX_DIGITS, 32768      @ constant for max digits
@oAddend1: .skip 131076      @ oAddend1 = memory for 32769 ints(int,int[32678])
@oAddend2: .skip 131076      @ oAddend2 init memory
@oSum: .skip 131076          @ osum init memory

@Code Section


.text
.code 32
.align 4

/**************************************************************************
    (ARM FUNCTION A32)
    Assign the sum of oAddend1 and oAddend2 to oSum.  Return 0 (FALSE)
    if an overflow occurred, and 1 (TRUE) otherwise.

    int BigInt_add(BigInt_T oAddend1, BigInt_T oAddend2, BigInt_T oSum)
    r4 -> UiCarry
    r5 -> uiSum
    r6 -> i
    r7 -> isumLength
    r8 -> oAddend1
    r9 -> oAddend2
    r10-> oSum

    r0 -> oAddend1
    r1 -> oAddend2
    r2 -> oSum
    r3 -> iSumLegth
    r7 -> UiCarry
    r5 -> UiSum
    r6 -> i
    Return FALSE if overflow(0)
    OR
    Return TRUE if !overflow(1)
 **************************************************************************/

BigInt_add:
    @ push registers onto the stack (keep 8 byte allinged as per AAPCS)
    PUSH {r3,r4,r5,r6,r7,lr}


    LDR r3, [r0]                @ r3 = oAddend1->iLength1
    LDR r4, [r1]                @ r4 = oAddend2->iLenght2
    CMP r4,r3                   @ Check which number is longer
    IT GE
    MOVGE r3,r4                 @ r3 = iSumLegth
    LDR r6, =0                  @ i = 0 (the count)
    MOV r4, #0                  @ r4 = 0(UiCarry)
loop:
    CMP r3,r6                   @ check i less than isumlength
    BLT end
    MOV r5, r4                  @ UiSum = UiCarry(r5 = UiSum)
    MOV r4, #0                  @ UiCarry = 0

    LDR r8,[r0, r6, LSL #2]     @ r4 = oAddend1->auiDigits[i]

    ADD r5,r5,r8                @ Uisum += oAddend1->auiDigits[i]
    CMP r5,r8                   @ compare uisum to oAddend1->auiDigits[i]
    IT LO
    MOVLO r4,#1                 @ uiCarry = 1 if lower(unsigned)LS

    LDR r8,[r1, r6, LSL #2]     @ r4 = oAddend2->auiDigits[i]
    ADD r5,r5,r8                @ Uisum += oAddend2->auiDigits[i]
    CMP r5,r8                   @ compare uiSum to oAddend2->auiDigist[i]
    IT LO
    MOVLO r4,#1                 @ uiCarry = 1 if lower(unsigned)LS

    STR r5,[r2, r6, LSL #2]    @ store into oSum->auiDigits[i] uiSum

    ADD r6,r6,#1                @ increment i at the end
    b loop
end:
    LDR r1, =MAX_DIGITS         @ r1 = MAX_DIGITS
    LDR r5, =1                  @ Load r4 with 1(to be used in next store)
    CMP r4, r5                  @ check if uiCarry = 1
    BNE true
    CMP r3, r1                  @ check if OVERFLOW
    MOV r0, #0                  @ set return to 0(false)
    IT EQ
    @ pop registers before branching out of func
    POPEQ {r3,r4,r5,r6,r7,pc}

    ADD r3,r3, r5               @ iSumLength ++(r2 = 1)
    STR r5,[r2,r3, LSL #2]      @ Osum->auiDigits[isumLength] = 1

true:
    STR r3, [r2]               @ Store iSumLenght -> oSum->iLength
    MOV r0, r5                  @ set return to 1(true)
    @ pop registers
    POP {r3,r4,r5,r6,r8,pc}
    @BX lr                       @ return true branch out
false:
    MOV r0, #0
    POP {r3,r4,r5,r6,r8,pc}
.code 32
.align 4
/*
BigInt_add:
    PUSH {r4,lr}

    BLX add

    POP {r4,lr}
    bx lr
    */
@Global Functions
    .global BigInt_add
@ Labels to access data
@addr_oAddend1 : .word oAddend1
@addr_oAddend2 : .word oAddend2
@addr_oSum : .word oSum
