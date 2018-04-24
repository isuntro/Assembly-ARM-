@ bigintadd.s
@Define Rasspberry pi
.cpu cortex-a53
.syntax unified

@include header files
#include "bigint.h"
#include "bigintprivate.h"

@Data Section
.Data
.align 4
.equ MAX_DIGITS, 32768      @ constant for max digits
oAddend1: .skip 131076      @ oAddend1 = memory for 32769 ints(int,int[32678])
oAddend2: .skip 131076      @ oAddend2 init memory
oSum: .skip 131076          @ osum init memory

@Code Section

        .GLOBAL BigInt_add
.text
.code 16
.align 2
/**************************************************************************
    (THUMB FUNCTION T32)
    Return the larger of iLength1 and iLength2.

    static BigInt_larger(int iLength1, int iLength2)
    r0 -> iLength1
    r1 -> iLength2

    Return: r0 -> iLarger

**************************************************************************/

BigInt_larger:
    cmp r1,r0
    IT ge           @check which one is higher
    movge r0,r1     @int(r1) is higher
    blx lr          @return r0


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

    Return FALSE if overflow(0)
    OR
    Return TRUE if !overflow(1)
 **************************************************************************/
.code 32
.align 4
BigInt_add:
    @ push registers onto the stack (keep 8 byte allinged as per AAPCS)
    PUSH {r4,r5,r6,r7,r8,r9,r10,lr}
    MOV r4, #0                  @ r4 = 0(UiCarry)
    LDR r8, addr_oAddend1       @ r8 = pointer to Addend1
    STR r0, [r8]                @ store OAddend1 in memory

    LDR r9, addr_oAddend2       @ r9 = pointer to Addend2
    STR r1, [r9]                @ store OAddend2 in memory

    LDR r10, addr_oSum          @ r10 = pointer to oSum
    STR r2, [r10]               @ store Osum in memory


    MOV r8, r0                  @ save pointer to struct(Addend1)
    MOV r9, r1                  @ save pointer to struct(Addend2)
    MOV r10, r2                 @ save pointer to struct(oSum)

    MOV r6, #0                  @ i = 0 (the count)
    LDR r0, [r8]                @ r0 = oAddend1->iLength1
    LDR r1, [r9]                @ r1 = oAddend2->iLenght2
    blx BigInt_larger           @ call bigint_larger function
    MOV r7, r0                  @ load into r7 return from bigint_larger(isumLength)
loop:
    CMP r7,r6                   @ check i less than isumlength
    BLT end
    MOV r5, r4                  @ UiSum = UiCarry
    MOV r4, #0                  @ UiCarry = 0

    LDR r3,[r8, r6, LSL #2]     @ r3 = oAddend1->auiDigits[i]
    ADD r5,r5,r3                @ Uisum += oAddend1->auiDigits[i]
    CMP r5,r3                   @ compare uisum to oAddend1->auiDigits[i]
    MOVLO r4,#1                 @ uiCarry = 1 if lower(unsigned)LS

    LDR r3,[r9, r6, LSL #2]     @ r3 = oAddend2->auiDigits[i]
    ADD r5,r5,r3                @ Uisum += oAddend2->auiDigits[i]
    CMP r5,r3                   @ compare uiSum to oAddend2->auiDigist[i]
    MOVLO r4,#1                 @ uiCarry = 1 if lower(unsigned)LS

    STR r5,[r10, r6, LSL #2]    @ store into oSum->auiDigits[i] uiSum

    ADD r6,r6,#1                @ increment count
    b loop
end:
    LDR r2, =MAX_DIGITS         @ r2 = MAX_DIGITS
    LDR r1, =1                  @ Load r1 with 1(to be used in next store)
    CMP r4, r1                  @ check if overflow
    BNE true
    CMP r7, r2                  @ check if MAX_DIGITS
    MOV r0, #0                  @ set return to 0(false)
    @ pop registers before branching out of func
    POPEQ {r4,r5,r6,r7,r8,r9,r10,lr}
    BXEQ lr                     @ return false branch out
    ADD r7,r7, r1               @ iSumLength ++
    STR r1,[r10,r7, LSL #2]     @ Osum->auiDigits[isumLength] = 1

true:
    STR r7, [r10]               @ r7 -> oSum->iLength
    MOV r0, r1                  @ set return to 1(true)
    @ pop registers
    POP {r4,r5,r6,r7,r8,r9,r10,lr}
    BX lr                       @ return true branch out

@Global Functions
    .global BigInt_add
@ Labels to access data
addr_oAddend1 : .word oAddend1
addr_oAddend2 : .word oAddend2
addr_oSum : .word oSum
