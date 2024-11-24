.global _start

.data
  sw1: .ascii "\n1º Opção ativada!\n\n"
  sw1_len = . - sw1

  sw2: .ascii "\n2º Opção ativada!\n\n"
  sw2_len = . - sw2

  sw3: .ascii "\n3º Opção ativada!\n\n"
  sw3_len = . - sw3

  sw4: .ascii "\n4º Opção ativada!\n\n"
  sw4_len = . - sw4

  default: .ascii "\nOpção 'Default' ativada!\n\n"
  d_len = . - default

.text
// Rotinas aqui, ou "funções", dá no mesmo.
  b1:
    ldr x1, =sw1
    ldr x2, =sw1_len
    bl print
    b exit

  b2:
    ldr x1, =sw2
    ldr x2, =sw2_len
    bl print
    b exit

  b3:
    ldr x1, =sw3
    ldr x2, =sw3_len
    bl print
    b exit

  b4:
    ldr x1, =sw4
    ldr x2, =sw4_len
    bl print
    b exit

  Default:
   ldr x1, =default
   ldr x2, =d_len
   bl print
   b exit

// Ponto de partida do codigo aqui!
_start:
  // Indice do Switch aqui!
  mov x6, #90

  // Switch aqui!
  // 1º indice
  cmp x6, 1
  beq b1

  // 2º indice
  cmp x6, 2
  beq b2

  // 3º indice
  cmp x6, 3
  beq b3

  // 4º indice
  cmp x6, 4
  beq b4

  // Default indice caso nenhuma condição anterior tenha sido atendida!
  b Default

print:
  mov x0, 0
  mov x8, 64
  svc 0
  ret        // Necessário pois é onde retorna depois da chamada dessa rotina, ex: rotina b1 chamou print, entao depois disso essa rotina aqui tem que voltar para a rotina que a chamou, por isso uso bl, "Branch with link" pois grava o endereço da rotina que chamou a rotina print e depois volta pra lá.

exit:
  mov x0, 0
  mov x8, 93
  svc 0
