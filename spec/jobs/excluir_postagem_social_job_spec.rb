require "rails_helper"

RSpec.describe ExcluirPostagemSocialJob, type: :job do
  let(:evento) { create(:evento) }
  let(:postagem) { create(:postagem_social, evento: evento) }
  let(:adapter_mock) do
    instance_double("Adapter", excluir: true)
  end

  before do
    allow(PublicadorSocial).to receive(:adapter_para).and_return(adapter_mock)
  end

  it "chama adapter.excluir e soft-deleta a postagem" do
    expect {
      ExcluirPostagemSocialJob.perform_now(postagem.id)
    }.to change { postagem.reload.excluido_em }.from(nil)

    expect(adapter_mock).to have_received(:excluir).with(postagem)
  end
end
