.global _start

.data
value: .float 3.14         // Define o valor 3.14 na seção de dados
value1: .float 1.01

.text
_start:
    // Carregar o valor de ponto flutuante da memória (da seção de dados) para o registrador s0
    ldr x0, =value      // Carrega o endereço de 'value' para s0
    ldr s0, [x0]        // Carrega o valor de ponto flutuante de 'value' para o registrador s0
    ldr x1, =value1
    ldr s1, [x1]

    // soma
    fadd s1, s1, s0

    // Terminar o programa
    mov x8, #93         // Código de saída para o sistema (exit)
    mov x0, #0          // Código de retorno (0)
    svc #0              // Chama o serviço de sistema (exit)
