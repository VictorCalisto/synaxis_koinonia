FactoryBot.define do
  factory :evento do
    sequence(:titulo)           { |n| "Evento #{n}" }
    organizacao                 { "Igreja Teste" }
    data_evento                 { 7.days.from_now }
    local                       { "Rua Tal, 123" }
    cidade                      { "São Paulo" }
    descricao                   { "Descrição completa do evento" }
    perfil_divulgacao           { "@igreja_teste" }
    contato_publico             { "contato@igreja.test" }
    valor                       { "Entrada Franca" }
    caminho_banner              { "uploads/banners/2026/04/teste.jpg" }

    trait :pendente  do situacao { :pendente } end
    trait :aprovado  do situacao { :aprovado }; aprovado_em { Time.current } end
    trait :rejeitado do situacao { :rejeitado }; rejeitado_em { Time.current } end

    trait :com_email_submissor do
      sequence(:email_submissor) { |n| "submissor#{n}@test.local" }
    end

    trait :com_token_edicao do
      token_edicao { SecureRandom.urlsafe_base64(48) }
      token_expira_em { 24.hours.from_now }
    end
  end
end
