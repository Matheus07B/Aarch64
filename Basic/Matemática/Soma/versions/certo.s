.global _start

.section .data
result_msg:    .asciz "O resultado da soma é: "
newline:       .asciz "\n"

.section .text
_start:
    // Carregar os valores 5 e 3 nos registradores
    mov x0, #5        // Carregar 5 no registrador x0
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

convert_loop:
    udiv x7, x3, x5    // x7 = x3 / 10 (obtém o quociente)
    msub x8, x7, x5, x3 // x8 = x3 - (x7 * 10), ou seja, pega o resto
    add w8, w8, #48    // Converte o dígito para o valor ASCII ('0' é 48)
    strb w8, [x4, x6]  // Armazena o dígito na string (use w8, não x8)
    add x6, x6, #1     // Incrementa o índice da string
    mov x3, x7         // Atualiza o número com o quociente
    cmp x3, #0         // Verifica se o número já foi completamente dividido
    bne convert_loop   // Se não, continua o loop

    // Finaliza a string com o terminador nulo
    mov w8, #0
    strb w8, [x4, x6]

    ret

.section .bss
num_str: .skip 12   // Espaço para armazenar a string do número (suporta até 10 dígitos)
