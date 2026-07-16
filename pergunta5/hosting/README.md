# Módulo Puppet — hosting

## Objetivo

O módulo `hosting` implementa o provisionamento automatizado de clientes para um ambiente de hospedagem compartilhada.

Foi desenvolvido de forma modular, parametrizada e idempotente, permitindo reutilização para múltiplos clientes.

---

# Estrutura

```
hosting/
├── examples/
├── manifests/
├── templates/
├── metadata.json
└── README.md
```

---

# Arquitetura

O módulo foi dividido em responsabilidades independentes.

| Manifest | Responsabilidade |
|----------|------------------|
| stack.pp | Instala e configura a stack compartilhada |
| user.pp | Cria usuário, grupo e estrutura de diretórios |
| wordpress.pp | Instala WordPress, gera wp-config.php e instala LSCache |
| vhost.pp | Gera o Virtual Host do Nginx e, opcionalmente, a configuração parametrizada do LiteSpeed |
| client.pp | Orquestra todo o provisionamento do cliente |

---

# Fluxo de provisionamento

A ordem lógica utilizada é:

```
hosting::stack

↓

hosting::user

↓

hosting::wordpress

↓

hosting::vhost
```

Cada recurso possui dependências explícitas para garantir um catálogo consistente.

---

# Templates

O módulo utiliza templates EPP para geração dos arquivos de configuração.

### nginx-vhost.conf.epp

Gera o Virtual Host do Nginx responsável pela camada de borda.

### litespeed-vhost.conf.epp

Modelo parametrizado para geração do Virtual Host do LiteSpeed. Essa implementação foi incluída no módulo, mas não executada no laboratório, pois a instalação do LiteSpeed depende de repositório e configuração próprios.

### wp-config.php.epp

Gera automaticamente o arquivo de configuração do WordPress contendo:

- banco de dados;
- usuário;
- senha;
- host;
- habilitação do cache (`WP_CACHE`).

---

# Exemplo de utilização

```puppet
class { 'hosting::stack':
  manage_litespeed => false,
}

hosting::client { 'cliente1':
  domain            => 'cliente1.test',
  system_user       => 'cliente1',
  backend_port      => 8101,
  db_name           => 'cliente1_wp',
  db_user           => 'cliente1_wp',
  db_password       => 'senha',
  manage_litespeed  => false,
}
```

No exemplo validado no laboratório, `manage_litespeed` permanece definido como `false`. Dessa forma, o provisionamento utiliza o Nginx, enquanto a implementação do LiteSpeed fica disponível de maneira opcional e parametrizada.

O diretório `examples/` contém um exemplo completo de provisionamento.

---

# Idempotência

Todos os recursos foram desenvolvidos considerando reexecuções sucessivas.

Após o ambiente já estar provisionado, uma nova execução do catálogo não gera alterações desnecessárias.

Downloads, extrações, criação de diretórios, geração de arquivos e demais recursos utilizam mecanismos declarativos (`creates`, `unless`, `require`, `subscribe`, etc.) para preservar a idempotência.

---

# Evidências

Durante o laboratório foram realizadas as seguintes validações:

- provisionamento de novos clientes;
- reaplicação do catálogo e verificação da idempotência;
- criação da estrutura isolada de diretórios;
- geração dos Virtual Hosts do Nginx;
- validação da configuração do Nginx;
- instalação do WordPress;
- instalação do plugin LSCache;
- habilitação do cache por meio da constante `WP_CACHE`.

A implementação parametrizada do LiteSpeed foi entregue nas classes e templates do módulo, mas não foi executada no laboratório, pois depende de repositório e configuração próprios.

![Provisionamento e idempotência](evidencias/01-provisionamento-idempotencia.png)

![Validação do ambiente](evidencias/02-validacao-ambiente.png)

---

# Melhorias para ambiente de produção

Em um ambiente real de hospedagem seriam adicionados recursos como:

- OpenLiteSpeed/LiteSpeed Enterprise totalmente configurado;
- criação automática do banco de dados e usuário;
- instalação completa do WordPress utilizando WP-CLI;
- emissão automática de certificados Let's Encrypt;
- integração com DNS;
- isolamento adicional entre clientes (ACLs, PHP pools, namespaces ou containers);
- monitoramento;
- backups automatizados;
- integração com CI/CD;
- gerenciamento de segredos (Vault ou equivalente).

---

# Considerações

O foco desta implementação foi demonstrar a estrutura do módulo Puppet, a separação de responsabilidades, a parametrização, a reutilização e a idempotência, conforme solicitado no desafio técnico.

O provisionamento com Nginx foi executado e validado no laboratório. O suporte ao LiteSpeed foi entregue como implementação opcional e parametrizada, mas não executado neste ambiente por depender de repositório e configuração próprios.
