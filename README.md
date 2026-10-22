# PregãoOS — primeira versão demonstrativa

Protótipo navegável para validar a organização das áreas da Organização Social, do pregoeiro e dos fornecedores. Os dados exibidos são fictícios. Esta versão não deve ser usada para receber propostas reais nem para conduzir uma seleção oficial.

## Como testar

Abra `index.html` no navegador. O seletor no topo simula os perfis para facilitar a revisão das telas. No perfil **Operador especial**, aparece o comando de aviso de 2 minutos; ao acioná-lo, a contagem simulada é exibida para os demais perfis.

## Regra especial do cronômetro

Na aplicação conectada, o comando será autorizado no servidor por uma permissão individual `can_trigger_2m`, atribuída a somente um perfil por Organização Social. A ação será gravada no histórico do processo. O seletor de perfil deste protótipo é apenas uma simulação de interface, não é autenticação ou controle de acesso.

O cronômetro começa privado para o pregoeiro. A publicação do aviso de 2 minutos deve sincronizar todos os participantes pelo horário do servidor. O comportamento do encerramento ao chegar a zero ficará configurável por processo, depois de validado com o regulamento da OS.

## Escopo desta entrega

- Navegação entre visão geral, processos, checklist documental, mensagens e usuários.
- Demonstração visual das funções por perfil.
- Comando de 2 minutos disponível apenas no perfil especial de demonstração.
- Esquema inicial do banco em `database/schema.sql`.

## Próximas etapas para uma versão operacional

1. Integrar autenticação e permissões com Neon Auth; retirar o seletor de perfis de demonstração.
2. Conectar os processos, propostas, documentos, mensagens e trilha de auditoria ao Neon.
3. Implementar armazenamento privado de arquivos, validação de tipo/tamanho e política de retenção.
4. Configurar envio de e-mail e notificações.
5. Revisar as regras com o regulamento de compras da OS antes de receber propostas reais.

## Stack

- Repositório: GitHub
- Banco e autenticação: Neon
- Hospedagem do protótipo: Vercel

