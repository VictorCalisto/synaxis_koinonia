# Regras de pluralização para os termos de domínio em português.
# O Zeitwerk usa essas regras para mapear classes → arquivos.
# Todos os models também definem self.table_name explicitamente como rede
# de segurança contra pluralizações compostas.

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "validador",         "validadores"
  inflect.irregular "submissao",         "submissoes"
  inflect.irregular "sessao",            "sessoes"
  inflect.irregular "acao",              "acoes"
  inflect.irregular "edicao",            "edicoes"
  inflect.irregular "rejeicao",          "rejeicoes"
  inflect.irregular "postagem",          "postagens"
  inflect.irregular "convite",           "convites"
  inflect.irregular "convite_validador", "convites_validadores"
  inflect.irregular "registro_acao",     "registros_acao"
  inflect.irregular "postagem_social",   "postagens_sociais"
  inflect.irregular "edicao_token",      "edicoes_token"
end
