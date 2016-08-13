Rails.application.routes.draw do
  get '/hue', to: 'hue#index'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
