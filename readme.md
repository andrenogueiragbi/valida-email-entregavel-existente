
# Script em bash que valida e-mail é entregável

Encontrar o algoritmo que verifica se um e-mail está em uma estrutura válida é relativamente simples. No entanto, surge uma questão: o que acontece quando o e-mail está estruturalmente válido, mas não foi criado por ninguém? Ou seja, quando o domínio não existe ou o endereço de e-mail não está registrado?

Pois esse script em bash irá te ajudar nisso.



## Como usar

```
bash check-email.sh fulano@valida.com.br
```

## Exemplo domínio inexistente

```
$ bash check-email.sh andrepereiragbi@gmaluco.com.br
ERRO: o dominio gmaluco.com.br não existe/registrado.

```

## Exemplo e-mail inexistente

```
$ bash check-email.sh kandrepereiragbik@gmail.com  
ERRO: o e-mail kandrepereiragbik@gmail.com não existe.

```

## Exemplo e-mail valido
```
$ bash check-email.sh andrepereiragbi@gmail.com 
SUCESSO: O e-mail andrepereiragbi@gmail.com é existente.

```









## Dependencia

 - [dig](https://man.openbsd.org/dig.1)

 - [grep](https://www.gnu.org/software/grep/manual/grep.html)


 - [tail](https://www.gnu.org/savannah-checkouts/gnu/coreutils/manual/html_node/tail-invocation.html)


 - [awk](https://www.gnu.org/software/gawk/manual/gawk.html)

 - [sed](https://www.gnu.org/software/sed/manual/sed.html)

 - [telnet](https://linux.die.net/man/1/telnet)



   












## Autores

- [Github](https://github.com/andrenogueiragbi)
- [Linkdin](www.linkedin.com/in/andré-pereira-nogueira)
- [Site/Blog](https://tiandre.com.br/)



