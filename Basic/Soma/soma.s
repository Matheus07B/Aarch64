.global _start

.section .data
result_msg:    .asciz "O resultado da soma é: "
newline:       .asciz "\n"

.section .text
_start:
    // Carregar os valores 5 e 3 nos registradores
    mov x0, #12        // Carregar 5 no registrador x0
    mov x1, #3        // Carregar 3 no registrador x1

    // Somar os valores
    add x2, x0, x1    // x2 = x0 + x1 (x2 = 5 + 3)

    // Escrever a mensagem "O resultado da soma é: "
    mov x0, #1        // file descriptor 1 (stdout)
    ldr x1, =result_msg
    mov x2, #23       // Tamanho da mensagem (23 bytes)
    mov x8, #64       // Chamada de sistema 'write' (sistema 64)
    svc #0            // Chama o sistema

    // Converter o número (resultado da soma) em string e exibir
    mov x3, x2        // Copiar o resultado da soma para x3
    bl int_to_str     // Chama a função para converter o número em string

    // Escrever o número
    mov x0, #1        // file descriptor 1 (stdout)
    ldr x1, =num_str  // Ponteiro para a string do número
    mov x2, #10       // Tamanho máximo da string (suporta até 10 dígitos)
    mov x8, #64       // Chamada de sistema 'write' (sistema 64)
    svc #0            // Chama o sistema

    // Escrever nova linha
    mov x0, #1        // file descriptor 1 (stdout)
    ldr x1, =newline   // Carrega a string de nova linha
    mov x2, #1         // Tamanho de nova linha
    mov x8, #64        // Chamada de sistema 'write'
    svc #0             // Chama o sistema

    // Chamada de sistema para terminar o programa
    mov x8, #93        // Código de sistema para saída (exit)
    mov x0, #0         // Código de retorno 0
    svc #0             // Chama o sistema

// Função para converter inteiro para string
int_to_str:
    // Inicia a conversão de x3 (número) para string
    ldr x4, =num_str   // Ponteiro para a string resultante
    mov x5, #10        // Base 10
    mov x6, #0         // Índice para a string

    // Trata o caso do número ser 0
    cmp x3, #0
    beq write_zero

convert_loop:
    udiv x7, x3, x5    // x7 = x3 / 10 (obtém o quociente)
    msub x8, x7, x5, x3 // x8 = x3 - (x7 * 10), ou seja, pega o resto
    add w8, w8, #48    // Converte o dígito para o valor ASCII ('0' é 48)
    strb w8, [x4, x6]  // Armazena o dígito na string
    add x6, x6, #1     // Incrementa o índice da string
    mov x3, x7         // Atualiza o número com o quociente
    cmp x3, #0         // Verifica se o número já foi completamente dividido
    bne convert_loop   // Se não, continua o loop

    // Finaliza a string com o terminador nulo
    mov w8, #0
    strb w8, [x4, x6]

    // Reverte a string (pois os dígitos foram armazenados do último para o primeiro)
    mov x7, x6         // Tamanho da string (x6 contém o índice final)
    mov x5, #0         // Inicializa o índice de reversão

reverse_loop:
    cmp x5, x7         // Verifica se já percorremos toda a string
    bge done_reverse   // Se sim, sai do loop
    ldrb w8, [x4, x5]  // Carrega o caractere na posição x5
    ldrb w9, [x4, x7]  // Carrega o caractere na posição x7-1
    strb w9, [x4, x5]  // Troca o caractere para a posição x5
    strb w8, [x4, x7]  // Troca o caractere para a posição x7-1
    add x5, x5, #1     // Avança o índice
    sub x7, x7, #1     // Retrocede o índice
    b reverse_loop     // Continua o loop

done_reverse:
    ret

write_zero:
    mov w8, #48        // Se o número for 0, coloca o ASCII de '0'
    strb w8, [x4, x6]  // Armazena o dígito '0' na string
    mov x6, #1         // Atualiza o índice da string
    mov w8, #0         // Finaliza a string com 0
    strb w8, [x4, x6]
    ret

.section .bss
  num_str: .skip 32   // Espaço para armazenar a string do número (suporta até 10 dígitos)
