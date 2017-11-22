Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

  root to: "home#index"

  devise_for :users

  resources :auths

  get 'auth/sign_out' => 'auths#login_out'
  get 'auth/:id' => 'auths#show'

end
