FactoryBot.define do
  factory :registro_acao do
    tipo_ator { "Sistema" }
    acao      { "aprovar" }
    detalhes  { {} }
  end
end
