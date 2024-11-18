.global _start

.section .data
  msg: .asciz "Fale uma coisa: "
  msgLen = . - msg

  input: .skip 256
  inputLen = . - input

  msg2: .asciz "\nN° de vezes a se repitir: "
  msg2Len = . - msg2

  input2: .quad 2
  input2Len = . - input2

  newLineSpace: .asciz "\n"
  newLineSpaceLen = . - newLineSpace

.section .text
_start:
  mov x0, 1
  ldr x1, =msg
  ldr x2, =msgLen
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =input
  mov x2, 32
  mov x8, 63
  svc 0

  mov x0, 1
  ldr x1, =msg2
  ldr x2, =msg2Len
  mov x8, 64
  svc 0

  mov x8, 63
  mov x0, 0
  ldr x1, =input2
  ldr x2, =input2Len
  svc 0

  bl newLine

  //mov x7, #5
  ldr x7, =input2
  ldr x9, [x7]
  //ldr x9, [x7]

  bl loop

loop:
  bl print

  sub x9, x9, 1
  cmp x9, #0
  bne loop

  bl exit

print:
  mov x0, 1
  ldr x1, =input
  ldr x2, =inputLen
  mov x8, 64
  svc 0
  ret

newLine:
  mov x0, 1
  ldr x1, =newLineSpace
  ldr x2, =newLineSpaceLen
  mov x8, 64
  svc 0
  ret

exit:
  mov x0, 0
  mov x8, 93
  svc 0
  // nao precisa de ret pois termina aqui
