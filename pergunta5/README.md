# Pergunta 5 — Provisionamento de cliente com Puppet

## Objetivo

Esta questão implementa um módulo Puppet responsável pelo provisionamento automatizado de clientes em um ambiente de hospedagem compartilhada.

O objetivo foi demonstrar uma abordagem baseada em Infrastructure as Code (IaC), utilizando recursos declarativos, parametrização, templates e idempotência.

O módulo recebe como parâmetros os dados do cliente (domínio, usuário, banco de dados, porta do backend, etc.) e realiza o provisionamento completo do ambiente.

---

## Estrutura

```
pergunta5/
├── README.md
└── hosting/
    ├── evidencias/
    ├── examples/
    ├── manifests/
    ├── templates/
    ├── metadata.json
    └── README.md
```

---

## Funcionalidades implementadas

O módulo contempla:

- instalação da stack web compartilhada;
- criação do usuário e grupo do cliente;
- criação da estrutura isolada de diretórios;
- geração do Virtual Host do Nginx;
- template para Virtual Host do LiteSpeed;
- instalação automatizada do WordPress;
- geração do `wp-config.php`;
- instalação do plugin LiteSpeed Cache (LSCache);
- habilitação do cache através da constante `WP_CACHE`;
- suporte ao provisionamento de múltiplos clientes;
- execução idempotente.

---

## Estrutura do módulo

A documentação técnica completa encontra-se em:

```
hosting/README.md
```

---

## Execução do exemplo

Validação:

```bash
puppet parser validate hosting/manifests/*.pp
```

Simulação:

```bash
sudo puppet apply \
  --modulepath="$(pwd)" \
  hosting/examples/provision_client.pp \
  --noop
```

Aplicação:

```bash
sudo puppet apply \
  --modulepath="$(pwd)" \
  hosting/examples/provision_client.pp
```

---

## Evidências

Foram geradas evidências práticas durante o laboratório.

### Figura 1

Provisionamento de um novo cliente e reaplicação do catálogo demonstrando idempotência.

```
hosting/evidencias/01-provisionamento-idempotencia.png
```

### Figura 2

Validação do ambiente provisionado.

Inclui:

- estrutura de diretórios;
- usuários criados;
- Virtual Hosts;
- validação do Nginx;
- recursos provisionados.

```
hosting/evidencias/02-validacao-ambiente.png
```

---

## Premissas do laboratório

Para simplificação do ambiente de testes:

- Ubuntu Server 22.04;
- Puppet 7;
- Nginx instalado localmente;
- LiteSpeed representado através dos templates e parametrização do módulo;
- WordPress e plugin LSCache obtidos diretamente dos repositórios oficiais.

Em produção seria utilizada uma integração completa com OpenLiteSpeed/LiteSpeed Enterprise, banco de dados provisionado automaticamente, certificados TLS, isolamento adicional entre clientes e integração com DNS e automação de hospedagem.

Observação: Para facilitar os testes e demonstrar reutilização, o exemplo (examples/provision_client.pp) provisiona mais de um cliente utilizando o mesmo módulo, evidenciando sua capacidade de atender ambientes de hospedagem compartilhada.
