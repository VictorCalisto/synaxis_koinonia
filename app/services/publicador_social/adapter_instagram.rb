require "koala"

class PublicadorSocial::AdapterInstagram < PublicadorSocial::AdapterBase
  def initialize
    exigir_env!("INSTAGRAM_ACCESS_TOKEN", "INSTAGRAM_BUSINESS_ACCOUNT_ID")
    @ig_id = ENV.fetch("INSTAGRAM_BUSINESS_ACCOUNT_ID")
    @graph = Koala::Facebook::API.new(ENV.fetch("INSTAGRAM_ACCESS_TOKEN"))
  end

  # https://developers.facebook.com/docs/instagram-api/guides/content-publishing
  def publicar(evento)
    container = @graph.put_connections(
      @ig_id, "media",
      image_url: evento.url_publica_banner,
      caption: legenda(evento)
    )
    publish = @graph.put_connections(@ig_id, "media_publish", creation_id: container["id"])
    {
      id_externo: publish.fetch("id"),
      url_externa: buscar_permalink(publish.fetch("id"))
    }
  rescue Koala::Facebook::APIError => e
    raise PublicadorSocial::Erro, "Instagram: #{e.message}"
  end

  def atualizar(postagem, evento)
    # Instagram Graph API não permite editar caption de post existente; o fluxo
    # documentado é excluir + republicar. Para evitar duplicação acidental,
    # apenas registramos o intento aqui e deixamos o operador decidir.
    raise PublicadorSocial::Erro, "Instagram não permite editar legenda via API. Use excluir + republicar."
  end

  def excluir(postagem)
    @graph.delete_object(postagem.id_externo)
    true
  rescue Koala::Facebook::APIError => e
    raise PublicadorSocial::Erro, "Instagram delete: #{e.message}"
  end

  private

  def buscar_permalink(midia_id)
    @graph.get_object(midia_id, fields: "permalink")["permalink"]
  rescue Koala::Facebook::APIError
    nil
  end
end
