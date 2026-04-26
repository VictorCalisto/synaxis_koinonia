# Valor simples para serviços retornarem sucesso/falha sem exceções.
class Resultado
  attr_reader :valor, :erros

  def self.ok(valor = nil)
    new(sucesso: true, valor: valor, erros: [])
  end

  def self.erro(erros, valor: nil)
    mensagens = Array(erros)
    new(sucesso: false, valor: valor, erros: mensagens)
  end

  def initialize(sucesso:, valor:, erros:)
    @sucesso = sucesso
    @valor = valor
    @erros = erros
  end

  def sucesso?
    @sucesso
  end

  def falha?
    !@sucesso
  end

  def mensagem_erros
    @erros.join(", ")
  end
end
