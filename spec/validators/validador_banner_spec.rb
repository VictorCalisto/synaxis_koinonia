require "rails_helper"

RSpec.describe ValidadorBanner do
  it "aceita JPEG quadrado dentro do tamanho" do
    resultado = described_class.call(banner_upload(size: 600))
    expect(resultado).to be_sucesso
  end

  it "aceita PNG quadrado" do
    resultado = described_class.call(banner_upload(size: 400, ext: "png"))
    expect(resultado).to be_sucesso
  end

  it "rejeita arquivo ausente" do
    resultado = described_class.call(nil)
    expect(resultado).to be_falha
    expect(resultado.mensagem_erros).to include("obrigatório")
  end

  it "rejeita proporção não-quadrada" do
    path = Rails.root.join("tmp/retangulo_#{SecureRandom.hex(4)}.jpg")
    MiniMagick.convert do |cmd|
      cmd.size "800x400"
      cmd << "xc:red"
      cmd << path.to_s
    end
    arquivo = Rack::Test::UploadedFile.new(path, "image/jpeg")
    resultado = described_class.call(arquivo)
    expect(resultado).to be_falha
    expect(resultado.mensagem_erros).to include("1:1")
  end

  it "rejeita content-type não permitido" do
    path = Rails.root.join("tmp/fake_#{SecureRandom.hex(4)}.gif")
    File.binwrite(path, "GIF89a")
    arquivo = Rack::Test::UploadedFile.new(path, "image/gif")
    resultado = described_class.call(arquivo)
    expect(resultado).to be_falha
    expect(resultado.mensagem_erros).to match(/Formato não permitido|Extensão não permitida/)
  end
end
