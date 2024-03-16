#!/bin/bash

#Autor: André Pereira Noguiera
#GitHub: https://github.com/andrenogueiragbi
#Linkdin: www.linkedin.com/in/andré-pereira-nogueira
#Versão: 2024.1

#Caso de Uso: Imagina que vc precisa saber se o determinado email é válido, de forma
#possa valida se ele exist "eletronicamente", ou seja se é entregavel a algum 
#destinatarios. Logo esse pequeno script irá resolver isso:

#Como usar: ./check.sh <exemplo@dominio.com>

#Requisitos:
#1- Seu ip não deve estar na backlist: https://www.spamhaus.org/
#2- Sitema operacional Unix
#3- Ter instalado dig
#4- Ter instalado grep
#5- Ter instalado tail
#6- Ter instalado awk
#7- Ter instalado sed
#8- Ter instalado telnet



if [[ $1 == "-V" || $1 == "-v" || $1 == "-version" ]]; then
    echo
    echo "check-email.sh: 2024.1"
    echo
    exit 0
fi


if [[ $1 == "-h" || $1 == "-H" ]]; then
    echo
    echo "Como usar: ./check.sh <exemplo@dominio.com>"
    echo
    exit 0
fi


programas=("dig" "grep" "tail" "awk" "sed" "telnet")

for pg in "${programas[@]}"; do
    if ! command -v "$pg" &>/dev/null; then
        echo "ERRO: falta requisito instalado: ${pg}."
        exit 1
    fi
done




email=$1

if [ -z $email ]; then
    echo "ERRO: falta parâmetro do tipo e-mail."
    exit 1
fi

if [[ ! "$email" =~ "@" ]]; then
    echo "ERRO: o e-mail $email é inválido."
    exit 1
fi

inicio_email=$(echo $email | cut -d@ -f1)

if [ -z $inicio_email ]; then
    echo "ERRO: o inicio do e-mail está vazio."
    exit 1
fi


domain=$(echo $email | cut -d@ -f2)

if [ -z $domain ]; then
    echo "ERRO: o domínio está vazio."
    exit 1
fi


data_snmp=$(dig mx $domain | grep -A1 "ANSWER SECTION" | tail -n1 | awk '{print $NF}' | sed 's/\.$//')


if [ -z $data_snmp ]; then
    echo "ERRO: o dominio $domain não existe/registrado."
    exit 1
fi



exec 3<>/dev/tcp/$data_snmp/25



read -u 3 resposta
if [[ ! "$resposta" =~ ^220 ]]; then
    echo "ERRO: Falha em conectar ao servidor."
    exit 1
fi


# Enviando o comando EHLO
echo "HELO HI" >&3
{ read -u 3 -t 3 resposta; } || { echo "TEMPO PERDIDO: $resposta"; exit 1; }
if [[ ! "$resposta" =~ ^250 ]]; then
    echo "ERRO: falha ao iniciar comunicação com o servidor(HELO HI)."
    exit 1
fi


# Enviando o comando MAIL FROM
echo "MAIL FROM: <$email>" >&3 #MAIL FROM: <teste@teste>
read -u 3 resposta
if [[ ! "$resposta" =~ ^250 ]]; then
    echo "ERRO: falha ao iniciar comunicação com o servidor(MAIL FROM)."
    exit 1
fi

# Enviando o comando RCPT TO
echo "RCPT TO: <$email>" >&3  #RCPT TO: <andrepereiragbi2@gmail.com>
read -u 3 resposta
if [[ "$resposta" =~ "does not exist" ]]; then
    echo "ERRO: o e-mail $email não existe."
    exit 1
fi


if [[ "$resposta" =~ ^550 ]]; then
    echo "ERRO: falha ao iniciar comunicação com o servidor(RCPT TO)."
    exit 1
fi

echo "SUCESSO: O e-mail $email é existente."
exit 0


# Fechando a conexão Telnet
exec 3<&-
