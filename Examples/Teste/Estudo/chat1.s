.global _start

.section .data
  msg: .asciz "Fale uma coisa: "
  msgLen = . - msg

  input: .skip 256
  inputLen = 256

  msg2: .asciz "\nN° de vezes a se repetir: "
  msg2Len = . - msg2

  input2: .skip 32

  newLineSpace: .asciz "\n"
  newLineSpaceLen = . - newLineSpace

.section .text
_start:
  // Exibe mensagem inicial
  mov x0, 1
  ldr x1, =msg
  mov x2, msgLen
  mov x8, 64
  svc 0

  // Lê o texto a repetir
  mov x0, 0
  ldr x1, =input
  mov x2, inputLen
  mov x8, 63
  svc 0

  // Exibe mensagem para número de repetições
  mov x0, 1
  ldr x1, =msg2
  mov x2, msg2Len
  mov x8, 64
  svc 0

  // Lê o número de repetições
  mov x0, 0
  ldr x1, =input2
  mov x2, 32
  mov x8, 63
  svc 0

  // Converte o número de input2 para inteiro
  ldr x0, =input2
  mov x1, 0

Conversao:
  ldrb w2, [x0]        // Carrega caractere atual
  cmp w2, #0           // Verifica fim da string
  beq fim_Conversao
  cmp w2, #'0'
  blt fim_Conversao
  cmp w2, #'9'
  bgt fim_Conversao
  sub w2, w2, #'0'     // Converte ASCII para número
  mov w3, #10          // Prepara multiplicador
  mul w1, w1, w3       // Multiplica acumulador por 10
  add w1, w1, w2       // Soma dígito ao acumulador
  add x0, x0, #1       // Avança para o próximo caractere
  b Conversao

fim_Conversao:
  mov x2, x1           // Move o número convertido para x2 (expande w1 para x2)

  // Imprime o texto repetidamente
loop:
  cmp w1, 0
  beq exit
  bl print
  sub w1, w1, 1
  b loop

print:
  mov x0, 1
  ldr x1, =input
  mov x2, inputLen
  mov x8, 64
  svc 0
  ret

newLine:
  mov x0, 1
  ldr x1, =newLineSpace
  mov x2, newLineSpaceLen
  mov x8, 64
  svc 0
  ret

exit:
  mov x0, 0
  mov x8, 93
  svc 0
