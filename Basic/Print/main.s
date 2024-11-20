.global _start

.section .data
  print: .asciz "Hello, world!\n"
  len = . - print

.section .text

_start:
   mov x0, 1
   ldr x1, =print
   ldr x2, =len
   mov x8, 64
   svc 0

   mov x0, 0
   mov x8, 93
   svc 0
