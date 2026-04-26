require "rails_helper"

RSpec.describe CriarSubmissao do
  let(:banner) { banner_upload(size: 500) }
  let(:atributos) do
    {
      titulo: "Retiro Jovem",
      organizacao: "Paróquia X",
      data_evento: 10.days.from_now,
      local: "Rua A, 100",
      cidade: "São Paulo",
      descricao: "Encontro de espiritualidade",
      perfil_divulgacao: "@paroquia_x",
      contato_publico: "contato@p.x",
      valor: "Entrada Franca"
    }
  end

  it "cria evento pendente sem token quando não há email_submissor" do
    resultado = described_class.call(atributos: atributos, banner: banner)

    expect(resultado).to be_sucesso
    evento = resultado.valor
    expect(evento).to be_persisted
    expect(evento.situacao).to eq("pendente")
    expect(evento.token_edicao).to be_nil
    expect(evento.caminho_banner).to start_with("uploads/banners/")
  end

  it "gera token e agenda email quando email_submissor presente" do
    resultado = described_class.call(
      atributos: atributos.merge(email_submissor: "eu@ex.com"),
      banner: banner
    )

    evento = resultado.valor
    expect(resultado).to be_sucesso
    expect(evento.token_edicao).to be_present
    expect(evento.token_expira_em).to be_within(5.seconds).of(24.hours.from_now)
    expect(enqueued_jobs.map { _1[:job] }).to include(ActionMailer::MailDeliveryJob)
  end

  it "registra RegistroAcao de submissor_criar" do
    expect {
      described_class.call(atributos: atributos, banner: banner)
    }.to change(RegistroAcao, :count).by(1)

    log = RegistroAcao.last
    expect(log.acao).to eq("submissor_criar")
    expect(log.tipo_ator).to eq("Submissor")
  end

  it "falha quando banner inválido" do
    resultado = described_class.call(atributos: atributos, banner: nil)
    expect(resultado).to be_falha
  end

  it "grava arquivo em public/uploads/banners" do
    resultado = described_class.call(atributos: atributos, banner: banner)
    caminho = Rails.root.join("public", resultado.valor.caminho_banner)
    expect(File.exist?(caminho)).to be(true)
  ensure
    File.delete(caminho) if caminho && File.exist?(caminho)
  end
end
