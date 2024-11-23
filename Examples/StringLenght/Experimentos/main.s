.global _start

.data // RAM
  mainText: .ascii "Calculador de tamanho de texto 2024\n\n"
  mainText_len = . - mainText

  input: .ascii "-> "
  input_len = . - input

  strSize: .skip 256
  strSize_len = . - strSize

  result: .ascii "\n     "
  result_len = . - result

  resultStrSize: .skip 256
  resultStrSize_len = . - resultStrSize

  newLine: .ascii "\n"
  newLine_len = . - newLine

.text
_start:
  // Calculador de tamanho de texto 2024
  mov x0, 1
  ldr x1, =mainText
  ldr x2, =mainText_len
  mov x8, 64
  svc 0

  // leitura do texto a ser calculado
  mov x0, 1
  ldr x1, =input
  ldr x2, =input_len
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =strSize
  mov x2, 256
  mov x8, 63
  svc 0

  ldr x0, =strSize
  mov x1, #0
  mov w7, #0

loop:
  // Carrega o caractere atual
  ldrb w2, [x0]  // Use ldrb para carregar apenas 1 byte

  // Verifica se é o fim da string (nulo)
  cmp w2, #0
  beq fim_loop

  // Converte o dígito para numérico e adiciona ao acumulador
  sub w2, w2, #'0'

  // Multiplica o acumulador por 10
  movz w3, #10
  mul w7, w7, w3

  // Soma o valor do dígito ao acumulador
  add w7, w7, w2

  // Avança para o próximo caractere
  add x0, x0, #1
  b loop

fim_loop:
  // x1 contém o valor inteiro; agora convertemos para string
  ldr x2, =resultStrSize   // Aponta para o buffer
  mov x3, #10              // Divisor (10)

convert_to_string:
  udiv w4, w7, w3      // Divide x1 por 10, resultado em w4
  msub w5, w4, w3, w7  // Calcula o resto: w5 = w1 - (w4 * w3)
  add w5, w5, #'0'     // Converte o dígito restante para ASCII
  strb w5, [x2, #-1]!  // Armazena o caractere no buffer (em ordem reversa)
  mov w7, w4           // Atualiza x1 para o quociente
  cbz w7, print_number // Se x1 == 0, termina a conversão
  b convert_to_string

print_number:
  mov x0, 1
  ldr x1, =result
  ldr x2, =result_len
  mov x8, 64
  svc 0

  mov x0, 1                  // Descritor de arquivo para stdout
  sub x1, x2, resultStrSize   // Calcula o número de caracteres armazenados no buffer
  ldr x2, =resultStrSize_len  // Aponta para o início do buffer
  mov x8, 64                  // Syscall write
  svc 0                       // chamada do sistema

  mov x0, 1
  ldr x1, =newLine
  ldr x2, =newLine_len
  mov x8, 64
  svc 0

  // Sai do progama
  mov x0, 0
  mov x8, 93
  svc 0
