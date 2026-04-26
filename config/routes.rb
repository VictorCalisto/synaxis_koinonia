require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  # Devise
  devise_for :validadores,
             path: "validador",
             controllers: { sessions: "validadores/sessoes" }
  devise_for :admins,
             path: "admin",
             controllers: { sessions: "admins/sessoes" }

  # Raiz e eventos públicos
  root "publico/eventos#index"

  scope module: "publico" do
    resources :eventos, only: [:index, :show] do
      member { get :calendario }
    end
  end

  # Submissão anônima
  get  "enviar", to: "submissoes#new",    as: :nova_submissao
  post "enviar", to: "submissoes#create", as: :submissoes

  # Edição via magic link
  scope "eventos/editar/:token", as: :edicao_token do
    get    "", to: "edicoes_token#show"
    patch  "", to: "edicoes_token#update"
    put    "", to: "edicoes_token#update"
    delete "", to: "edicoes_token#destroy"
  end

  # Aceitação de convite (público via token)
  get   "validador/aceitar-convite/:token", to: "convites_validadores#show",   as: :aceitar_convite
  patch "validador/aceitar-convite/:token", to: "convites_validadores#accept", as: :confirmar_convite

  # Área do validador
  namespace :validador do
    root "eventos#index"
    resources :eventos, only: [:index, :show, :edit, :update] do
      member do
        post :aprovar
        post :reprovar
      end
    end
    delete "eu", to: "perfil#destroy", as: :auto_exclusao
  end

  # Área admin
  namespace :admin do
    root "painel#show"
    resource  :painel, only: [:show], controller: "painel"
    resources :convites_validadores, only: [:index, :create, :destroy]
    resources :validadores,          only: [:index, :destroy]
    resources :registros_acao,       only: [:index]
    resources :eventos, only: [] do
      resources :postagens_sociais, only: [:index, :update, :destroy]
    end
  end

  # Sidekiq Web atrás da autenticação de admin
  authenticate :admin do
    mount Sidekiq::Web => "/sidekiq"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
