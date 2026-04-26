class PostagemSocial < ApplicationRecord
  include RemovivelSuavemente

  self.table_name = "postagens_sociais"

  enum :plataforma, { instagram: 0, facebook: 1, twitter: 2 }

  belongs_to :evento

  validates :id_externo, :publicado_em, presence: true
end
