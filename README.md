# PregãoOS — primeira versão demonstrativa

Protótipo navegável para validar a organização das áreas da Organização Social Humanizar, do pregoeiro e dos fornecedores. A identidade exibida usa o nome, a logo, o CNPJ 04.541.853/0001-91 e o site humanizar.org.br fornecidos para esta validação. Os dados dos processos continuam fictícios. Esta versão não deve ser usada para receber propostas reais nem para conduzir uma seleção oficial.

## Como testar

Abra `index.html` no navegador e vá em **Simular pregão**. O seletor no topo alterna os perfis no mesmo navegador:

1. No perfil **Administrador**, abra **Regras do pregão**, ajuste duração, redução mínima, encerramento do cronômetro e disponibilidade do chat; salve antes de iniciar.
2. No perfil **Fornecedor**, digite o valor da proposta inicial e clique em **Enviar proposta de teste**.
3. No perfil **Pregoeiro**, abra a disputa. O botão só fica disponível depois que a proposta for enviada; o cronômetro inicia privado com a duração configurada.
4. Volte ao perfil **Fornecedor**. Um campo verde **Digite seu lance (R$)** aparecerá; ajuste o valor para respeitar a redução mínima e clique em **Enviar meu lance**. No perfil **Pregoeiro**, também é possível inserir lances fictícios de outros participantes.
5. No perfil **Operador especial**, acione o aviso de 2 minutos durante a disputa. A contagem fica visível aos demais perfis; ao zerar, segue a regra definida pelo administrador.

As regras e ações são mantidas somente na memória desta aba; atualizar a página reinicia a simulação. As regras ficam bloqueadas quando a disputa começa. O seletor de perfil é um recurso de teste, não é autenticação nem controle de acesso.

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

