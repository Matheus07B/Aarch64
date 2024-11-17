.global _start

.data
  minha_string: .ascii "12266791"  // Final \0

  buffer: .space 20  // Buffer para armazenar o número convertido em string (máximo de 20 caracteres)
  buffer_Len = . - buffer

  newLine: .asciz "\n"
  newLine_Len = . - newLine

.text

_start:
  // Carrega o endereço da string em um registrador
  ldr x0, =minha_string

  // Inicializa o acumulador (x1) com 0
  mov x1, #0

loop:
  // Carrega o caractere atual
  ldrb w2, [x0]  // Use ldrb para carregar apenas 1 byte
  // Verifica se é o fim da string (nulo)
  cmp w2, #0
  beq fim_loop

  // Verifica se é um dígito (ASCII '0' é 48)
  cmp w2, #'0'
  blt fim_loop
  cmp w2, #'9'
  bgt fim_loop

  // Converte o dígito para numérico e adiciona ao acumulador
  sub w2, w2, #'0'

  // Multiplica o acumulador por 10
  movz w3, #10
  mul w1, w1, w3

  // Soma o valor do dígito ao acumulador
  add w1, w1, w2

  // Avança para o próximo caractere
  add x0, x0, #1
  b loop

fim_loop:
  // x1 contém o valor inteiro; agora convertemos para string
  ldr x2, =buffer   // Aponta para o buffer
  mov x3, #10       // Divisor (10)

convert_to_string:
  udiv w4, w1, w3   // Divide x1 por 10, resultado em w4
  msub w5, w4, w3, w1 // Calcula o resto: w5 = w1 - (w4 * w3)
  add w5, w5, #'0'  // Converte o dígito restante para ASCII
  strb w5, [x2, #-1]! // Armazena o caractere no buffer (em ordem reversa)
  mov w1, w4        // Atualiza x1 para o quociente
  cbz w1, print_number // Se x1 == 0, termina a conversão
  b convert_to_string

print_number:
  mov x0, 1          // Descritor de arquivo para stdout
  sub x1, x2, buffer // Calcula o tamanho da string
  ldr x2, =buffer_Len
  mov x8, #64        // Syscall write
  svc 0

space:
  mov x0, #1
  ldr x1, =newLine
  ldr x2, =newLine_Len
  mov x8, #64
  svc 0

exit:
  mov x8, #93        // Chamada ao sistema exit
  mov x0, #0
  svc 0
