# CSCI 2406 Homework #2

**Name:** Rauf Karimli

Video link: **PASTE YOUR UNLISTED YOUTUBE VIDEO LINK HERE**

## Goal

In this homework, I changed ARM32 hexadecimal machine code back to assembly code. I used the lecture notes only. In the lecture notes, first we look at the `op` bits. If `op = 00`, it is data-processing. If `op = 01`, it is memory. If `op = 10`, it is branch.

## Final Assembly Code

The code is saved in **hw-2.s**.

```asm
.global _start

_start:
    mov     r1, #0              // e3a01000
    mov     r2, #10             // e3a0200a
    mov     r3, #0              // e3a03000
    mov     r4, #5              // e3a04005

loop_check:
    subs    r5, r3, r4          // e0535004
    addlt   r0, r0, r2          // b0800002
    addlt   r3, r3, #1          // b2833001
    blt     loop_check          // bafffffb

    bl      crash_block         // ebffffff

crash_block:
    str     lr, [sp, #-4]!      // e52de004
    mov     r4, #15             // e3a0400f
    mov     r5, #10             // e3a0500a
    add     r6, r5, r4          // e0856004
    subs    r5, r3, r4          // e0535004
    b       crash_block         // eafffff9
```

## Brief Decoding Discussion

These four initial instructions were all "mov" (move) instructions. Each of them placed a number in an ARM register. r1 now has 0; r2 now has 10; r3 now has 0; and r4 now has 5.

Instruction e0535004 was 'subs r5, r3, r4'. It subtracted r4 from r3 and set flags for use in subsequent conditional instructions. Those flags would be used to control what happens with the next two instructions - addlt and blt. When you read lt as less-than, you know that both addlt and blt can only execute if r3 was less-than r4. That creates a looping condition. A loop in a very basic form of C programming would look something like this:

```c
while (r3 < r4) {
    r0 = r0 + r2;
    r3 = r3 + 1;
}
```

Because `r3` starts from 0 and `r4` is 5, the loop runs 5 times. If `r0` starts from 0, then `r0` becomes 50.

After the first loop, the instruction `bl crash_block` jumps to the next block. It is `bl` because the branch has the link bit. This saves the return address in `lr`.

In `crash_block`, the first instruction is:

```asm
str lr, [sp, #-4]!
```

This stores `lr` on the stack. It also changes `sp` by subtracting 4. After that, the program sets some registers and branches back to `crash_block` again.

## Why the Program Crashes

The program crashes because it has an infinite loop in `crash_block`.

Every time the loop repeats, this instruction runs again:

```asm
str lr, [sp, #-4]!
```

This means the stack pointer keeps going down:

```text
sp = sp - 4
```

There is no return instruction like `bx lr`. There is also no stop condition. So the program keeps storing `lr` again and again. After some time, the stack reaches bad memory, and the program crashes.


## Short Video Talk Guide

In my video, I will first say that I used the lecture notes method. I looked at the condition field and the `op` field. Then I decided if each instruction was data-processing, memory, or branch.

Then I will explain the first `mov` instructions. They only put values into registers.

After that, I will explain the loop. The `subs` instruction compares `r3` and `r4`. Then `addlt` and `blt` work only if `r3` is less than `r4`.

Finally, I will explain the crash. The crash happens because `crash_block` repeats forever and keeps pushing `lr` on the stack. The stack pointer goes down until the program reaches invalid memory.

