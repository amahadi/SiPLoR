Rails.application.routes.draw do
  root to: 'dashboards#show'

  devise_for :users,
             controllers: {
                 registrations: 'registrations',
                 sessions: 'sessions'
             }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :contents
end
