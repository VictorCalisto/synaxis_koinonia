class CriarEventos < ActiveRecord::Migration[8.1]
  def change
    create_table :eventos do |t|
      t.string   :titulo,             null: false
      t.string   :organizacao,        null: false
      t.datetime :data_evento,        null: false
      t.string   :local,              null: false
      t.string   :cidade,              null: false
      t.text     :descricao,          null: false
      t.string   :perfil_divulgacao,  null: false
      t.string   :contato_publico,    null: false
      t.string   :valor,              null: false, default: "Entrada Franca"

      t.string   :email_submissor
      t.string   :token_edicao
      t.datetime :token_expira_em

      t.integer  :situacao,           null: false, default: 0
      t.datetime :aprovado_em
      t.datetime :rejeitado_em
      t.text     :motivo_rejeicao

      t.string   :caminho_banner,     null: false

      t.datetime :excluido_em

      t.timestamps
    end

    add_index :eventos, :situacao
    add_index :eventos, :data_evento
    add_index :eventos, :cidade
    add_index :eventos, :token_edicao, unique: true
    add_index :eventos, :excluido_em
  end
end
