Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :rooms do 
  	member do
  		get :new_booking
  		post :create_booking
      get :edit_booking
      post :update_booking
      delete :destroy_booking
  	end

  	resources :fascilities
  end
  resources :holidays
  #get '/:id' => "shortener/shortened_urls#show"

  root to: "pages#index"
end
