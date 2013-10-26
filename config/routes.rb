AppName.constantize::Application.routes.draw do

root 'users#show'

  get 'notifications/index'
  get 'notifications/get_new_notifications'

  post 'followings/:followee_id', to: 'followings#create', as: 'followings'
  delete 'followings/:followee_id', to: 'followings#destroy', as: 'following'

  resources :posts
  resources :notifications, only: [:index]

  resources :users do
    get 'show_followees' , on: :member
    get 'show_followers' , on: :member
    get 'autocomplete', on: :collection
  end
  
  resources :company
  resources :groups 
  resources :group_membership
  resources :likes
  resources :comments


  devise_for :user, controllers: {
    omniauth_callbacks: "controller_devise/omniauth_callback", 
    registrations: "controller_devise/registrations",
    sessions: "controller_devise/sessions"
  }


  get ':name/:controller/:id' => 'controller#show', constraints: { name: /\w+/ }
  get ':name/:controller/' => 'controller#index', constraints: { name: /\w+/ }
  get ':name/:controller/:id/:action' => 'controller#action', constraints: { name: /\w+/ }
  get ':name' => 'users#show'



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
