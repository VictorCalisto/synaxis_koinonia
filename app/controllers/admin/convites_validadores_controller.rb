class Admin::ConvitesValidadoresController < Admin::BaseController
  def index
    @ativos = ConviteValidador.pendentes.order(created_at: :desc)
    render Views::Admin::ConvitesValidadores::Index.new(convites: @ativos)
  end

  def create
    resultado = ConvidarValidador.call(admin: current_admin, email: params.dig(:convite, :email))
    if resultado.sucesso?
      redirect_to admin_convites_validadores_path, notice: "Convite enviado."
    else
      redirect_to admin_convites_validadores_path, alert: resultado.mensagem_erros
    end
  end

  def destroy
    convite = ConviteValidador.find(params[:id])
    convite.excluir_suavemente!
    redirect_to admin_convites_validadores_path, notice: "Convite cancelado."
  end
end
