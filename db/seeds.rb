# Seed idempotente para criar o admin inicial a partir das variáveis de ambiente
# INITIAL_ADMIN_EMAIL e INITIAL_ADMIN_PASSWORD.

email = ENV["INITIAL_ADMIN_EMAIL"].to_s.strip
senha = ENV["INITIAL_ADMIN_PASSWORD"].to_s

if email.blank? || senha.blank?
  warn "[seed] INITIAL_ADMIN_EMAIL/PASSWORD não definidos — pulando criação de admin inicial."
else
  admin = Admin.find_or_initialize_by(email: email)
  admin.password = senha
  admin.password_confirmation = senha
  admin.save!
  puts "[seed] Admin '#{email}' pronto."
end
