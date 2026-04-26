require "rails_helper"

RSpec.describe AprovarEvento do
  let(:validador) { create(:validador) }
  let(:evento) do
    e = create(:evento, :pendente, :com_email_submissor)
    e.gerar_token_edicao!
    e
  end

  it "aprova, limpa token e enfileira job de publicação" do
    resultado = described_class.call(evento: evento, validador: validador)
    expect(resultado).to be_sucesso
    evento.reload
    expect(evento.situacao).to eq("aprovado")
    expect(evento.aprovado_em).to be_present
    expect(evento.token_edicao).to be_nil
    expect(PublicarPostagensSociaisJob).to have_been_enqueued.with(evento.id)
  end

  it "registra RegistroAcao de aprovar" do
    expect { described_class.call(evento: evento, validador: validador) }
      .to change(RegistroAcao, :count).by(1)
    expect(RegistroAcao.last.acao).to eq("aprovar")
  end

  it "falha se evento já estava rejeitado" do
    evento.update!(situacao: :rejeitado, rejeitado_em: Time.current)
    resultado = described_class.call(evento: evento, validador: validador)
    expect(resultado).to be_falha
  end
end
