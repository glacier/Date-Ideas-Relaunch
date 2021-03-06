DateIdeas::Application.routes.draw do
  get "errors/404"

  get "errors/500"

  # devise_for :admins
  # resources :cart_items

  resources :datecarts do
    member do
      delete "clear_cart"
      get "begin_complete"
      put "complete"
      get "email"
      get "print"
      get "calendar"
      get "download_calendar"
      get "subscribe"
    end

    resources :cart_items do
      collection do
        post "create_event"
      end
    end
  end

  namespace :dashboard do
    resource :significant_dates
  end

  match '/auth/:provider/callback' => 'authentications#create'

  # devise_for :users, :controllers => {:registrations => "registrations"}
  devise_for :users, :controllers => {:sessions => "sessions", :registrations => "registrations"}


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
    get :autocomplete_neighbourhood_postal_code, :on => :collection
  end

  #TODO: allow users to access their profiles using /profiles/:username?
  resources :profiles

  resources :authentications

  resources :relationships, :only => [:create, :destroy]

  resources :businesses

  resources :neighbourhoods

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "wizard#index"

  match "dashboard/" => "dashboard#index"

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

  resources :data_farmers do
    collection do
      post "farm"
    end
  end
  #match "data_farmers/farm" => 'data_farmers#farm'
  match 'data_farmers/update_neighbourhood_select/:city', :controller=>'data_farmers', :action => 'update_neighbourhood_select'
  
  #route to 404 error
  match '*a', :to => 'errors#404'
  
end
