# CR_Priyank: Revisit routes
#[Fixed] - Removed Duplicate routes

AppName.constantize::Application.routes.draw do

root 'users#wall',  defaults: { id: '1' }

#[To Do] :  Add namespace 
match 'api/fetch_posts', to: 'api#fetch_posts', via: [:get,:post]

scope '/:company' do
  # CR_Priyank: No controller for companies
  # [Fixed] - Removed route for company
  # CR_Priyank: when we made these routes when we already have resources for them
  # [Fixed] - Reduced Duplicacy

  post 'followings/:followee_id', to: 'followings#create', as: 'followings'
  delete 'followings/:followee_id', to: 'followings#destroy', as: 'following'

  resources :posts, only: [:create, :destroy, :show] do
    get 'extract_url_content', on: :collection
    get 'hash_tags', on: :collection
  end

  resources :notifications, only: [:index] do
    get 'get_new_notifications', on: :collection
  end

  resources :users, only: [:edit, :update, :show, :destroy] do
    # CR_Priyank: routes should be like followers/followees
    #[Fixed] - Done so
    get 'followees' , on: :member
    get 'followers' , on: :member
    get 'wall', on: :member
    get 'autocomplete', on: :collection
    get 'tag_list',on: :collection
    get 'twitter_auth', on: :collection
    get 'api_token', on: :member
  end
  
  resources :groups
  resources :group_membership, only: [:create, :destroy, :index] do
    get 'pending_memberships', on: :collection
    post 'approve_membership', on: :member
  end
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]


  namespace :site_admin do
    
    resource :users, only: [:show] do
      post 'manage_users'
    end

    resource :groups, only: [:show] do
      post 'manage_groups'
    end

    resource :companies, only: [:show] do
      post 'manage_companies'
    end
    
  end

end


  devise_for :user, controllers: {
    omniauth_callbacks: "controller_devise/omniauth_callback", 
    registrations: "controller_devise/registrations",
    sessions: "controller_devise/sessions"
  }

  get '/:controller/:action/(:id)', to: redirect('/company/%{controller}/%{action}')

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # get ':name/:controller/:id' => 'controller#show', constraints: { name: /\w+/ }
  # get ':name/:controller/' => 'controller#index', constraints: { name: /\w+/ }
  # get ':name/:controller/:id/:action' => 'controller#action', constraints: { name: /\w+/ }
  # get ':name' => 'users#show'

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
