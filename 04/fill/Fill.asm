// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.

   @color
   M=0

(LOOP)
   @KBD
   D=M
   @DRAW_BLACK
   D;JGT

(DRAW_WHITE)
   @255
   D=A
   @color
   M=D
   @DRAW_LINE
   0;JMP

(DRAW_BLACK)
   @255
   D=A
   @color
   M=D
   @DRAW_LINE
   0;JMP

(DRAW_LINE)
   @SCREEN
   D=M
   @x
   A=D+A
(LINE_LOOP)

   @32
   D=A
   @x
   D=D-M
   @LOOP
   D;JEQ

   @x
   D=M
   @SCREEN
   D=A+D
   @x_pos
   M=D
   @color
   D=M
   @x_pos
   A=M
   M=D

   @1
   D=A
   @x
   M=M+D
   @LINE_LOOP
   0;JMP

(END)
   @END
   0;JMP
