.global _start		

// Define as constantes que sao usadas para escrever, ler e sair.
.equ sys_write, 64	// Define o codigo de escrita.
.equ sys_read, 63	// Define o codigo de entrada.
.equ sys_exit, 93	// Define o codigo de saida.

.section .data				
  print: .asciz "\nFale uma coisa: "	// Buffer do tipo .asciz que tem um texto.
    print_len = . - print		// Calcula de forma dinamica o tamanho da String com base na quantidade de caracters.

  read: .skip 512			// Reserva 512 bits para o buffer do tipo .skip que representa um espaço vazio que pode ser preencido com numeros e textos.

  rest: .asciz "\nO resultado é: "	// Buffer do tipo .asciz  que tem um texto.
    rest_len = . - rest			// Calcula o tamanho do texto de forma dinamica.

  newL: .asciz "\n"			// Buffer do tipo .asciz que tem um texto.
    newL_len = . - newL			// Calcula o tamanho do texto de forma dinamica.

.section .text		// Onde o progama de fato é executado.

_start:			// Ponto inicial do progama
  mov x0, #1		// Move de forma imediata #1 para o registrador X0 de 64 bits, no caso 1 representa o descritor de saida stdin.
  ldr x1, =print	// Carrega o conteudo do texto aqui.
  ldr x2, =print_len	// Carrega o tamanho do texto aqui.
  ldr x8, =sys_write	// Carrega o codigo de escrita aqui.
  svc 0			// Chamada do sistema. syscall

  mov x0, #0		// Move de forma imediata #0 para o registrador X0 de 64 bits, no caso 0 representa o descritor de entrada stdout.
  ldr x1, =read		// Carrega o endereço, como ele é um endereço vazio, nada será carregado, apenas o endereço, o local na memoria onde ele está.
  mov x2, #512		// Reserva 512 bits para armazenar o texto, no caso se o texto possuir até 513 bits de caracters, nao vai ser reconhecido pois nao tem espaco para armazenar o mesmo.
  ldr x8, =sys_read	// Carrega o codigo de leitura aqui.
  svc 0			// Chamada do sistema. syscall

  mov x0, #1		//
  ldr x1, =rest		//
  ldr x2, =rest_len	//
  ldr x8, =sys_write	//
  svc 0			//

  mov x0, #1		//
  ldr x1, =read		//
  mov x2, #512		//
  ldr x8, =sys_write	//
  svc 0			//

  mov x0, #1		//
  ldr x1, =newL		//
  ldr x2, =newL_len	//
  ldr x8, =sys_write	//
  svc 0			//

  bl exit		// Chama a função de saida.

exit:			// Função de saida aqui.
  mov x0, 0		// Move para X0 zero para retornar tudo certo.
  ldr x8, =sys_exit	// carrega o codigo de saida no registrador X8.
  svc 0			// chamada do sistema. syscall.
  // nao tem ret porque o progama termina aqui.
