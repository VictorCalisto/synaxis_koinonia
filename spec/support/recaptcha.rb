# Desabilita verificação real de reCAPTCHA em testes.
RSpec.configure do |config|
  config.before(:each) do
    allow_any_instance_of(ActionController::Base).to receive(:verify_recaptcha).and_return(true)
  end
end
