class Admin::PostagensSociaisController < Admin::BaseController
  before_action :carregar_evento
  before_action :carregar_postagem, only: [:update, :destroy]

  def index
    @postagens = PostagemSocial.where(evento_id: @evento.id).order(:plataforma)
    render Views::Admin::PostagensSociais::Index.new(evento: @evento, postagens: @postagens)
  end

  def update
    AtualizarPostagemSocialJob.perform_later(@postagem.id)
    redirect_to admin_evento_postagens_sociais_path(@evento),
                notice: "Atualização enfileirada."
  end

  def destroy
    ExcluirPostagemSocialJob.perform_later(@postagem.id)
    redirect_to admin_evento_postagens_sociais_path(@evento),
                notice: "Remoção enfileirada."
  end

  private

  def carregar_evento
    @evento = Evento.com_excluidos.find(params[:evento_id])
  end

  def carregar_postagem
    @postagem = PostagemSocial.find(params[:id])
  end
end
