.global _start

// Define as constantes usadas para as chamadas de sistema (syscalls) de escrita, leitura e saída.
.equ sys_write, 64      // Código de syscall para escrita.
.equ sys_read, 63       // Código de syscall para leitura.
.equ sys_exit, 93       // Código de syscall para saída do programa.

.section .data
  print: .asciz "\nFale uma coisa: "    // String que solicita uma entrada do usuário.
  print_len = . - print                 // Calcula o tamanho da string de forma dinâmica.

  read: .skip 512                       // Reserva um espaço de 512 bytes para o buffer de leitura de entrada.

  rest: .asciz "\nO resultado é: "      // String que indica o início do texto de saída.
  rest_len = . - rest                   // Calcula o tamanho da string de saída de forma dinâmica.

  newL: .asciz "\n"                     // String que representa uma nova linha.
  newL_len = . - newL                   // Calcula o tamanho da string de nova linha.

.section .text                          // Seção onde o código do programa é executado.

_start:                                 // Ponto de entrada do programa.
  mov x0, #1                            // Define o descritor de arquivo para saída (stdout).
  ldr x1, =print                        // Carrega o endereço da string `print`.
  ldr x2, =print_len                    // Carrega o comprimento da string `print`.
  ldr x8, =sys_write                    // Carrega o código de syscall para escrita.
  svc 0                                 // Realiza a syscall de escrita para exibir "Fale uma coisa: ".

  mov x0, #0                            // Define o descritor de arquivo para entrada (stdin).
  ldr x1, =read                         // Carrega o endereço do buffer `read` para armazenar a entrada.
  mov x2, #512                          // Define o tamanho máximo de leitura como 512 bytes.
  ldr x8, =sys_read                     // Carrega o código de syscall para leitura.
  svc 0                                 // Realiza a syscall de leitura para capturar a entrada do usuário.

  mov x0, #1                            // Define o descritor de arquivo para saída (stdout).
  ldr x1, =rest                         // Carrega o endereço da string `rest`.
  ldr x2, =rest_len                     // Carrega o comprimento da string `rest`.
  ldr x8, =sys_write                    // Carrega o código de syscall para escrita.
  svc 0                                 // Realiza a syscall de escrita para exibir "O resultado é: ".

  mov x0, #1                            // Define o descritor de arquivo para saída (stdout).
  ldr x1, =read                         // Carrega o endereço do buffer `read`, que contém o texto lido do usuário.
  mov x2, #512                          // Define o tamanho do texto a ser exibido (até 512 bytes).
  ldr x8, =sys_write                    // Carrega o código de syscall para escrita.
  svc 0                                 // Realiza a syscall de escrita para exibir a entrada do usuário.

  mov x0, #1                            // Define o descritor de arquivo para saída (stdout).
  ldr x1, =newL                         // Carrega o endereço da string `newL`.
  ldr x2, =newL_len                     // Carrega o comprimento da string `newL`.
  ldr x8, =sys_write                    // Carrega o código de syscall para escrita.
  svc 0                                 // Realiza a syscall de escrita para exibir uma nova linha.

  bl exit                               // Chama a função de saída.

exit:                                   // Função para finalizar o programa.
  mov x0, #0                            // Define o código de saída 0 (sucesso).
  ldr x8, =sys_exit                     // Carrega o código de syscall para saída do programa.
  svc 0                                 // Realiza a syscall de saída.
  // O programa termina aqui, por isso não há necessidade de retorno.
