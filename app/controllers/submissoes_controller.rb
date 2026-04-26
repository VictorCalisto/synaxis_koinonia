class SubmissoesController < ApplicationController
  def new
    @evento = Evento.new
    render Views::Submissoes::New.new(evento: @evento)
  end

  def create
    unless verify_recaptcha(action: "submission")
      @evento = Evento.new(parametros_evento)
      flash.now[:alert] = t("synaxis.submissao.erro")
      return render(Views::Submissoes::New.new(evento: @evento), status: :unprocessable_entity)
    end

    resultado = CriarSubmissao.call(
      atributos: parametros_evento,
      banner: params[:banner],
      ip: request.remote_ip
    )

    if resultado.sucesso?
      chave = resultado.valor.email_submissor.present? ? "sucesso_com_email" : "sucesso"
      redirect_to nova_submissao_path, notice: t("synaxis.submissao.#{chave}")
    else
      @evento = resultado.valor || Evento.new(parametros_evento)
      flash.now[:alert] = "#{t('synaxis.submissao.erro')} #{resultado.mensagem_erros}"
      render Views::Submissoes::New.new(evento: @evento), status: :unprocessable_entity
    end
  end

  private

  def parametros_evento
    params.fetch(:evento, {}).permit(
      :titulo, :organizacao, :data_evento, :local, :cidade, :descricao,
      :perfil_divulgacao, :contato_publico, :valor, :email_submissor
    )
  end
end
