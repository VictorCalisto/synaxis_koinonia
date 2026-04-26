class Validadores::SessoesController < Devise::SessionsController
  def after_sign_in_path_for(_resource)
    validador_eventos_path
  end
end
