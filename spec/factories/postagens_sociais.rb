FactoryBot.define do
  factory :postagem_social do
    association :evento
    plataforma    { :instagram }
    id_externo    { SecureRandom.hex(6) }
    url_externa   { "https://instagram.com/p/#{SecureRandom.hex(4)}" }
    publicado_em  { Time.current }
  end
end
