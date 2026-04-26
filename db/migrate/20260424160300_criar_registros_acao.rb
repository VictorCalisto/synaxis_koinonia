class CriarRegistrosAcao < ActiveRecord::Migration[8.1]
  def change
    create_table :registros_acao do |t|
      t.string   :tipo_ator,    null: false
      t.bigint   :ator_id
      t.string   :ator_email
      t.bigint   :evento_id
      t.string   :acao,         null: false
      t.jsonb    :detalhes,     null: false, default: {}
      t.datetime :excluido_em

      t.timestamps
    end

    add_index :registros_acao, :evento_id
    add_index :registros_acao, [:tipo_ator, :ator_id]
    add_index :registros_acao, :acao
    add_index :registros_acao, :excluido_em
  end
end
