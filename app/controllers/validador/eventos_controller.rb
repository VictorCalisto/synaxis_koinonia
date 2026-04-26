class Validador::EventosController < ApplicationController
  before_action :authenticate_validador!
  before_action :carregar_evento, only: [:show, :edit, :update, :aprovar, :reprovar]

  def index
    @situacao_filtro = params.fetch(:situacao, "pendente")
    escopo = Evento.com_excluidos.where(situacao: Evento.situacoes[@situacao_filtro])
    escopo = escopo.proximos_dias(params[:proximos_dias].to_i) if params[:proximos_dias].present?
    @eventos = escopo.ordenados_fila.limit(200)
    render Views::Validador::Eventos::Index.new(eventos: @eventos, situacao: @situacao_filtro)
  end

  def show
    render Views::Validador::Eventos::Show.new(evento: @evento)
  end

  def edit
    render Views::Validador::Eventos::Edit.new(evento: @evento)
  end

  def update
    if @evento.update(parametros_evento)
      RegistroAcao.registrar!(acao: "editar", evento: @evento, ator: current_validador)
      enfileirar_atualizacoes_sociais if @evento.aprovado?
      redirect_to validador_evento_path(@evento), notice: "Evento atualizado."
    else
      render Views::Validador::Eventos::Edit.new(evento: @evento), status: :unprocessable_entity
    end
  end

  def aprovar
    resultado = AprovarEvento.call(evento: @evento, validador: current_validador)
    if resultado.sucesso?
      redirect_to validador_eventos_path, notice: "Evento aprovado e na fila de publicação."
    else
      redirect_to validador_evento_path(@evento), alert: resultado.mensagem_erros
    end
  end

  def reprovar
    resultado = ReprovarEvento.call(
      evento: @evento,
      validador: current_validador,
      motivo: params[:motivo_rejeicao]
    )
    if resultado.sucesso?
      redirect_to validador_eventos_path, notice: "Evento reprovado."
    else
      redirect_to validador_evento_path(@evento), alert: resultado.mensagem_erros
    end
  end

  private

  def carregar_evento
    @evento = Evento.com_excluidos.find(params[:id])
  end

  def parametros_evento
    params.fetch(:evento, {}).permit(
      :titulo, :organizacao, :data_evento, :local, :cidade, :descricao,
      :perfil_divulgacao, :contato_publico, :valor
    )
  end

  def enfileirar_atualizacoes_sociais
    PostagemSocial.where(evento_id: @evento.id).find_each do |p|
      AtualizarPostagemSocialJob.perform_later(p.id)
    end
  end
end
