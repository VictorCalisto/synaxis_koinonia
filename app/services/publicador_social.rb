# Fachada para os adapters de redes sociais. Cada adapter expõe:
#   publicar(evento)   -> { id_externo:, url_externa: }
#   atualizar(postagem, evento) -> true/false
#   excluir(postagem)  -> true/false
module PublicadorSocial
  class Erro < StandardError; end
  class CredenciaisAusentesError < Erro; end

  ADAPTERS = {
    instagram: -> { AdapterInstagram.new },
    facebook:  -> { AdapterFacebook.new },
    twitter:   -> { AdapterTwitter.new }
  }.freeze

  def self.adapter_para(plataforma)
    if desabilitado?
      AdapterDesabilitado.new(plataforma)
    else
      (ADAPTERS[plataforma.to_sym] || raise(Erro, "Plataforma desconhecida: #{plataforma}")).call
    end
  end

  def self.desabilitado?
    ENV["DISABLE_SOCIAL_PUBLISHING"].to_s.casecmp?("true")
  end
end
