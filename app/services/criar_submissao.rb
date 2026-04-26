# Cria um Evento a partir dos dados da submissão pública. Fluxo:
# 1. Valida e grava o banner em disco (ArmazenadorBanner).
# 2. Atribui campos do evento.
# 3. Gera token de edição + magic link se email_submissor for fornecido.
# 4. Registra RegistroAcao.
class CriarSubmissao
  PARAMETROS_PERMITIDOS = %w[
    titulo organizacao data_evento local cidade descricao
    perfil_divulgacao contato_publico valor email_submissor
  ].freeze

  def self.call(atributos:, banner:, ip: nil)
    new(atributos: atributos, banner: banner, ip: ip).call
  end

  def initialize(atributos:, banner:, ip: nil)
    @atributos = atributos.to_h.with_indifferent_access.slice(*PARAMETROS_PERMITIDOS)
    @banner = banner
    @ip = ip
  end

  def call
    resultado_banner = ArmazenadorBanner.call(@banner)
    return Resultado.erro(resultado_banner.erros) if resultado_banner.falha?

    evento = Evento.new(@atributos)
    evento.caminho_banner = resultado_banner.valor
    evento.situacao = :pendente

    Evento.transaction do
      evento.save!
      evento.gerar_token_edicao! if evento.email_submissor.present?
      registrar(evento)
    end

    SubmissaoMailer.link_magico(evento.id).deliver_later if evento.email_submissor.present?

    Resultado.ok(evento)
  rescue ActiveRecord::RecordInvalid => e
    Resultado.erro(e.record.errors.full_messages, valor: e.record)
  end

  private

  def registrar(evento)
    RegistroAcao.registrar!(
      acao: "submissor_criar",
      evento: evento,
      ator_email: evento.email_submissor,
      detalhes: { ip: @ip }
    )
  end
end
