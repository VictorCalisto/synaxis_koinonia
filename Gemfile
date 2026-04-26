source "https://rubygems.org"

# Rails core
gem "rails", "~> 8.1.3"
gem "propshaft"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false

# Banco de dados
gem "pg", "~> 1.5"

# Fila de jobs e cache
gem "sidekiq", "~> 7.3"
gem "sidekiq-cron", "~> 1.12"
gem "redis", ">= 5.0"

# Autenticação
gem "devise", "~> 4.9"

# Views / UI
gem "phlex-rails", "~> 2.1"
gem "tailwindcss-rails", "~> 4.0"

# Seguranças e anti-spam
gem "rack-attack", "~> 6.7"
gem "recaptcha", "~> 5.17"

# Integração com redes sociais
gem "koala", "~> 3.6"
gem "x", "~> 0.15"

# Upload de banner e processamento de imagem
gem "mini_magick", "~> 5.1"

# Exportação iCal
gem "icalendar", "~> 2.10"

# Paginação
gem "kaminari", "~> 1.2"

# Variáveis de ambiente
gem "dotenv-rails", "~> 3.1", groups: %i[development test]

# Deploy
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Testes
  gem "rspec-rails", "~> 7.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.5"
  gem "shoulda-matchers", "~> 6.4"

  # Qualidade / segurança
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubycritic", require: false
end

group :development do
  gem "web-console"
  gem "letter_opener", "~> 1.10"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "webmock", "~> 3.24"
  gem "vcr", "~> 6.3"
end
