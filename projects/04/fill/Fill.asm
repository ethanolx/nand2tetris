// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Initialize cache state to 0 (no keypress)
@cache
M=0

// while true:
(LOOP)
    // D = key_is_pressed
    @KBD
    D=M

    // Store keypress argument in @R0
    @R0
    M=D

    // Poll for keypress state change
    @STATE_ZERO
    D;JEQ
    @cache
    D=M
    @LOOP
    D;JNE
    @cache
    M=1
    @STATE_CHANGE
    0;JMP
    (STATE_ZERO)
    @cache
    D=M
    @LOOP
    D;JEQ
    @cache
    M=0
    (STATE_CHANGE)

    // Screen address offset
    @SCREEN
    D=A
    @i
    M=D

    // Begin from first row, first col
    // 256 * 32
    @8192
    D=A
    @cell
    M=D

    (CELL_LOOP)
        // if R0:
        @R0
        D=M
        @WHITEN
        D;JEQ

        // blacken
        @i
        A=M
        M=-1
        @AFTER_BLACKEN
        0;JMP

        // else:
        (WHITEN)

        // whiten
        @i
        A=M
        M=0

        (AFTER_BLACKEN)

        // Increment offset
        @i
        M=M+1

        // Cell counter -= 1
        @cell
        M=M-1
        D=M
        @CELL_LOOP
        D;JGT

    @LOOP
    0;JMP
