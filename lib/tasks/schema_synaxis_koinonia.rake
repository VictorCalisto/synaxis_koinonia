# Garante que o schema sch_synaxis_koinonia exista antes de qualquer
# operação que dependa dele (migrate, schema:load, test:prepare).
namespace :db do
  namespace :synaxis do
    desc "Cria o schema sch_synaxis_koinonia se ainda não existir"
    task criar_schema: :load_config do
      ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).each do |config|
        next unless config.adapter == "postgresql"

        ActiveRecord::Base.establish_connection(config)
        begin
          ActiveRecord::Base.connection.execute("CREATE SCHEMA IF NOT EXISTS sch_synaxis_koinonia")
        rescue ActiveRecord::NoDatabaseError
          # Banco ainda não existe (primeira vez); db:create cuidará disso.
        end
      end
    end
  end
end

%w[db:migrate db:schema:load db:structure:load db:test:load_schema db:seed].each do |task_name|
  Rake::Task[task_name].enhance(["db:synaxis:criar_schema"]) if Rake::Task.task_defined?(task_name)
end

# Enhance de tasks lazy-loaded (schema:load_if_ruby / structure:load_if_sql)
Rake::Task.tasks.each do |t|
  next unless t.name.start_with?("db:")
  next if t.name == "db:synaxis:criar_schema"
end
