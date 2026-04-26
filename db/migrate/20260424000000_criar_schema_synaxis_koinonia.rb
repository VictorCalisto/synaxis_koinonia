class CriarSchemaSynaxisKoinonia < ActiveRecord::Migration[8.1]
  def up
    execute "CREATE SCHEMA IF NOT EXISTS sch_synaxis_koinonia"
  end

  def down
    execute "DROP SCHEMA IF EXISTS sch_synaxis_koinonia CASCADE"
  end
end
