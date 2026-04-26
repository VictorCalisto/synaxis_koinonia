require "rails_helper"

RSpec.describe "Admin::ConvitesValidadores", type: :request do
  let(:admin) { create(:admin) }
  before { sign_in admin, scope: :admin }

  describe "POST /admin/convites_validadores" do
    it "cria convite" do
      expect {
        post admin_convites_validadores_path, params: { convite: { email: "novo@x.com" } }
      }.to change(ConviteValidador, :count).by(1)
    end
  end

  describe "DELETE /admin/convites_validadores/:id" do
    it "soft-deleta convite" do
      convite = ConviteValidador.create!(email: "x@y.com", admin: admin)
      delete admin_convite_validador_path(convite)
      expect(convite.reload.excluido?).to be(true)
    end
  end
end
