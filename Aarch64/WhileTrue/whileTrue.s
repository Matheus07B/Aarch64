.global _start

.section .data
  mensagem: .asciz "loop infinito" // 14 \n, 13 sem

.section .text

_start:
  mov x7, 0             
  // move um valor para x7 64 bits, OBS: se tirar o codigo comeca a bugar.
  // Começa a bugar pois ele printa as mensagens muito rapido.
  // Mas no geral não é necessário.

loop:
  bl print              // Chama a funcao de printar.
  bl loop               // Chama o loop denovo, entao vai da linha 16 para a 14 infinitamente.

// Funcao para printar a mensagem.
print:
  mov x0, 1
  ldr x1, =mensagem
  mov x2, 13
  mov x8, 64
  svc 0
  ret

// Somente necessário em loops finitos
// No caso essa função nunca é chamada pois não tem um "Break" nesse loop.
exit:
  mov x0, 0
  mov x8, 93
  svc 0
  ret
  // ret não necessário pois depois da chamada do sistema o código automaticamente encerra.
