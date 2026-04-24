# Synaxis Koinonia — Documentação do Sistema

## Sumário

1. [Visão Geral](#visão-geral)
2. [Controle de Acesso](#controle-de-acesso)
3. [Submissão de Eventos](#submissão-de-eventos)
4. [Edição de Evento (Pré-Validação)](#edição-de-evento-pré-validação)
5. [Painel do Validador](#painel-do-validador)
6. [Aprovação de Evento](#aprovação-de-evento)
7. [Reprovação de Evento](#reprovação-de-evento)
8. [Gestão de Posts Sociais](#gestão-de-posts-sociais)
9. [Administração](#administração)
10. [Sistema de Email](#sistema-de-email)
11. [Regras de Negócio](#regras-de-negócio)
12. [Página Pública de Eventos](#página-pública-de-eventos)
13. [Modelagem de Dados](#modelagem-de-dados)
14. [Stack Técnica Sugerida](#stack-técnica-sugerida)
15. [Qualidade e Segurança de Código](#qualidade-e-segurança-de-código)

---

## Visão Geral

O **Synaxis Koinonia** é uma plataforma de curadoria e divulgação de eventos eclesiásticos. O sistema permite que qualquer pessoa (submissor anônimo) sugira eventos, que passam por uma fila de validação antes de serem publicados automaticamente nas redes sociais da organização. O objetivo é centralizar e padronizar a divulgação, eliminando o trabalho manual de postagem em múltiplas plataformas.

**Fluxo principal:**

```
Submissor envia evento → Evento fica Pendente → Validador aprova/reprova → Se aprovado, publica nas redes sociais
```

---

## Controle de Acesso

### Perfis do Sistema

O sistema possui três perfis com níveis de acesso distintos:

| Perfil      | Autenticação          | Descrição                                                |
|-------------|----------------------|----------------------------------------------------------|
| Admin       | Login com senha       | Gerencia validadores e tem acesso ao histórico de ações  |
| Validador   | Login com senha       | Aprova, reprova e edita eventos pendentes                |
| Submissor   | Nenhuma (anônimo)     | Envia sugestões de eventos pelo formulário público       |

### Detalhamento por Perfil

**Admin:**

- Cadastra validadores via **whitelist de email** (o validador recebe convite/credenciais por email).
- Remove validadores.
- Acessa logs/histórico de ações (quem aprovou/reprovou cada evento).

**Validador:**

- Faz login com email e senha.
- Pode **remover a si mesmo** do sistema (auto-exclusão).
- Não pode adicionar outros validadores.

**Submissor:**

- Não precisa de conta nem autenticação.
- Pode, opcionalmente, informar um email para receber um link de edição e notificações.

---

## Submissão de Eventos

### Formulário Público

O formulário de submissão é acessível sem login. Os campos são:

| Campo                  | Obrigatório | Observações                                                                 |
|------------------------|:-----------:|-----------------------------------------------------------------------------|
| Título do evento       | Sim         | —                                                                           |
| Igreja / Organização   | Sim         | Nome da comunidade ou grupo responsável                                     |
| Data e hora            | Sim         | Data e horário de início do evento                                          |
| Local                  | Sim         | Endereço completo + cidade                                                  |
| Descrição              | Sim         | Texto livre descrevendo o evento                                            |
| Banner de divulgação   | Sim         | Imagem no formato **1:1 (quadrado)**. Formatos aceitos: JPEG, PNG, JPG      |
| Perfil de divulgação   | Sim         | @ do submissor/anfitrião (ex: `@igreja_tal`, `@jovens_da_igreja`)           |
| Contato público        | Sim         | Veja observação importante abaixo                                           |
| Valor                  | Não         | Padrão: **Entrada Franca**. Preenchido apenas se houver cobrança            |
| Email do submissor     | Não         | Se informado, habilita link de edição e notificações                        |

#### Sobre o Banner de Divulgação

A imagem de banner é **obrigatória** e será utilizada nas publicações das redes sociais. Requisitos:

- **Enquadramento:** 1:1 (quadrado).
- **Formatos aceitos:** `.jpeg`, `.jpg`, `.png`.
- O sistema deve validar a proporção e o formato no upload, rejeitando imagens fora do padrão.

#### Sobre "Contato Público" vs "Email do Submissor"

Estes são **dois campos independentes** no banco de dados e com finalidades completamente distintas:

| Campo               | Finalidade                                  | Publicado nas redes? | Coluna no banco       |
|----------------------|---------------------------------------------|:--------------------:|-----------------------|
| **Contato público**  | Meio de contato para interessados no evento  | **Sim**              | `public_contact`      |
| **Email do submissor** | Receber token de edição e notificações      | **Nunca**            | `submitter_email`     |

O **contato público** pode ser um email, telefone ou WhatsApp — é o canal que o submissor deseja expor publicamente para que interessados entrem em contato sobre o evento. Este dado **será publicado** nos posts das redes sociais e na página pública.

O **email do submissor** é utilizado exclusivamente pelo sistema para envio de magic link, notificação de aprovação e notificação de reprovação. Este dado **nunca** é divulgado.

> **Atenção:** Caso o submissor informe o mesmo endereço de email nos dois campos, o email será publicado como contato público. O sistema não impede isso, mas a responsabilidade é do submissor. São campos independentes e tratados de forma distinta.

### Comportamento Conforme Presença do Email do Submissor

**Com email informado:**

- O sistema envia um **magic link (token de edição)** para o email do submissor.
- O token expira em **24 horas** ou quando o evento sair do estado `Pendente` (o que ocorrer primeiro).
- Enquanto válido, o submissor pode editar os campos do evento ou **excluí-lo**.

**Sem email:**

- O evento fica **imutável** pelo submissor após o envio.
- Apenas validadores podem editá-lo.

### Estados do Evento

Todo evento passa por um ciclo de vida com três estados possíveis:

```
                    ┌──────────┐
  Criação ────────► │ Pendente │ ◄── Submissor pode editar/excluir (via token)
                    └────┬─────┘
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
        ┌───────────┐        ┌───────────┐
        │ Aprovado  │        │ Rejeitado │
        └───────────┘        └───────────┘
```

| Estado    | Visível publicamente | Editável pelo submissor | Excluível pelo submissor | Editável pelo validador |
|-----------|:--------------------:|:-----------------------:|:------------------------:|:-----------------------:|
| Pendente  | Não                  | Sim (se tem token)      | Sim (se tem token)       | Sim                     |
| Aprovado  | Sim                  | Não                     | Não                      | Sim                     |
| Rejeitado | Não                  | Não                     | Não                      | Não (soft deleted)      |

---

## Edição de Evento (Pré-Validação)

A edição e exclusão pelo submissor são possíveis **apenas enquanto o evento está Pendente** e o token de edição é válido.

### Mecanismo

- O submissor acessa o evento por um **magic link** único recebido por email.
- O link contém um token associado ao evento.

### Permissões via Token

| Ação             | Permitido | Condição                             |
|------------------|:---------:|--------------------------------------|
| Editar campos    | Sim       | Token válido + evento Pendente       |
| Excluir evento   | Sim       | Token válido + evento Pendente       |
| Alterar status   | Não       | —                                    |

A exclusão pelo submissor funciona como um **soft delete**: o evento é marcado como excluído e removido da fila de validação, mas o registro permanece no banco para fins de auditoria.

### Expiração do Token

O token se torna inválido quando:

- Passam-se **24 horas** desde a criação.
- O evento é **aprovado ou rejeitado** por um validador.

---

## Painel do Validador

### Lista de Eventos

O painel exibe os eventos em fila de validação com a seguinte ordenação padrão:

1. **Data do evento** — eventos mais próximos aparecem primeiro (urgência).
2. **Data de criação** — entre eventos com mesma data, os mais antigos de criação aparecem primeiro (FIFO).

### Ações Disponíveis

| Ação     | Descrição                                                         |
|----------|-------------------------------------------------------------------|
| Aprovar  | Publica o evento nas redes sociais e altera status para Aprovado  |
| Reprovar | Aplica soft delete e altera status para Rejeitado                 |
| Editar   | Altera campos do evento antes ou depois da aprovação              |

### Filtros

| Filtro             | Padrão   | Descrição                                       |
|--------------------|:--------:|-------------------------------------------------|
| Pendentes          | **Ativo** | Exibe apenas eventos aguardando validação       |
| Próximos (30 dias) | Inativo  | Limita a eventos que ocorrerão nos próximos 30 dias |

---

## Aprovação de Evento

Ao aprovar um evento, duas ações são disparadas automaticamente.

### 1. Publicação Automática nas Redes Sociais

O sistema cria posts nas seguintes plataformas via API:

| Plataforma | API                  |
|------------|----------------------|
| Instagram  | Meta Graph API       |
| Facebook   | Meta Graph API       |
| Twitter/X  | Twitter/X API        |

**Conteúdo do post:**

O post inclui **todos os campos públicos** do evento, incluindo o **banner de divulgação** como imagem do post:

- Banner de divulgação (imagem 1:1)
- Título do evento
- Igreja / Organização
- Data e hora
- Local (endereço + cidade)
- Descrição
- Perfil de divulgação (`@...`)
- Contato público (email, telefone ou WhatsApp)
- Valor (ou "Entrada Franca")

> **ATENÇÃO:** O email do submissor (`submitter_email`) **nunca** é divulgado nos posts. Apenas o campo `public_contact` é publicado.

### 2. Notificação ao Submissor (Opcional)

Se o submissor informou email na submissão, o sistema envia um email contendo os links dos posts publicados em cada rede social.

---

## Reprovação de Evento

Ao reprovar um evento:

- O evento recebe **soft delete** (não é removido do banco, apenas marcado como inativo).
- O status muda para `Rejeitado`.

### Justificativa e Notificação

O fluxo de notificação de reprovação depende de **três condições simultâneas**:

| Condição                                     | Necessária para envio do email |
|----------------------------------------------|:------------------------------:|
| Evento rejeitado                             | Sim                            |
| Validador preencheu o campo de justificativa | Sim                            |
| Submissor informou email na submissão        | Sim                            |

O validador tem a **opção** de preencher uma justificativa (campo de texto livre ou template pré-definido) ao reprovar um evento. O preenchimento **não é obrigatório**.

O email de reprovação **só é enviado** quando as três condições acima são atendidas. Se o validador não preencher a justificativa, ou se o submissor não informou email, nenhum email é disparado. O conteúdo do email inclui o título do evento e a justificativa fornecida pelo validador.

---

## Gestão de Posts Sociais

### Problema

Após a publicação automática, pode ser necessário editar ou remover posts nas redes sociais (correção de erros, cancelamento de eventos, etc.). Sem rastreamento, isso exigiria acesso manual a cada plataforma.

### Solução: Tabela `social_posts`

O sistema persiste a referência de cada post publicado:

| Coluna        | Tipo    | Descrição                                   |
|---------------|---------|---------------------------------------------|
| `id`          | PK      | Identificador interno                       |
| `event_id`    | FK      | Referência ao evento                        |
| `platform`    | string  | `instagram`, `facebook` ou `twitter`        |
| `external_id` | string  | ID do post retornado pela API da plataforma |
| `created_at`  | datetime| Data da publicação                          |
| `updated_at`  | datetime| Última atualização                          |

### Operações Disponíveis

| Ação           | Mecanismo                                                 |
|----------------|-----------------------------------------------------------|
| Editar post    | Chamada à API da plataforma usando o `external_id`        |
| Deletar post   | Chamada à API da plataforma usando o `external_id`        |

Essas operações são realizadas diretamente pelo painel do validador ou admin, sem necessidade de acessar as redes sociais manualmente.

---

## Administração

### Gestão de Validadores

| Ação                | Quem pode executar |
|---------------------|--------------------|
| Adicionar validador | Admin              |
| Remover validador   | Admin              |
| Auto-exclusão       | O próprio validador|

O cadastro de validadores é feito via **whitelist de email**: o admin adiciona o email, e o validador recebe um convite para criar suas credenciais.

### Histórico / Logs de Ações

O sistema mantém um registro auditável de todas as ações de validação:

| Dado registrado   | Exemplo                                                      |
|--------------------|--------------------------------------------------------------|
| Ação executada     | `aprovação`, `reprovação`, `edição`, `exclusão pelo submissor` |
| Quem executou      | Email/ID do validador (ou `submissor via token`)             |
| Evento afetado     | ID e título do evento                                        |
| Timestamp          | Data e hora da ação                                          |
| Detalhes           | Justificativa de reprovação (quando houver)                  |

---

## Sistema de Email

### Tipos de Email

| Tipo                        | Destinatário | Disparado quando                                                            | Obrigatório |
|-----------------------------|--------------|-----------------------------------------------------------------------------|:-----------:|
| Token de edição (magic link)| Submissor    | Submissão com email informado                                               | Não*        |
| Notificação de aprovação    | Submissor    | Evento aprovado + submissor informou email                                  | Não*        |
| Notificação de reprovação   | Submissor    | Evento rejeitado + justificativa preenchida + submissor informou email      | Não*        |

*\* "Não obrigatório" significa que o envio depende de o submissor ter informado email e/ou do validador ter preenchido a justificativa.*

### Regras de Expiração de Tokens

- Expiram em **24 horas** após a criação.
- Expiram **imediatamente** quando o evento sai do estado `Pendente` (aprovado ou rejeitado).

---

## Regras de Negócio

### Visibilidade

- Eventos **não validados** (Pendente ou Rejeitado) **não aparecem** na página pública.
- Apenas eventos com status `Aprovado` são listados publicamente.

### Imutabilidade Pós-Aprovação

- Após aprovação, o evento se torna **imutável para o submissor**.
- Apenas **validadores** podem editar eventos aprovados (via painel).
- A edição de um evento aprovado deve refletir nos posts das redes sociais (via atualização por API).

### Exclusão pelo Submissor

- O submissor pode excluir seu próprio evento **apenas** enquanto o status é `Pendente` **e** o token de edição é válido (dentro das 24h).
- A exclusão é um **soft delete** e é registrada nos logs de ação.

### Anti-Spam

| Mecanismo    | Descrição                                                    |
|--------------|--------------------------------------------------------------|
| Rate limit   | Limite de submissões por IP por intervalo de tempo            |
| CAPTCHA      | Verificação no formulário de submissão para evitar bots       |

---

## Página Pública de Eventos

A página pública lista os eventos aprovados para consulta de qualquer visitante.

### Ordenação

- Eventos ordenados do **mais próximo ao mais distante** no tempo.

### Filtros

| Filtro  | Comportamento padrão                                              |
|---------|-------------------------------------------------------------------|
| Cidade  | Sem filtro (mostra todas as cidades)                              |
| Data    | Por padrão, exibe apenas eventos **futuros** (data ≥ hoje)       |

### Exportação

- Cada evento pode ser **exportado para o Google Calendar** (botão de adicionar ao calendário).

---

## Modelagem de Dados

### Diagrama Entidade-Relacionamento (Simplificado)

```
┌──────────────┐       ┌──────────────────┐       ┌─────────────────────┐
│   admins     │       │    validators    │       │       events        │
├──────────────┤       ├──────────────────┤       ├─────────────────────┤
│ id           │       │ id               │       │ id                  │
│ email        │       │ email            │       │ title               │
│ password_hash│       │ password_hash    │       │ organization        │
│ deleted_at   │       │ deleted_at       │       │ event_date          │
│ created_at   │       │ created_at       │       │ location            │
│ updated_at   │       │ updated_at       │       │ city                │
└──────────────┘       └──────────────────┘       │ description         │
                                                  │ banner (attachment) │
┌──────────────────┐                              │ profile_handle      │
│  social_posts    │                              │ public_contact      │
├──────────────────┤                              │ price               │
│ id               │──────────────────────────┐   │ submitter_email     │
│ event_id (FK)    │                          │   │ status              │
│ platform         │                          │   │ edit_token          │
│ external_id      │                          │   │ token_expires_at    │
│ deleted_at       │                          │   │ deleted_at          │
│ created_at       │                          └──►│ created_at          │
│ updated_at       │                              │ updated_at          │
└──────────────────┘                              └─────────────────────┘

┌──────────────────┐
│  action_logs     │
├──────────────────┤
│ id               │
│ validator_id (FK)│
│ event_id (FK)    │
│ action           │
│ details          │
│ deleted_at       │
│ created_at       │
│ updated_at       │
└──────────────────┘
```

### Campos-Chave da Tabela `events`

| Campo              | Tipo            | Observações                                                         |
|--------------------|-----------------|---------------------------------------------------------------------|
| `status`           | enum            | `pending`, `approved`, `rejected`                                   |
| `banner`           | attachment (AS) | Imagem 1:1 (quadrado), JPEG/PNG. Armazenada via Active Storage      |
| `public_contact`   | string          | Contato público (email, telefone ou WhatsApp). **Publicado nas redes** |
| `submitter_email`  | string (nullable)| Email privado do submissor. **Nunca publicado**                    |
| `edit_token`       | string          | Token UUID gerado na submissão (se email informado)                 |
| `token_expires_at` | datetime        | Expiração do token (24h após criação)                               |
| `deleted_at`       | datetime        | `NULL` se ativo; preenchido no soft delete                          |
| `price`            | string          | Padrão: `"Entrada Franca"`                                          |

---

## Stack Técnica Sugerida

| Camada            | Tecnologia                                            |
|-------------------|-------------------------------------------------------|
| Backend           | Ruby on Rails (fullstack, MVC)                        |
| Banco de dados    | PostgreSQL                                            |
| Fila de jobs      | Sidekiq + Redis (publicação nas redes, emails)        |
| Emails            | Action Mailer + serviço SMTP (SendGrid, etc.)         |
| Autenticação      | Devise (validadores/admin)                            |
| Upload de imagens | Active Storage (com validação de formato e proporção)  |
| Anti-spam         | Rack::Attack (rate limit) + reCAPTCHA                 |
| APIs sociais      | Koala (Facebook/Instagram), twitter gem (X)           |
| Frontend          | Tailwind CSS + Hotwire (Turbo + Stimulus) + Phlex     |
| Deploy            | Docker + servidor Linux                               |

### Detalhamento do Frontend

| Tecnologia   | Papel                                                                          |
|--------------|--------------------------------------------------------------------------------|
| Tailwind CSS | Framework utilitário de CSS para estilização responsiva                        |
| Turbo        | Navegação SPA-like sem JavaScript customizado (Turbo Drive, Frames, Streams)   |
| Stimulus     | Controllers JS leves para interatividade pontual                               |
| Phlex        | View components em Ruby puro, substituindo ERB/Partials com composição tipada  |

A interface é **server-side rendered** com aprimoramentos progressivos via Hotwire. Todas as telas são **responsivas** por padrão, utilizando as classes utilitárias do Tailwind.

---

## Qualidade e Segurança de Código

O projeto adota ferramentas de análise e validação para garantir a qualidade, segurança e manutenibilidade do código.

### Segurança de Dependências

| Ferramenta       | Finalidade                                                                    | Comando                                   |
|------------------|-------------------------------------------------------------------------------|--------------------------------------------|
| **Brakeman**     | Análise estática de segurança específica para Rails (SQL injection, XSS, etc.) | `bundle exec brakeman`                     |
| **Bundler Audit**| Verifica vulnerabilidades conhecidas (CVEs) nas gems do projeto                | `bundle exec bundle-audit check --update`  |

Ambas as ferramentas devem ser executadas no CI antes de cada merge em branches protegidas.

### Formatação e Estilo de Código

| Ferramenta   | Finalidade                                           | Comando                |
|--------------|------------------------------------------------------|------------------------|
| **RuboCop**  | Linter e formatador para padronização de estilo Ruby  | `bundle exec rubocop`  |

O projeto deve incluir um `.rubocop.yml` com as regras acordadas pela equipe.

**Importante: o RuboCop opera em dois modos distintos conforme o ambiente.**

| Ambiente | Comando                              | Comportamento                                     |
|----------|--------------------------------------|----------------------------------------------------|
| Local    | `bundle exec rubocop -A`             | Corrige automaticamente e o dev commita o resultado |
| CI       | `bundle exec rubocop --fail-level warning` | Apenas verifica (read-only) — falha a pipeline se houver ofensas, sem alterar arquivos nem gerar commits |

No CI o RuboCop **nunca** executa com `-A` (autocorreção). Ele apenas valida o código e retorna exit code diferente de zero caso existam ofensas, bloqueando o merge. Isso evita um ciclo infinito onde a correção geraria um commit que dispararia uma nova pipeline.

Para garantir que o desenvolvedor rode o RuboCop antes do push, recomenda-se configurar um **git hook de pre-commit** (via gem `overcommit` ou manualmente em `.git/hooks/pre-commit`).

### Análise Estática de Qualidade

| Ferramenta      | Finalidade                                                                          | Comando                   |
|-----------------|-------------------------------------------------------------------------------------|---------------------------|
| **RubyCritic**  | Relatório de qualidade com métricas de complexidade, churn e code smells             | `bundle exec rubycritic`  |

O RubyCritic combina as ferramentas Reek, Flay e Flog internamente, gerando um relatório HTML navegável com score por arquivo. Útil para identificar trechos que precisam de refatoração.

### Testes

| Ferramenta | Finalidade                                       | Comando              |
|------------|--------------------------------------------------|----------------------|
| **RSpec**  | Testes unitários e de integração                  | `bundle exec rspec`  |

O projeto deve manter cobertura de testes para models, services, controllers e jobs. Recomenda-se utilizar `SimpleCov` para acompanhar a cobertura de código.

### Pipeline de CI Recomendado

```
1. bundle install
2. bundle exec rubocop                      → Formatação e estilo
3. bundle exec brakeman                     → Segurança do código
4. bundle exec bundle-audit check --update  → Segurança das gems
5. bundle exec rspec                        → Testes
6. bundle exec rubycritic                   → Relatório de qualidade (opcional no CI, obrigatório em revisão)
```