// CSCI 2406 Homework #2
// Name: Rauf Karimli
// Reverse engineered from the given ARM32 hexadecimal dump.

.global _start

_start:
    mov     r1, #0              // e3a01000: r1 = 0
    mov     r2, #10             // e3a0200a: r2 = 10
    mov     r3, #0              // e3a03000: r3 = 0
    mov     r4, #5              // e3a04005: r4 = 5

loop_check:
    subs    r5, r3, r4          // e0535004: r5 = r3 - r4, set condition flags
    addlt   r0, r0, r2          // b0800002: if r3 < r4, r0 = r0 + r2
    addlt   r3, r3, #1          // b2833001: if r3 < r4, r3 = r3 + 1
    blt     loop_check          // bafffffb: branch back while r3 < r4

    bl      crash_block         // ebffffff: branch with link to crash_block

crash_block:
    str     lr, [sp, #-4]!      // e52de004: pre-decrement sp by 4, store lr on stack
    mov     r4, #15             // e3a0400f: r4 = 15
    mov     r5, #10             // e3a0500a: r5 = 10
    add     r6, r5, r4          // e0856004: r6 = r5 + r4
    subs    r5, r3, r4          // e0535004: r5 = r3 - r4, set condition flags
    b       crash_block         // eafffff9: unconditional branch back to crash_block
