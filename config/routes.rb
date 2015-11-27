Finance::Application.routes.draw do
  root to: 'all_transactions#index'

  devise_for :users
  devise_for :models
  resources :income_transactions
  resources :income_categories
  resources :future_payments
  resources :expense_transactions
  resources :expense_categories do
    collection do
      get 'show_sub_category/:id', action: :show_sub_category, as: 'show_sub_category'
      get 'hide_sub_category/:id', action: :hide_sub_category, as: 'hide_sub_category'
    end
  end
  resources :all_transactions
  resources :statistics
  resources :expense_divide_by_month, only: [:index]
  resources :graphics
  
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

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
