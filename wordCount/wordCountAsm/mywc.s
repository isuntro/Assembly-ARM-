@mywc.s
@Define Rasspberry pi
.cpu cortex-a53
.syntax unified

@Data Section
.data
.align 4
count: .asciz "%d,%d,%d"

@Code Section
.text
.code 16
.align 2

@ space = 32
@ EOF = -1
@ newline = 10

mywc:
    PUSH {r4,r5,r6,r7,r8,lr}@ push r4,r5,r6,r7,r8,lr on the stack
    mov r6, #0              @ prepare -1 (ascii for EOF)
    sub r6, #1              @ -1(ascii for EOF)
    mov r8, #0              @ set flag to FALSE
    b checkloop
loop:
    CMP r0, #10             @ compare with ascii for newline
    ITT eq
    addeq r7,r7,#1          @ linecount++ if newline
    beq word                @ goto word
    cmp r0, #32             @ Check if char is space
    ITTE ne
    addne r4,r4, #1         @ charcount++ if not space
    movne r8, #0            @ set flag to FALSE if not space
    beq word                @ goto word if space
checkloop:
    blx getchar             @ call getchar function (returning a char from stdin as r0)
    CMP r0, r6			    @ check if EOF
    BNE loop
end:
    cmp r8, #0              @ check if flag is FALSE
    IT EQ
    addeq r5,r5,#1          @ wordcount++ if FALSE
    blx getchar             @ consume EOF
    mov r1, r7              @ load line count(param 2)
    mov r2, r5              @ load word count(param 3)
    mov r3, r4              @ load char count(param 4)
    ldr r0 ,=count          @ load printf format(param 1)
    blx printf              @ call to printf function
    POP {r4,r5,r6,r7,r8,pc} @ pop pc in thumb = pop lr & bx lr | pop r4,r5,r6,r7,r8
word:
    add r4,r4, #1           @ charcount++
    cmp r8, #0              @ check if flag is FALSE
    ITT eq
    addeq r5,r5, #1         @ increment word count if FALSE
    addeq r8, #1	        @ set flag to TRUE if FALSE
    b checkloop             @ goto checkloop
.code 32
.align 4
        .globl main         @ Define Main
main:
    stmdb sp!, {r4, lr}     @ push lr and r4 onto the stack (keeping it 8 byte allinged)

    blx mywc                @ call to mywc(thumb) function

    ldmia sp!, {r4, lr}     @ pop lr from the stack to return from main & pop r4
    bx lr
/* external */
.globl getchar
.globl printf
