.global _start

.data
value: .float 15.0 // 15 celsius -> fahr

// Conversores de Celsius para fahr
value1: .float 1.8
value2: .float 32.0

.text
_start:
    // Carregar o valor de ponto flutuante da memória (da seção de dados) para o registrador s0
    ldr x0, =value      // Carrega o endereço de 'value' para s0
    ldr s0, [x0]        // Carrega o valor de ponto flutuante de 'value' para o registrador s0
    ldr x1, =value1
    ldr s1, [x1]
    ldr x2, =value2
    ldr s2, [x2]

    // Conversão
    fmul s0, s0, s1   // s0 = 15.0 * 1.80
    fadd s2, s0, s2   // s2 = 27.0 + 32.0

    // Terminar o programa
    mov x8, #93         // Código de saída para o sistema (exit)
    mov x0, #0          // Código de retorno (0)
    svc #0              // Chama o serviço de sistema (exit)
