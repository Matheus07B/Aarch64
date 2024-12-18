.global _start

.data
  t1: .ascii "Calculador de IMC\n"
  t1_len = . - t1

  peso: .ascii "\nPeso: "
  peso_len = . - peso
  pesoValue: .skip 32

  altura: .ascii "Altura: "
  altura_len = . - altura
  alturaValue: .skip 32

  resultado: .ascii "\nResultado:   "
  resultado_len = . - resultado
  resultadoValue: .skip 32
  resultadoValue_len = . - resultadoValue

// Others
  nL: .ascii "\n"
  nL_len = . - nL

.text
_start:
  ldr x1, =t1
  ldr x2, =t1_len
  bl print

  // Peso + valor do peso.
  ldr x1, =peso
  ldr x2, =peso_len
  bl print

  ldr x1, =pesoValue
  mov x2, 32
  bl scan

  // Carrega o endereço da string em um registrador
  ldr x0, =pesoValue
  // Inicializa o acumulador (x1) com 0
  mov x1, #0
con1:
  // Carrega o caractere atual
  ldrb w2, [x0]  // Use ldrb para carregar apenas 1 byte

  // Verifica se é o fim da string (nulo)
  cmp w2, #0
  beq fim_con1

  // Verifica se é um dígito (ASCII '0' é 48)
  cmp w2, #'0'
  blt fim_con1
  cmp w2, #'9'  // 9 em asciz é 57
  bgt fim_con1

  // Converte o dígito para numérico e adiciona ao acumulador
  sub w2, w2, #'0'

  // Multiplica o acumulador por 10
  movz w3, #10
  mul w6, w6, w3

  // Soma o valor do dígito ao acumulador
  add w6, w6, w2

  // Avança para o próximo caractere
  add x0, x0, #1
  b con1

fim_con1:
  // Zerar os registradores
  mov x0, 0
  mov x1, 0
  mov x2, 0
  mov x8, 0

  // Altura + valor da altura.
  ldr x1, =altura
  ldr x2, =altura_len
  bl print

  ldr x1, =alturaValue
  mov x2, 32
  bl scan

  // Carrega o endereço da string em um registrador
  ldr x0, =alturaValue
  // Inicializa o acumulador (x1) com 0
  mov x1, #0
con2:
  // Carrega o caractere atual
  ldrb w2, [x0]  // Use ldrb para carregar apenas 1 byte

  // Verifica se é o fim da string (nulo)
  cmp w2, #0
  beq fim_con2

  // Verifica se é um dígito (ASCII '0' é 48)
  cmp w2, #'0'
  blt fim_con2
  cmp w2, #'9'  // 9 em asciz é 57
  bgt fim_con2

  // Converte o dígito para numérico e adiciona ao acumulador
  sub w2, w2, #'0'

  // Multiplica o acumulador por 10
  movz w3, #10
  mul w7, w7, w3

  // Soma o valor do dígito ao acumulador
  add w7, w7, w2

  // Avança para o próximo caractere
  add x0, x0, #1
  b con2

fim_con2:
  // Zerar os registradores
  mov x0, 0
  mov x1, 0
  mov x2, 0
  mov x8, 0

  // Calcula aqui o IMC. x6 = Peso | x7 = Altura
  add x7, x7, x7   // x7 = x7 + x7
  sdiv x9, x6, x7   // x9 = x6 / x7
  // b prep

prep:
  // x1 contém o valor inteiro; agora convertemos para string
  ldr x2, =resultadoValue   // Aponta para o buffer | x2
  mov x3, #10               // Divisor (10)

// Converte o resultado da conta para String.
convert_to_string:
  udiv w4, w9, w3      // Divide w9 por 10, resultado em w4
  msub w5, w4, w3, w9  // Calcula o resto: w5 = w9 - (w4 * w3)
  add w5, w5, #'0'     // Converte o dígito restante para ASCII
  strb w5, [x2, #-1]!  // Armazena o caractere no buffer (em ordem reversa)
  mov w9, w4           // Atualiza w9 para o quociente
  cbz w9, print_number // Se x1 == 0, termina a conversão
  b convert_to_string

// Valor final aqui.
print_number:
  // Depois de converter
  ldr x1, =resultado
  ldr x2, =resultado_len
  bl print

  // Teste
  // mov x2, 0
  // ldr x2, =resultadoValue

  mov x0, #1                    // Descritor de arquivo para stdout
  sub x1, x2, resultadoValue    // Calcula o número de caracteres armazenados no buffer
  ldr x2, =resultadoValue_len   // Aponta para o início do buffer
  mov x8, #64                   // Syscall write
  svc 0                         // chamada do sistema

  ldr x1, =nL
  ldr x2, =nL_len
  bl print

exit:
  mov x0, 0
  mov x8, 93
  svc 0

scan:
  mov x0, 0
  mov x8, 63
  svc 0
  ret

print:
  mov x0, 1
  mov x8, 64
  svc 0
  ret        // OBS: usar ret aqui para voltar para onde essa rotina foi chamada.
