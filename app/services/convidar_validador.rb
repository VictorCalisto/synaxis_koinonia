class ConvidarValidador
  def self.call(admin:, email:)
    new(admin: admin, email: email).call
  end

  def initialize(admin:, email:)
    @admin = admin
    @email = email.to_s.strip.downcase
  end

  def call
    return Resultado.erro("Email inválido") if @email.blank?
    return Resultado.erro("Já existe um validador com esse email") if Validador.exists?(email: @email)
    return Resultado.erro("Já existe um convite ativo para esse email") if ConviteValidador.pendentes.exists?(email: @email)

    convite = ConviteValidador.create!(email: @email, admin: @admin)
    RegistroAcao.registrar!(
      acao: "convidar_validador",
      ator: @admin,
      detalhes: { email_convidado: @email }
    )
    ConviteValidadorMailer.convite(convite.id).deliver_later
    Resultado.ok(convite)
  rescue ActiveRecord::RecordInvalid => e
    Resultado.erro(e.record.errors.full_messages)
  end
end
