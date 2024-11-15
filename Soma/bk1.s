.section .data
  cl: .asciz "\n"
  num1: .quad 5
  num2: .quad 13
  result: .skip 32

.section .text
  .global _start

_start:
  ldr x1, =num1
  ldr x2, =num2
  ldr x3, [x1]
  ldr x4, [x2]

  add x5, x3, x4

  ldr x6, =result
  sub, x6, x6, sp

  str x5, [x6]

  mov x0, 1
  ldr x1, =result
  mov x2, 4
  mov x8, 64
  svc 0

  bl new
  bl exit


// Funções aqui
new:
  mov x0, 1
  ldr x1, =cl
  mov x2, 1
  mov x8, 64
  svc 0
  ret

exit:
  mov x0, 1
  mov x8, 93
  svc 0
  ret
