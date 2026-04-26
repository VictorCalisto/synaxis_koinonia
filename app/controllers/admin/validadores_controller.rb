class Admin::ValidadoresController < Admin::BaseController
  def index
    @validadores = Validador.order(:email).page(params[:page]).per(25)
    render Views::Admin::Validadores::Index.new(validadores: @validadores)
  end

  def destroy
    validador = Validador.find(params[:id])
    validador.excluir_suavemente!
    RegistroAcao.registrar!(
      acao: "remover_validador",
      ator: current_admin,
      detalhes: { validador_email: validador.email }
    )
    redirect_to admin_validadores_path, notice: "Validador removido."
  end
end
