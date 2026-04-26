# Synaxis Koinonia

Plataforma de curadoria e divulgação de eventos eclesiásticos. Submissão pública,
fila de validação por validadores convidados pelo admin, e publicação automática
nas redes sociais (Instagram, Facebook, X) ao aprovar.

## Stack

| Camada            | Escolha                                              |
|-------------------|------------------------------------------------------|
| Ruby / Rails      | 4.0.3 / 8.1.3                                        |
| Banco             | PostgreSQL 16, schema `sch_synaxis_koinonia`         |
| Filas             | Sidekiq + Redis                                      |
| Autenticação      | Devise (`Admin`, `Validador`)                        |
| Views             | Phlex (componentes Ruby puro)                        |
| CSS               | Tailwind CSS                                         |
| Testes            | RSpec + FactoryBot + Capybara + WebMock + SimpleCov  |
| APIs sociais      | `koala` (Instagram/Facebook) + `x` (Twitter v2)      |
| Anti-spam         | Rack::Attack + reCAPTCHA v3                          |
| iCal              | gem `icalendar`                                      |
| Banner            | gravado em `public/uploads/`, validado por `mini_magick` |
| Deploy            | Kamal (Postgres + Redis + role `job` Sidekiq)        |

## Setup local

Requisitos no host: Ruby 4.0.3, PostgreSQL 16, Redis 7, ImageMagick, Node opcional.

```bash
git clone <repo> && cd synaxis_koinonia
cp .env.example .env                       # preencher DEFAULT_DATABASE_*, INITIAL_ADMIN_*, SMTP_*, RECAPTCHA_*
bundle install
bin/setup                                   # cria schema sch_synaxis_koinonia, migra, seeda admin inicial
bin/dev                                     # Procfile.dev: Puma + Sidekiq + Tailwind watcher
```

Acesse `http://localhost:3000` (página pública), `http://localhost:3000/enviar`
(submissão), `http://localhost:3000/validador` e `/admin` (login Devise).

## Variáveis de ambiente

Veja `.env.example` para a lista completa. Resumo:

- **App**: `APP_HOST`, `RAILS_MASTER_KEY`, `SECRET_KEY_BASE`
- **Admin inicial (seed)**: `INITIAL_ADMIN_EMAIL`, `INITIAL_ADMIN_PASSWORD`
- **Banco**: `DEFAULT_DATABASE_HOST`, `DEFAULT_DATABASE_NAME`,
  `DEFAULT_DATABASE_USERNAME`, `DEFAULT_DATABASE_PASSWORD`, `RAILS_MAX_THREADS`
- **Redis**: `REDIS_URL`
- **SMTP**: `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`,
  `SMTP_DOMAIN`, `MAILER_FROM`
- **reCAPTCHA v3**: `RECAPTCHA_SITE_KEY`, `RECAPTCHA_SECRET_KEY`
- **Instagram Graph**: `INSTAGRAM_ACCESS_TOKEN`, `INSTAGRAM_BUSINESS_ACCOUNT_ID`
- **Facebook Page**: `FACEBOOK_PAGE_ID`, `FACEBOOK_PAGE_ACCESS_TOKEN`
- **X / Twitter v2**: `X_API_KEY`, `X_API_SECRET`, `X_BEARER_TOKEN`,
  `X_ACCESS_TOKEN`, `X_ACCESS_SECRET`
- **Operacional**: `DISABLE_SOCIAL_PUBLISHING=true` desliga publicação real
  (útil em dev sem credenciais)

## Sidekiq

Sidekiq roda via `bin/dev` em desenvolvimento e via role `job` no Kamal em
produção (`bundle exec sidekiq -C config/sidekiq.yml`). O painel web fica em
`/sidekiq`, protegido por autenticação de admin.

Filas: `critico` (jobs sociais), `default`, `mailers`, `baixa`. Cron periódico
em `config/sidekiq.yml`:

- `ExpirarTokensEdicaoJob` a cada 10 minutos.

## Banner em disco

Banners são gravados em `public/uploads/banners/YYYY/MM/{uuid}.{ext}` (sem
Active Storage). Validação 1:1, JPEG/PNG, ≤ 5 MB via `ValidadorBanner` antes
de gravar. Em produção, o volume `synaxis_koinonia_uploads:/rails/public/uploads`
preserva os arquivos entre deploys.

## Testes

```bash
bundle exec rspec                                  # suite completa
bundle exec rspec spec/services                    # só serviços
bundle exec rubocop                                # estilo
bundle exec brakeman --no-pager                    # segurança
bundle exec bundle-audit check --update            # CVEs em gems
```

CI: `.github/workflows/ci.yml` roda Brakeman, bundler-audit, RuboCop e RSpec
contra serviços `postgres:16` e `redis:7`.

## Deploy (Kamal)

`config/deploy.yml` define duas roles (`web` Puma, `job` Sidekiq) e dois
acessórios (`postgres:16`, `redis:7`). Volumes persistentes:

- `synaxis_koinonia_storage:/rails/storage`
- `synaxis_koinonia_uploads:/rails/public/uploads`

Secrets vão em `.kamal/secrets` referenciando ENV do shell do operador
(extraídos de password manager). Nenhuma credencial real é commitada.

```bash
bin/kamal setup     # primeira vez
bin/kamal deploy    # deploys subsequentes
```

## Estrutura

```
app/
  components/      # Phlex: layouts, comuns, formulários, eventos, validador, admin
  controllers/     # Devise + Publico, Submissoes, EdicoesToken, Validador, Admin
  jobs/            # Sidekiq jobs para publicação, atualização e expiração
  mailers/         # SubmissaoMailer, ValidacaoMailer, ConviteValidadorMailer
  models/          # Admin, Validador, Evento, ConviteValidador, PostagemSocial, RegistroAcao
  services/        # ArmazenadorBanner, CriarSubmissao, AprovarEvento, ReprovarEvento,
                   # ConvidarValidador, ExportadorCalendario, PublicadorSocial::*
  validators/      # ValidadorBanner
  views/           # Phlex view classes (Views::*)
config/
  routes.rb        # rotas em pt-BR
  database.yml     # PostgreSQL via DEFAULT_DATABASE_*
  sidekiq.yml      # filas + cron
  deploy.yml       # Kamal: web + job + accessories pg/redis
spec/              # RSpec
```

## Fluxos

1. **Submissão pública**: `/enviar` → reCAPTCHA + rate-limit → grava banner em
   disco → email com magic link (24h) se `email_submissor` informado.
2. **Edição via token**: `/eventos/editar/:token` permite editar/excluir
   enquanto evento está pendente.
3. **Validador**: fila em `/validador/eventos`, aprova ou reprova com motivo;
   reprovação envia email apenas se rejeitado + motivo + email informados.
4. **Admin**: `/admin` lista convites, validadores, registros e postagens;
   convida validador via email + token.
5. **Publicação social**: ao aprovar, fan-out para Instagram/Facebook/X via
   adapters; `PostagemSocial` registra `id_externo`/`url_externa`.
6. **Página pública**: `/` lista eventos aprovados futuros, ordenados por
   data, com filtro por cidade. `/eventos/:id/calendario.ics` exporta o
   evento como arquivo iCal.
