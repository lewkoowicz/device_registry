Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'csrf', to: 'csrf#show'
      resource :registration, only: [:create]
      resource :session, only: [:create, :destroy]

      resources :devices, only: [] do
        collection do
          post :assign
          post :unassign
        end
      end
    end
  end
end