# Pergunta 3 — E-mail e deliverability com Exim

## Onde verificar os logs do Exim

Os principais logs do Exim normalmente ficam em:

```text
/var/log/exim4/mainlog
/var/log/exim4/rejectlog
/var/log/exim4/paniclog
```

Em algumas distribuições, o diretório pode ser:

```text
/var/log/exim/
```

O arquivo mais importante para investigar entregas é o `mainlog`.

Exemplo:

```bash
tail -f /var/log/exim4/mainlog
```

Também é possível pesquisar pelo endereço do destinatário:

```bash
grep -i "usuario@dominio.com" /var/log/exim4/mainlog
```

Nos logs, eu procuraria:

* endereço do remetente e destinatário;
* código de resposta do servidor de destino;
* mensagens entregues;
* mensagens rejeitadas;
* erros temporários;
* falhas de conexão;
* bloqueios por spam ou reputação do IP.

Alguns indicadores comuns no log são:

* `=>`: mensagem entregue;
* `==`: entrega adiada temporariamente;
* `**`: falha definitiva;
* `rejected`: mensagem rejeitada.

Também verificaria a fila de e-mails:

```bash
exim -bp
```

ou:

```bash
exim4 -bp
```

## Como verificar se o IP está em blacklist

Primeiro, identificaria qual IP público está sendo utilizado para enviar os e-mails. Essa informação pode ser encontrada nos logs do Exim ou no cabeçalho de uma mensagem enviada.

Depois, consultaria esse IP em serviços de verificação de reputação e blacklists, como Spamhaus ou MXToolbox.

Além da blacklist, também verificaria se o domínio possui:

* SPF;
* DKIM;
* DMARC;
* PTR ou DNS reverso.

## Como explicar para um cliente não técnico

Eu explicaria da seguinte forma:

> O servidor que envia os e-mails pode estar com uma configuração incompleta ou com a reputação prejudicada. Os provedores, como Gmail e Outlook, analisam essas informações para decidir se uma mensagem deve ser entregue, enviada para o spam ou bloqueada.
>
> Vamos verificar a configuração do domínio, a reputação do servidor e se houve algum envio indevido. Depois de corrigir a causa, também podemos solicitar a remoção do IP de listas de bloqueio, quando necessário.

Eu evitaria prometer uma correção imediata, pois mesmo depois dos ajustes a reputação pode levar algum tempo para melhorar.

## Script de verificação

O script `check_email_dns.sh` verifica:

* SPF;
* DKIM;
* DMARC;
* PTR ou DNS reverso.

### Dependência

Debian ou Ubuntu:

```bash
sudo apt install dnsutils
```

RHEL, Rocky Linux ou AlmaLinux:

```bash
sudo dnf install bind-utils
```

### Execução

```bash
chmod +x check_email_dns.sh
./check_email_dns.sh dominio.com
```

O script utiliza o seletor DKIM `default`.

Como o seletor DKIM pode ter outro nome, a ausência do registro `default._domainkey` não significa obrigatoriamente que o domínio não possui DKIM.

## Evidências

Foi realizada a execução do script utilizando o domínio `google.com`.

Comando utilizado:

```bash
./check_email_dns.sh google.com
```

Resultado da execução:

- Print: `evidencias/evidencia-google.png`
- Saída do terminal: `evidencias/evidencia-google.txt`

