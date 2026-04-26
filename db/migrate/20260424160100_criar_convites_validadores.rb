class CriarConvitesValidadores < ActiveRecord::Migration[8.1]
  def change
    create_table :convites_validadores do |t|
      t.string     :email,      null: false
      t.string     :token,      null: false
      t.datetime   :expira_em,  null: false
      t.datetime   :aceito_em
      t.references :admin,      null: false, foreign_key: true
      t.datetime   :excluido_em

      t.timestamps
    end

    add_index :convites_validadores, :email
    add_index :convites_validadores, :token, unique: true
    add_index :convites_validadores, :excluido_em
  end
end
