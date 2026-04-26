class ConvitesValidadoresController < ApplicationController
  before_action :carregar_convite!

  def show
    render Views::ConvitesValidadores::Show.new(convite: @convite)
  end

  def accept
    senha = params.require(:convite).permit(:senha, :senha_confirmacao)

    if senha[:senha].blank? || senha[:senha] != senha[:senha_confirmacao]
      flash.now[:alert] = "As senhas não conferem."
      return render(Views::ConvitesValidadores::Show.new(convite: @convite), status: :unprocessable_entity)
    end

    begin
      @convite.aceitar!(senha: senha[:senha])
      redirect_to new_validador_session_path, notice: "Conta criada. Faça login para começar."
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.record.errors.full_messages.to_sentence
      render Views::ConvitesValidadores::Show.new(convite: @convite), status: :unprocessable_entity
    end
  end

  private

  def carregar_convite!
    @convite = ConviteValidador.where(token: params[:token]).first
    return head(:not_found) if @convite.nil?
    return head(:gone) unless @convite.valido_para_aceitacao?
  end
end
