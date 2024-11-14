.global _start

.section .data
  print: .asciz "\nFale uma coisa: "
    lenght = . - print

  read: .skip 32

  rest: .asciz "\nO resultado é: "
    restLen = . - rest

  newL: .asciz "\n"

.section .text

_start:
  mov x0, #1
  ldr x1, =print
  ldr x2, =lenght
  mov x8, 64
  svc 0

  mov x0, #0
  ldr x1, =read
  mov x2, #32
  mov x8, 63
  svc 0

  mov x0, #1
  ldr x1, =rest
  ldr x2, =restLen
  mov x8, 64
  svc 0

  mov x0, #1
  ldr x1, =read
  mov x2, #32
  mov x8, 64
  svc 0

  mov x0, #1
  ldr x1, =newL
  mov x2, #1
  mov x8, #64
  svc 0

  mov x0, 0
  mov x8, 93
  svc 0
