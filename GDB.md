---

1. Compilação

Compile o código Assembly com informações de depuração (-g) e gere o arquivo objeto:

as -g -o arquivo.o arquivo.s

Depois, linke para criar o executável:

ld -o executavel arquivo.o


---

2. Iniciar o GDB

Abra o executável no GDB:

gdb executavel


---

3. Ponto de Partida no GDB

Dentro do GDB, inicie a depuração:

Colocar um ponto de parada no início do programa:

break *_start

Iniciar o programa:

run

Reiniciar o programa (caso necessário):

start


---

4. Depuração Passo a Passo

Entrar no layout Assembly (visualização das instruções):

layout asm

Executar a próxima instrução:

stepi

Ver as próximas 10 instruções a partir do PC:

x/10i $pc

Examinar os registradores:

info registers

Ver uma string no endereço de memória (substitua endereço pelo valor do registrador ou endereço direto):

x/s endereço

Examinar valores em formato hexadecimal:

x/x endereço


---

5. Inspeção de Memória

Examinar conteúdo da memória a partir de um endereço (em bytes, palavras ou strings):

Em formato string:

x/s endereço

Em formato hexadecimal (4 bytes por leitura):

x/x endereço

Para mais bytes, substitua x por o número de entradas, como x/10x endereço.



---

6. Ver o Fluxo do Código

Mostrar próximas instruções:

x/10i $pc

Mostrar o código atual em Assembly (atualiza conforme você avança):

layout asm


---

7. Controle do Fluxo

Continuar até o próximo ponto de parada ou syscall:

continue

Finalizar o programa no GDB:

quit


