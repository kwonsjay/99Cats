NinetyNineCats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests, :only => [:new, :create] do
    member do
      put :approve
      put :deny
    end
  end
  
  root :to => "/cats"
end
