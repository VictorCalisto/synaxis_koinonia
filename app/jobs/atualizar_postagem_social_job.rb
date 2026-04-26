class AtualizarPostagemSocialJob < ApplicationJob
  queue_as :default
  retry_on PublicadorSocial::Erro, wait: :polynomially_longer, attempts: 5

  def perform(postagem_social_id)
    postagem = PostagemSocial.find(postagem_social_id)
    adapter = PublicadorSocial.adapter_para(postagem.plataforma.to_sym)
    adapter.atualizar(postagem, postagem.evento)
  end
end
