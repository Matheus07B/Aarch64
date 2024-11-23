// =============================================
//
// No momento só falta ajustar a precisão
// Mas para isso terei que aprender a
// Manipular pontos flutuantes em assembly.
//
// =============================================

.global _start

.data
  C2F: .ascii "Celcius para Fahrenreint"
  C2F_len = . - C2F

  textValue: .ascii "\n\nFale o número da temperatura: "
  textValue_len = . - textValue

  inputArrow: .ascii "\n\n-> "
  inputArrow_len = . - inputArrow

  inputCelcius: .skip 10

  Result: .ascii "\nResultado: "
  Result_len = . - Result

  space: .ascii "  "

  ResultValue: .skip 10
  ResultValue_len = . - ResultValue

  newLine: .ascii "\n"
  newLine_len = . - newLine

.text
_start:
  mov x0, 1
  ldr x1, =C2F
  ldr x2, =C2F_len
  mov x8, 64
  svc 0

  mov x0, 1
  ldr x1, =textValue
  ldr x2, =textValue_len
  mov x8, 64
  svc 0

  mov x0, 1
  ldr x1, =inputArrow
  ldr x2, =inputArrow_len
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =inputCelcius
  mov x2, 10
  mov x8, 63
  svc 0

  // Inicia a conversão
  ldr x0, =inputCelcius
  mov x1, #0

Conversao:
  // Carrega o caractere atual
  ldrb w2, [x0]  // Use ldrb para carregar apenas 1 byte

  // Verifica se é o fim da string (nulo)
  cmp w2, #0
  beq fim_Conversao

  cmp w2, #'0'         // 0 em ascii é 48
  blt fim_Conversao
  cmp w2, #'9'         // 9 em ascii é 57
  bgt fim_Conversao

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

fim_Conversao:

  // Pontos flutuantes aqui, OBS: Não aprendi a mecher neles ainda.

  //fmov s9, w7
  //fmov s1, 1.8
  //fmov s2, 32.0
  //fmul s0, s0, s1
  //fadd s0, s0, s2
  //fcvtzu w7, s9

  add w7, w7, w7
  sub w7, w7, 2
  add w7, w7, 32

  // w7 contém o valor inteiro; agora convertemos para string
  ldr x2, =ResultValue
  mov x3, #10

convert_to_string:
  udiv w4, w7, w3      // Divide w7 por 10, resultado em w4
  msub w5, w4, w3, w7  // Calcula o resto: w5 = w7 - (w4 * w3)
  add w5, w5, #'0'     // Converte o dígito restante para ASCII
  strb w5, [x2, #-1]!  // Armazena o caractere no buffer (em ordem reversa)
  mov w7, w4           // Atualiza w7 para o quociente
  cbz w7, print_number // Se w7 == 0, termina a conversão
  b convert_to_string

print_number:
  mov x0, 1
  ldr x1, =Result
  ldr x2, =Result_len
  mov x8, 64
  svc 0

  mov x0, 1
  ldr x1, =space
  mov x2, 2
  mov x8, 64
  svc 0

  mov x0, 1
  sub x1, x2, ResultValue   // Calcula o número de caracteres armazenados no buffer
  ldr x2, =ResultValue_len
  mov x8, 64
  svc 0

  mov x0, 1
  ldr x1, =newLine
  ldr x2, =newLine_len
  mov x8, 64
  svc 0

  // Não precisa pois já é o final do progama.
  // b exit

exit:
  mov x0, 0
  mov x8, 93
  svc 0
