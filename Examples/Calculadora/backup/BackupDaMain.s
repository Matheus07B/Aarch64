.global _start

.data
  Calculadora: .ascii "Calculadora Assembly 2024\n\n"
  Calculadora_len = . - Calculadora

  opcoes: .ascii "1 - Soma\n2 - Subtração\n3 - Multiplicação\n4 - Divisão\n\n"
  opcoes_len = . - opcoes

  operacao: .ascii "-> "
  operacao_len = . - operacao
  input: .skip 2

  num1: .ascii "\nNumero 1: "
  num1_len = . - num1
  num1Value: .skip 100

  num2: .ascii "Numero 2: "
  num2_len = . - num2
  num2Value: .skip 100

  Resultado: .ascii "\nResultado: "
  Resultado_len = . - Resultado

  blackSpace: .asciz " "

  ResultadoValor: .space 100
  ResultadoValor_len = . - ResultadoValor

  newLine: .ascii "\n"
  newLine_len = . - newLine

.text
_start:
  // Calculadora assembly Aarch64 20/11/2024
  mov x0, 1
  ldr x1, =Calculadora
  ldr x2, =Calculadora_len
  mov x8, 64
  svc 0

  // Leitura da operação
  mov x0, 1
  ldr x1, =opcoes
  ldr x2, =opcoes_len
  mov x8, 64
  svc 0

  mov x0, 1
  ldr x1, =operacao
  ldr x2, =operacao_len
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =input
  mov x2, 2                    // Reservar 2 bytes pois se o usuário colocar 1 ou 2, 3, 4, esses números terão um \n adicionado no final ex: "1\n"
  mov x8, 63
  svc 0

  // Leitura do número 1
  mov x0, 1
  ldr x1, =num1
  ldr x2, =num1_len
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =num1Value
  mov x2, 100
  mov x8, 63
  svc 0

  // Leitura do número 2
  mov x0, 1
  ldr x1, =num2
  ldr x2, =num2_len
  mov x8, 64
  svc 0

  mov x0, 0
  ldr x1, =num2Value
  mov x2, 100
  mov x8, 63
  svc 0

  // Inicia a primeira conversão
  ldr x0, =num1Value
  mov x1, #0
  b Conversao1

// Conversão do primeiro número
Conversao1:
  // Carrega o caractere atual
  ldrb w2, [x0]  // Use ldrb para carregar apenas 1 byte

  // Verifica se é o fim da string (nulo)
  cmp w2, #0
  beq fim_loop1

  // Verifica se é um dígito (ASCII '0' é 48)
  cmp w2, #'0'
  blt fim_loop1
  cmp w2, #'9'  // 9 em asciz é 57
  bgt fim_loop1

  // Converte o dígito para numérico e adiciona ao acumulador
  sub w2, w2, #'0'

  // Multiplica o acumulador por 10
  movz w3, #10
  mul w7, w7, w3

  // Soma o valor do dígito ao acumulador
  add w7, w7, w2

  // Avança para o próximo caractere
  add x0, x0, #1

  b Conversao1

fim_loop1:
  // Chama a função de sair
  mov x0, 0
  mov x1, 0
  mov x2, 0
  mov x3, 0

  // Inicia a segunda conversão
  ldr x0, =num2Value
  mov x1, #0
  b Conversao2

// Conversão do segundo número
Conversao2:
  // Carrega o caractere atual
  ldrb w2, [x0]  // Use ldrb para carregar apenas 1 byte

  // Verifica se é o fim da string (nulo)
  cmp w2, #0
  beq fim_loop2

  // Verifica se é um dígito (ASCII '0' é 48)
  cmp w2, #'0'
  blt fim_loop2
  cmp w2, #'9'  // 9 em asciz é 57
  bgt fim_loop2

  // Converte o dígito para numérico e adiciona ao acumulador
  sub w2, w2, #'0'

  // Multiplica o acumulador por 10
  movz w3, #10
  mul w9, w9, w3

  // Soma o valor do dígito ao acumulador
  add w9, w9, w2

  // Avança para o próximo caractere
  add x0, x0, #1

  b Conversao2

fim_loop2:
  // Zera os registradores
  mov x0, 0
  mov x1, 0
  mov x2, 0
  mov x3, 0

  add w10, w7, w9
  ldr x2, =ResultadoValor   // Aponta para a variavel que vai receber o valor
  mov x3, #10               // Divisor (10)

convert_to_string:
  udiv w4, w10, w3       // Divide x1 por 10, resultado em w4
  msub w5, w4, w3, w10   // Calcula o resto: w5 = w1 - (w4 * w3)
  add w5, w5, #'0'       // Converte o dígito restante para ASCII
  strb w5, [x2, #-1]!    // Armazena o caractere no buffer (em ordem reversa)
  mov w10, w4            // Atualiza x1 para o quociente
  cbz w10, print_number  // Se x1 == 0, termina a conversão
  b convert_to_string

print_number:
  mov x0, 1
  ldr x1, =Resultado
  ldr x2, =Resultado_len
  mov x8, 64
  svc 0

  mov x0, 1                     // Descritor de arquivo para stdout
  sub x10, x2, ResultadoValor   // Calcula o número de caracteres armazenados no buffer
  ldr x2, =ResultadoValor_len   // Aponta para o início do buffer
  mov x8, 64                    // Syscall write
  svc 0                         // chamada do sistema

  mov x0, 1
  ldr x1, =newLine
  ldr x2, =newLine_len
  mov x8, 64
  svc 0

  b exit

exit:
  mov x0, 0
  mov x8, 93
  svc 0
