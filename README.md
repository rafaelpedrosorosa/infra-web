# Desafio Técnico Configr — Infraestrutura Web

Este repositório contém as soluções do desafio técnico de infraestrutura da Configr, contemplando troubleshooting, configuração de serviços web, entregabilidade de e-mails, containers e automação com Puppet.

As soluções foram documentadas com explicações técnicas, código, comandos de validação e evidências obtidas em laboratório.

## Ambiente utilizado

- Ubuntu Server 22.04.5 LTS;
- Nginx;
- PHP-FPM;
- MariaDB;
- Docker Compose;
- Puppet;
- Bash.

## Estrutura do repositório

- [Pergunta 1 — Linux e resolução de problemas](pergunta1/README.md)
- [Pergunta 2 — Nginx, LiteSpeed e WordPress](pergunta2/README.md)
- [Pergunta 3 — E-mail e deliverability com Exim](pergunta3/README.md)
- [Pergunta 4 — Containers com Docker Compose](pergunta4/README.md)
- [Pergunta 5 — Provisionamento de clientes com Puppet](pergunta5/README.md)

Cada diretório contém a documentação, os arquivos de implementação e, quando aplicável, as evidências da validação realizada.

## Metodologia

As questões foram desenvolvidas seguindo estas etapas:

1. análise dos requisitos e fundamentação técnica;
2. implementação dos arquivos de configuração, scripts ou código;
3. execução e validação prática no laboratório, quando aplicável;
4. verificação por comandos e testes funcionais;
5. documentação dos resultados com logs e capturas de tela.

## Observação sobre o LiteSpeed

O provisionamento com Nginx foi executado e validado no laboratório. O suporte ao LiteSpeed na Pergunta 5 foi entregue como implementação opcional e parametrizada no módulo Puppet, mas não executado no ambiente de testes, pois depende de repositório e configuração próprios.

## Resumo das entregas

| Questão | Entrega principal | Validação |
|---|---|---|
| 1 | Diagnóstico de erro HTTP 502 e script de health check | Testes com Nginx e PHP-FPM no laboratório |
| 2 | Virtual Host para WordPress com Nginx e PHP-FPM | Validação de sintaxe, requisições HTTP e URLs amigáveis |
| 3 | Investigação de entregabilidade e script de verificação de SPF, DKIM, DMARC e PTR/rDNS | Execução do script e análise dos registros DNS |
| 4 | Ambiente conteinerizado com Nginx, PHP-FPM e MariaDB | Inicialização dos containers e testes funcionais |
| 5 | Módulo Puppet parametrizado para provisionamento de clientes | Aplicação do catálogo, provisionamento de múltiplos clientes e verificação de idempotência |

## Premissas e limitações

As implementações foram desenvolvidas para fins de avaliação técnica em ambiente de laboratório. Dados como domínios, usuários, senhas, portas e caminhos utilizados nas configurações são exemplos e devem ser adaptados antes do uso em produção.

Credenciais presentes nos exemplos são fictícias e foram mantidas apenas para demonstrar a parametrização das soluções.
