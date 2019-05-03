Rails.application.routes.draw do
  root 'main_page#index'
  post '/', to: 'main_page#create'
  devise_for :users
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
