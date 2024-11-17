.section .data
  mensagem: .asciz "loop infinito" // 14 \n, 13 sem

.section .text
  .global _start

_start:
  mov x7, 0             // move um valor para x7 64 bits, obs: se tirar o codigo comeca a bugar

loop:
  bl print              // chama a funcao de printar

  // add x7, x7, 1      // add ou sub
  // cmp x7, #10        // comparador, no caso x7 é = 10

  bl loop               // bne para loop finito, bl pata infinito

// Funcao para printar a mensagem
print:
  mov x0, 1
  ldr x1, =mensagem
  mov x2, 13
  mov x8, 64
  svc 0
  ret

// Somente necessário em loops finitos
exit:
  mov x0, 0
  mov x8, 93
  svc 0
  ret
