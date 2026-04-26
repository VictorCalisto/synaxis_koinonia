require "mini_magick"

# Valida um ActionDispatch::Http::UploadedFile (ou Rack::Test::UploadedFile)
# antes de gravar em disco. Retorna Resultado (sucesso/falha + erros).
class ValidadorBanner
  TAMANHO_MAXIMO = 5.megabytes
  CONTENT_TYPES_PERMITIDOS = %w[image/jpeg image/jpg image/png].freeze
  EXTENSOES_PERMITIDAS = %w[.jpg .jpeg .png].freeze
  TOLERANCIA_RAZAO = 0.01

  def self.call(arquivo)
    new(arquivo).call
  end

  def initialize(arquivo)
    @arquivo = arquivo
    @erros = []
  end

  def call
    return Resultado.erro("Banner é obrigatório") if @arquivo.blank?

    validar_content_type
    validar_extensao
    validar_tamanho
    validar_proporcao if @erros.empty?

    @erros.empty? ? Resultado.ok : Resultado.erro(@erros)
  end

  private

  def validar_content_type
    return if CONTENT_TYPES_PERMITIDOS.include?(content_type)

    @erros << "Formato não permitido. Use JPG ou PNG."
  end

  def validar_extensao
    ext = File.extname(original_filename).downcase
    return if EXTENSOES_PERMITIDAS.include?(ext)

    @erros << "Extensão não permitida. Use .jpg, .jpeg ou .png."
  end

  def validar_tamanho
    return if @arquivo.size <= TAMANHO_MAXIMO

    @erros << "Arquivo excede o tamanho máximo de 5 MB."
  end

  def validar_proporcao
    imagem = MiniMagick::Image.open(@arquivo.path)
    razao = imagem.width.to_f / imagem.height
    return if (razao - 1.0).abs <= TOLERANCIA_RAZAO

    @erros << "Banner precisa ter proporção 1:1 (quadrado)."
  rescue MiniMagick::Invalid, MiniMagick::Error
    @erros << "Imagem inválida ou corrompida."
  ensure
    rewind_if_possible
  end

  def content_type
    @arquivo.try(:content_type).to_s.downcase
  end

  def original_filename
    @arquivo.try(:original_filename).to_s
  end

  def rewind_if_possible
    @arquivo.rewind if @arquivo.respond_to?(:rewind)
  end
end
