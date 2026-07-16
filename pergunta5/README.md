## Evidências

Foram realizadas duas capturas para documentar o comportamento do módulo Puppet.

### Figura 1 – Provisionamento e idempotência

Demonstra a criação de um novo cliente (`cliente3`) e a reaplicação do catálogo, evidenciando que nenhuma alteração adicional é realizada quando o ambiente já está provisionado.

Arquivo:

evidencias/01-provisionamento-idempotencia.png

### Figura 2 – Validação do ambiente

Apresenta as verificações finais do ambiente provisionado, incluindo a estrutura de diretórios, virtual hosts, validação da configuração do Nginx e demais recursos criados pelo módulo.

Arquivo:

evidencias/02-validacao-ambiente.png

## Características do módulo

- Estrutura modular (`stack`, `user`, `wordpress`, `vhost` e `client`);
- Provisionamento declarativo e reutilizável;
- Suporte a múltiplos clientes em um único catálogo;
- Recursos idempotentes;
- Separação entre infraestrutura compartilhada e recursos específicos do cliente;
- Templates parametrizados utilizando EPP;
- Ordem de dependências explícita entre os componentes;
- Preparado para integração com LiteSpeed/OpenLiteSpeed e WordPress com LSCache.
