NinetyNineCats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests, :only => [:new, :create] do
    member do
      put :approve
      put :deny
    end
  end

  resources :users, :only => [:new, :create]
  resource :session, :only => [:new, :create, :destroy]

  # root :to => "cats#index"
end
