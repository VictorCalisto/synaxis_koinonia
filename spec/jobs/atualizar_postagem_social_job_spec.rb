require "rails_helper"

RSpec.describe AtualizarPostagemSocialJob, type: :job do
  let(:evento) { create(:evento, :aprovado) }
  let(:postagem) { create(:postagem_social, evento: evento) }
  let(:adapter_mock) do
    instance_double("Adapter", atualizar: true)
  end

  before do
    allow(PublicadorSocial).to receive(:adapter_para).and_return(adapter_mock)
  end

  it "chama adapter.atualizar com postagem e evento" do
    AtualizarPostagemSocialJob.perform_now(postagem.id)
    expect(adapter_mock).to have_received(:atualizar).with(postagem, evento)
  end
end
