class CriarPostagensSociais < ActiveRecord::Migration[8.1]
  def change
    create_table :postagens_sociais do |t|
      t.references :evento,        null: false, foreign_key: true
      t.integer    :plataforma,    null: false
      t.string     :id_externo,    null: false
      t.string     :url_externa
      t.datetime   :publicado_em,  null: false
      t.datetime   :excluido_em

      t.timestamps
    end

    add_index :postagens_sociais, [:evento_id, :plataforma]
    add_index :postagens_sociais, :excluido_em
  end
end
