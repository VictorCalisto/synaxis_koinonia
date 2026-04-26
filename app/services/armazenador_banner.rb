require "fileutils"

# Grava um banner validado em public/uploads/banners/YYYY/MM/{uuid}.{ext}
# e retorna o caminho relativo (para persistir no campo caminho_banner).
class ArmazenadorBanner
  DIRETORIO_RAIZ = "uploads/banners".freeze

  def self.call(arquivo)
    new(arquivo).call
  end

  def initialize(arquivo)
    @arquivo = arquivo
  end

  def call
    validacao = ValidadorBanner.call(@arquivo)
    return validacao if validacao.falha?

    caminho_relativo = gerar_caminho_relativo
    gravar(caminho_relativo)
    Resultado.ok(caminho_relativo)
  end

  private

  def gerar_caminho_relativo
    agora = Time.current
    nome = "#{SecureRandom.uuid}#{extensao}"
    File.join(DIRETORIO_RAIZ, agora.year.to_s, format("%02d", agora.month), nome)
  end

  def extensao
    ext = File.extname(@arquivo.original_filename).downcase
    ext = ".jpg" if ext == ".jpeg"
    ext
  end

  def gravar(caminho_relativo)
    caminho_absoluto = Rails.root.join("public", caminho_relativo)
    FileUtils.mkdir_p(File.dirname(caminho_absoluto))

    @arquivo.rewind if @arquivo.respond_to?(:rewind)
    File.binwrite(caminho_absoluto, @arquivo.read)
  end
end
