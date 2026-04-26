require "koala"

class PublicadorSocial::AdapterFacebook < PublicadorSocial::AdapterBase
  def initialize
    exigir_env!("FACEBOOK_PAGE_ID", "FACEBOOK_PAGE_ACCESS_TOKEN")
    @page_id = ENV.fetch("FACEBOOK_PAGE_ID")
    @graph = Koala::Facebook::API.new(ENV.fetch("FACEBOOK_PAGE_ACCESS_TOKEN"))
  end

  def publicar(evento)
    caminho_local = Rails.root.join("public", evento.caminho_banner).to_s
    resposta = @graph.put_picture(
      caminho_local,
      { message: legenda(evento) },
      @page_id
    )
    {
      id_externo: resposta.fetch("id"),
      url_externa: "https://facebook.com/#{resposta.fetch('id')}"
    }
  rescue Koala::Facebook::APIError => e
    raise PublicadorSocial::Erro, "Facebook: #{e.message}"
  end

  def atualizar(postagem, evento)
    @graph.put_object(postagem.id_externo, nil, message: legenda(evento))
    true
  rescue Koala::Facebook::APIError => e
    raise PublicadorSocial::Erro, "Facebook update: #{e.message}"
  end

  def excluir(postagem)
    @graph.delete_object(postagem.id_externo)
    true
  rescue Koala::Facebook::APIError => e
    raise PublicadorSocial::Erro, "Facebook delete: #{e.message}"
  end
end
