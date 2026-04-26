require "rails_helper"

RSpec.describe PublicarPostagensSociaisJob, type: :job do
  let(:evento) { create(:evento, :pendente) }

  it "enfileira PublicarNaPlataformaJob para cada plataforma" do
    expect {
      PublicarPostagensSociaisJob.perform_now(evento.id)
    }.to change(enqueued_jobs, :size).by(PostagemSocial.plataformas.size)

    plataformas = enqueued_jobs.map { |job| job[:args][1] }
    expect(plataformas.sort).to eq(PostagemSocial.plataformas.keys.sort)
  end
end
