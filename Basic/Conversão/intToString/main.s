.global _start

.data
  intToString: .skip 32
  iTS_len = . - intToString

  nL: .ascii "\n"
  nL_len = . - nL

.text
_start:
  movz x6, 0x10 // Número inteiro, OBS: pode ser em hexadecimal ou decimal mesmo ;)

  // x6 contém o valor inteiro; agora convertemos para string
  ldr x2, =intToString   // Aponta para o buffer
  mov x3, #10            // Divisor (10)

convert_to_string:
  udiv w4, w6, w3      // Divide x6 por 10, resultado em w4
  msub w5, w4, w3, w6  // Calcula o resto: w5 = w6 - (w4 * w3)
  add w5, w5, #'0'     // Converte o dígito restante para ASCII
  strb w5, [x2, #-1]!  // Armazena o caractere no buffer (em ordem reversa)
  mov w6, w4           // Atualiza x6 para o quociente
  cbz w6, print_number // Se x6 == 0, termina a conversão
  b convert_to_string

print_number:
  mov x0, #1                // Descritor de arquivo para stdout
  sub x1, x2, intToString   // Calcula o número de caracteres armazenados no buffer
  ldr x2, =iTS_len          // Aponta para o início do buffer
  mov x8, #64               // Syscall write
  svc 0                     // chamada do sistema

  bl newLine

  b exit

newLine:
  mov x0, 1
  ldr x1, =nL
  ldr x2, =nL_len
  mov x8, 64
  svc 0
  ret

exit:
  mov x0, 0
  mov x8, 93
  svc 0
