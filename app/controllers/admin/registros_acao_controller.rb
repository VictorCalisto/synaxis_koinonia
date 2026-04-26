class Admin::RegistrosAcaoController < Admin::BaseController
  def index
    escopo = RegistroAcao.com_excluidos.order(created_at: :desc)
    escopo = escopo.where(acao: params[:acao]) if params[:acao].present?
    escopo = escopo.where(tipo_ator: params[:tipo_ator]) if params[:tipo_ator].present?
    @registros = escopo.page(params[:page]).per(50)
    render Views::Admin::RegistrosAcao::Index.new(registros: @registros, filtros: params.permit(:acao, :tipo_ator))
  end
end
