class Validador::PerfilController < ApplicationController
  before_action :authenticate_validador!

  def destroy
    email = current_validador.email
    current_validador.excluir_suavemente!
    RegistroAcao.registrar!(acao: "auto_excluir", ator_email: email)
    sign_out(:validador)
    redirect_to new_validador_session_path, notice: "Sua conta foi removida."
  end
end
