DateIdeas::Application.routes.draw do
  resources :cart_items

  resources :datecarts do 
    # collection do
    #   put "complete"
    # end
    member do
      put "complete"
      get "email"
      get "print"
    end
  end
  
  # devise_for :admins

  # TODO: handle user abuse of application urls?
  
  match '/auth/:provider/callback' => 'authentications#create'

  # devise_for :users, :controllers => {:registrations => "registrations"}
  devise_for :users
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  # get "wizard/index"

  # get "home/index"

  # resources :wizard
  resources :wizard do
    collection do 
      get "search"
    end
  end
  
  #TODO: allow users to access their profiles using /profiles/:username?
  resources :profiles
  
  resources :authentications
  
  resources :relationships, :only => [:create, :destroy]
  
  resources :businesses
  
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "wizard#index"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end



  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
