require "x"

class PublicadorSocial::AdapterTwitter < PublicadorSocial::AdapterBase
  def initialize
    exigir_env!("X_API_KEY", "X_API_SECRET", "X_ACCESS_TOKEN", "X_ACCESS_SECRET")
    @cliente = X::Client.new(
      api_key: ENV.fetch("X_API_KEY"),
      api_key_secret: ENV.fetch("X_API_SECRET"),
      access_token: ENV.fetch("X_ACCESS_TOKEN"),
      access_token_secret: ENV.fetch("X_ACCESS_SECRET")
    )
  end

  def publicar(evento)
    midia_id = upload_midia(evento)
    resposta = @cliente.post("tweets", {
      text: texto_tweet(evento),
      media: { media_ids: [midia_id] }
    }.to_json)

    id = resposta.dig("data", "id")
    {
      id_externo: id,
      url_externa: "https://x.com/i/status/#{id}"
    }
  rescue StandardError => e
    raise PublicadorSocial::Erro, "Twitter: #{e.message}"
  end

  def atualizar(_postagem, _evento)
    raise PublicadorSocial::Erro, "X API v2 não suporta edição de tweets via endpoint público."
  end

  def excluir(postagem)
    @cliente.delete("tweets/#{postagem.id_externo}")
    true
  rescue StandardError => e
    raise PublicadorSocial::Erro, "Twitter delete: #{e.message}"
  end

  private

  def upload_midia(evento)
    caminho = Rails.root.join("public", evento.caminho_banner).to_s
    midia = @cliente.upload_media(file_path: caminho, media_category: "tweet_image")
    midia.fetch("media_id_string")
  end

  def texto_tweet(evento)
    partes = [
      evento.titulo,
      I18n.l(evento.data_evento, format: :short),
      "#{evento.cidade} · #{evento.local}",
      evento.perfil_divulgacao
    ]
    partes.join(" · ")[0, 260]
  end
end
