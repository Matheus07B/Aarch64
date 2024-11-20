.global _start

.section .data
   msg: .asciz "ola\n"  // Adiciona uma nova linha para melhor visualização

.section .text

_start:
    mov x7, #0xA       // numero de vezes a se repitir o loop

    //movk x7, #0xF4, lsl 16 // Carrega 0xF4 na segunda parte de x7
    //movk x7, #0x240

loop:
    // Corpo do loop (aqui você colocaria o código que deseja repetir) {
    bl print
    // }

    sub x7, x7, 1    // subtrai o valor de x7 por 1 e armazena no x7
    cmp x7, #0       // Compara o registro x7 de 64 bits com 0
    bne loop         // se nao for 0, executa a funcao novamente

    bl exit          // caso seja 0, vai chamar a funcao de saida

print:
    mov x0, #1       // codigo de saida stdout 1
    ldr x1, =msg     // carrega o endereco "Buffer" da mensagem
    mov x2, #4       // tamanho da String, 4 bits
    mov x8, #64      // write, codigo de escrita
    svc 0            // chamada do sistema para executar a instrucao
    ret              // retorna a funcao

exit:
    // Código após o loop (fim do programa)
    mov x0, #0       //
    mov x8, #93      // sys_exit, codigo de saida 93
    svc 0            // chamada do sistema
    ret

