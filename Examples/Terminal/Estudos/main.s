.global _start

.data
  // Input principal aqui!
  out: .ascii "AArch64 -> "
  out_len = . - out
  input: .skip 32

  // String "exit" para comparar
  exit_str: .ascii "exit"

  newLine1: .ascii "\n"
  newLine_len = . - newLine1

.text
_start:
  // Exibe o prompt
  mov x0, 1
  ldr x1, =out
  ldr x2, =out_len
  mov x8, 64
  svc 0

  // Lê a entrada do usuário
  mov x0, 0
  ldr x1, =input
  mov x2, 32
  mov x8, 63
  svc 0

  // Substituir o '\n' final por '\0'
  mov x2, #0               // Índice inicial
replace_newline:
  ldrb w3, [x1, x2]        // Carrega o próximo byte da entrada
  cmp w3, #'\n'            // Verifica se é '\n'
  bne not_newline          // Se não for, continua verificando
  mov w3, #0               // Substitui '\n' por '\0'
  strb w3, [x1, x2]        // Armazena o byte no buffer
  b done_replace
not_newline:
  add x2, x2, #1           // Avança para o próximo caractere
  cmp x2, #32              // Certifique-se de não ultrapassar o buffer
  bne replace_newline
done_replace:

  // Compara a entrada com "exit"
  ldr x0, =input        // Ponteiro para o buffer de entrada
  ldr x1, =exit_str     // Ponteiro para a string "exit"
  bl compare_strings    // Chama a função de comparação

  // Verifica o resultado da comparação
  cmp w0, #1            // Se w0 == 1, as strings são iguais
  beq exit              // Sai do programa

  // Se não for "exit", volta para o início
  b _start

// Rotina de saída
exit:
  mov x0, 0
  mov x8, 93
  svc 0

// Função para comparar strings
// Retorna 1 em w0 se as strings forem iguais, 0 caso contrário
compare_strings:
  mov w2, #0            // Índice

compare_loop:
  ldrb w3, [x0, x2]     // Carrega o byte atual da string de entrada
  ldrb w4, [x1, x2]     // Carrega o byte atual da string "exit"
  cmp w3, w4            // Compara os bytes
  bne strings_not_equal // Se forem diferentes, sai com 0
  cbz w3, strings_equal // Se atingir o nulo, as strings são iguais
  add w2, w2, #1        // Avança para o próximo caractere
  uxtw x2, w2           // Converte w2 para 64 bits
  b compare_loop        // Continua o loop

strings_not_equal:
  mov w0, #0            // Retorna 0 (não igual)
  ret

strings_equal:
  mov w0, #1            // Retorna 1 (igual)
  ret
