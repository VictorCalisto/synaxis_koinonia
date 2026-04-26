require_relative "boot"

# Carrega railties explicitamente — Active Storage é omitido porque o app
# persiste o banner diretamente em public/uploads/ (caminho relativo no DB).
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module SynaxisKoinonia
  class Application < Rails::Application
    config.load_defaults 8.1

    config.autoload_lib(ignore: %w[assets tasks])

    # Domínio em português brasileiro.
    config.time_zone = "Brasilia"
    config.i18n.default_locale = :"pt-BR"
    config.i18n.available_locales = [:"pt-BR", :en]

    # Preserva o schema PostgreSQL customizado (sch_synaxis_koinonia) nos dumps.
    config.active_record.schema_format = :sql
    # Dumpa apenas o schema sch_synaxis_koinonia (omite o "public" para não
    # recriar um schema que o PostgreSQL já cria automaticamente).
    config.active_record.dump_schemas = "sch_synaxis_koinonia"
    # Mantém as tabelas internas do Rails dentro do nosso schema.
    config.active_record.schema_migrations_table_name = "sch_synaxis_koinonia.schema_migrations"
    config.active_record.internal_metadata_table_name = "sch_synaxis_koinonia.ar_internal_metadata"

  end
end
