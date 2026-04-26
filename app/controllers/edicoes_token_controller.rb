class EdicoesTokenController < ApplicationController
  before_action :carregar_evento_por_token!

  def show
    render Views::EdicoesToken::Show.new(evento: @evento)
  end

  def update
    if @evento.update(parametros_evento)
      RegistroAcao.registrar!(
        acao: "submissor_editar",
        evento: @evento,
        ator_email: @evento.email_submissor
      )
      redirect_to edicao_token_path(@evento.token_edicao),
                  notice: "Alterações salvas."
    else
      render Views::EdicoesToken::Show.new(evento: @evento), status: :unprocessable_entity
    end
  end

  def destroy
    @evento.excluir_suavemente!
    @evento.limpar_token_edicao!
    RegistroAcao.registrar!(
      acao: "submissor_excluir",
      evento: @evento,
      ator_email: @evento.email_submissor
    )
    redirect_to nova_submissao_path, notice: "Evento removido."
  end

  private

  def carregar_evento_por_token!
    token = params[:token].to_s
    @evento = Evento.where(token_edicao: token).first

    return head(:not_found) if @evento.nil?
    return head(:gone)      unless @evento.token_valido?
  end

  def parametros_evento
    params.fetch(:evento, {}).permit(
      :titulo, :organizacao, :data_evento, :local, :cidade, :descricao,
      :perfil_divulgacao, :contato_publico, :valor
    )
  end
end
