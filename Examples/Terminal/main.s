.global _start

.data
  // Input principal aqui!
  out: .ascii "AArch64 -> "
  out_len = . - out
  input: .skip 32

// Echo
  printEcho: .ascii "Teste\n"
  pE_len = . - printEcho

// Saida
  exit_code: .ascii "exit"

// New line
  newLine1: .ascii "\n"
  newLine_len = . - newLine1
.text
  // Outras rotinas aqui.
  echo:
    mov x0, 1
    ldr x1, =printEcho
    ldr x2, =pE_len
    mov x8, 64
    svc 0
    b _start

_start:
  mov x5, #0
  mov x6, #0

  mov x0, 1
  ldr x1, =out
  ldr x2, =out_len
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =input
  mov x2, 32
  mov x8, 63
  svc 0

  ldr w5, =input
  ldrb w6, [x5]

  // Exit
  cmp w6, #'e'
  beq exit

  // Echo
  cmp w6, #'p'
  beq echo

  // Renicia o terminal
  b _start

exit:
  // bl newLine

  mov x0, 0
  mov x8, 93
  svc 0

newLine:
  mov x0, 1
  ldr x1, =newLine1
  ldr x2, =newLine_len
  mov x8, 64
  svc 0
  ret
