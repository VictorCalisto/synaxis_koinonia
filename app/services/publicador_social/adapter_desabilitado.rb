# Usado quando DISABLE_SOCIAL_PUBLISHING=true. Simula respostas bem-sucedidas
# para permitir desenvolvimento/testes sem credenciais reais.
class PublicadorSocial::AdapterDesabilitado < PublicadorSocial::AdapterBase
  def initialize(plataforma)
    @plataforma = plataforma.to_s
  end

  def publicar(_evento)
    {
      id_externo: "desabilitado-#{SecureRandom.hex(6)}",
      url_externa: "https://exemplo.test/#{@plataforma}/#{SecureRandom.hex(3)}"
    }
  end

  def atualizar(_postagem, _evento)
    true
  end

  def excluir(_postagem)
    true
  end
end
