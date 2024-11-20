.global _start

.section .data
  msg: .ascii "Fale uma coisa: "
  msgLen = . - msg

  input: .skip 256
  inputLen = . - input

  msg2: .ascii "\nN° de vezes a se repitir: "
  msg2Len = . - msg2

  input2: .ascii

  newLineSpace: .ascii "\n"
  newLineSpaceLen = . - newLineSpace

.section .text
_start:

  // Pega o texto a se repitir
  mov x0, 1
  ldr x1, =msg
  ldr x2, =msgLen
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =input
  mov x2, 256
  mov x8, 63
  svc 0

  // Pega o numero de vezes
  mov x0, 1
  ldr x1, =msg2
  ldr x2, =msg2Len
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =input2
  mov x2, 10
  mov x8, 63
  svc 0

  // Chama a função de Imprimir nova linha
  //b newLine

  ldr x0, =input2
  mov x1, #0

Conversao:
  // Carrega o caractere atual
  ldrb w2, [x0]  // Use ldrb para carregar apenas 1 byte

  // Verifica se é o fim da string (nulo)
  cmp w2, #0
  beq fim_loop

  // Verifica se é um dígito (ASCII '0' é 48)
  cmp w2, #'0'
  blt fim_loop
  cmp w2, #'9'  // 9 em asciz é 57
  bgt fim_loop

  // Converte o dígito para numérico e adiciona ao acumulador
  sub w2, w2, #'0'

  // Multiplica o acumulador por 10
  movz w3, #10
  mul w7, w7, w3

  // Soma o valor do dígito ao acumulador
  add w7, w7, w2

  // Avança para o próximo caractere
  add x0, x0, #1

  b Conversao

fim_loop:
  b loop

loop:
  bl print

  sub w7, w7, 1
  cmp w7,# 0
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
