class Admin::PainelController < Admin::BaseController
  def show
    @resumo = {
      pendentes: Evento.com_excluidos.where(situacao: Evento.situacoes[:pendente]).count,
      aprovados: Evento.com_excluidos.where(situacao: Evento.situacoes[:aprovado]).count,
      validadores: Validador.count,
      convites_pendentes: ConviteValidador.pendentes.count
    }
    render Views::Admin::Painel::Show.new(resumo: @resumo)
  end
end
