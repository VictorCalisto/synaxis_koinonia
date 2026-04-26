require "rails_helper"

RSpec.describe ExpirarTokensEdicaoJob, type: :job do
  it "limpa tokens expirados" do
    evento1 = create(:evento, :pendente, :com_token_edicao, token_expira_em: 1.hour.ago)
    evento2 = create(:evento, :pendente, :com_token_edicao, token_expira_em: 1.hour.from_now)

    ExpirarTokensEdicaoJob.perform_now

    expect(evento1.reload.token_edicao).to be_nil
    expect(evento2.reload.token_edicao).not_to be_nil
  end
end
