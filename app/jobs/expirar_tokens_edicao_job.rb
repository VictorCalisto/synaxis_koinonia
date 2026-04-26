class ExpirarTokensEdicaoJob < ApplicationJob
  queue_as :baixa

  def perform
    Evento.where("token_expira_em < ?", Time.current)
          .where.not(token_edicao: nil)
          .find_each do |evento|
      evento.limpar_token_edicao!
    end
  end
end
