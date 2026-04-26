require "rails_helper"

RSpec.describe ConvidarValidador do
  let(:admin) { create(:admin) }

  it "cria convite e enfileira email" do
    resultado = described_class.call(admin: admin, email: "novo@x.com")
    expect(resultado).to be_sucesso
    expect(ConviteValidador.count).to eq(1)
    expect(enqueued_jobs.any? { |j| j[:args].first == "ConviteValidadorMailer" && j[:args].second == "convite" }).to be(true)
  end

  it "registra RegistroAcao de convidar_validador" do
    expect { described_class.call(admin: admin, email: "x@y.com") }
      .to change(RegistroAcao, :count).by(1)
    expect(RegistroAcao.last.acao).to eq("convidar_validador")
  end

  it "falha se já existe um validador com esse email" do
    create(:validador, email: "x@y.com")
    resultado = described_class.call(admin: admin, email: "x@y.com")
    expect(resultado).to be_falha
  end

  it "falha se já existe convite ativo" do
    described_class.call(admin: admin, email: "x@y.com")
    resultado = described_class.call(admin: admin, email: "x@y.com")
    expect(resultado).to be_falha
  end
end
