class Validador < ApplicationRecord
  include RemovivelSuavemente

  self.table_name = "validadores"

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
end
