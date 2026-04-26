class Admins::SessoesController < Devise::SessionsController
  def after_sign_in_path_for(_resource)
    admin_root_path
  end
end
