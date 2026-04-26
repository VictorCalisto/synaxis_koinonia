# Rate limiting para endpoints públicos sensíveis.

class Rack::Attack
  # Limita submissões anônimas a 5 por IP por hora.
  throttle("submissoes/ip", limit: 5, period: 1.hour) do |req|
    req.ip if req.post? && req.path == "/enviar"
  end

  # Limita tentativas de login em áreas autenticadas.
  throttle("logins/ip", limit: 10, period: 5.minutes) do |req|
    next unless req.post?
    next unless req.path.in?(%w[/validador/sign_in /admin/sign_in])

    req.ip
  end

  self.throttled_responder = lambda do |_req|
    [429, { "Content-Type" => "application/json" },
     [{ error: "Muitas requisições. Tente novamente em alguns minutos." }.to_json]]
  end
end

Rails.application.config.middleware.use Rack::Attack
