.data
  minha_string: .ascii "12345"

.text
  // ... (previous code)

  // Carrega o endereço da string em um registrador
  ldr x0, =minha_string

  // Inicializa o acumulador (x1) com 0
  mov x1, #0

loop:
  // Carrega o caractere atual
  ldrb w2, [x0]
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

  // Load 10 into a register (w3)
  movz w3, #10, LSL #0

  // Multiply x1 by 10
  mul x1, x1, w3

  // Add w2 to x1
  add x1, x1, w2

  // Avança para o próximo caractere
  add x0, x0, #1
  b loop

fim_loop:

  // Agora x1 contém o valor inteiro
  // Move o valor para X7 e X9 (ajustando o tamanho se necessário)
  mov x7, x1
  mov x9, x1

  // ... (continuação do seu código)
