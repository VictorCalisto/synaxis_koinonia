class PublicadorSocial::AdapterBase
  def publicar(_evento)
    raise NotImplementedError
  end

  def atualizar(_postagem, _evento)
    raise NotImplementedError
  end

  def excluir(_postagem)
    raise NotImplementedError
  end

  protected

  def exigir_env!(*chaves)
    faltando = chaves.reject { |c| ENV[c].to_s.strip.present? }
    return if faltando.empty?

    raise PublicadorSocial::CredenciaisAusentesError,
          "Credenciais ausentes para #{self.class.name}: #{faltando.join(', ')}"
  end

  def legenda(evento)
    [
      evento.titulo,
      "",
      evento.descricao,
      "",
      "📅 #{I18n.l(evento.data_evento, format: :long)}",
      "📍 #{evento.local} · #{evento.cidade}",
      "🎟️ #{evento.valor}",
      "",
      evento.perfil_divulgacao
    ].compact.join("\n")
  end
end
