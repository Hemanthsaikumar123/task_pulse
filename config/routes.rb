Rails.application.routes.draw do
  get "comments/create"
  get "tasks/new"
  get "tasks/create"
  get "tasks/update"
  get "projects/new"
  get "projects/create"
  get "projects/show"
  get "teams/index"
  get "teams/new"
  get "teams/create"
  get "teams/show"
  get "dashboard/index"
  devise_for :users
  root "dashboard#index"
  resources :teams do
    post :add_member, on: :member
    delete 'remove_member/:user_id', to: 'teams#remove_member', on: :member, as: :remove_member
    resources :projects do
      resources :tasks do
        resources :comments, only: [:create, :destroy]
      end
    end
  end




end
