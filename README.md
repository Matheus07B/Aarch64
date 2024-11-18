# Intuito do Repositório

Este repositório foi criado com o objetivo de fornecer uma coleção de programas escritos em Assembly para a arquitetura AArch64, como parte de estudos e aprendizado sobre a linguagem de baixo nível e a arquitetura ARM.

## Como Compilar

Para compilar os programas, siga os seguintes passos:

1. **Assembler**: 
   - Utilize o comando `as` para montar o código Assembly:
     ```
     as -o nomeDoArquivo.o nomeDoArquivo.s
     ```
     - A opção `-g` é opcional e pode ser usada para incluir informações de depuração.

2. **Linker**:
   - Após a montagem, use o comando `ld` para gerar o executável:
     ```
     ld -o nomeDoArquivo nomeDoArquivo.o
     ```

3. **Executar**:
   - Para rodar o programa, basta usar:
     ```
     ./nomeDoArquivo
     ```

## Compilador

Este repositório utiliza o compilador `gcc` para compilar o código.
