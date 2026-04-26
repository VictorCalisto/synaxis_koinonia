# Configuração do Sidekiq + sidekiq-cron.

redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }

  config.on(:startup) do
    schedule_file = Rails.root.join("config/sidekiq.yml")
    next unless schedule_file.exist?

    schedule = YAML.load_file(schedule_file, aliases: true)[:schedule]
    Sidekiq::Cron::Job.load_from_hash(schedule) if schedule
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
