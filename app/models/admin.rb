class Admin < ApplicationRecord
  include RemovivelSuavemente

  self.table_name = "admins"

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_many :convites_validadores, dependent: :restrict_with_error
end
