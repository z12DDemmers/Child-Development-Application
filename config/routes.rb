Rails.application.routes.draw do  
	root 'assessment#home'
	get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
	get 'delete_answers' => 'assessment#delete_answers'

  resources :users do
    resources :children
  end
  
  resources :children do
    get 'assessment/gross_motor' => 'assessment#gross_motor', :as => :gross_motor
		get 'assessment/gross_motor_score' => 'assessment#gross_motor_score', :as => :gross_motor_score
		get 'assessment/cognitive' => 'assessment#cognitive', :as => :cognitive
		get 'assessment/cognitive_score' => 'assessment#cognitive_score', :as => :cognitive_score
		get 'assessment/receptive_language' => 'assessment#receptive_language', :as => :receptive_language
		get 'assessment/receptive_language_score' => 'assessment#receptive_language_score', :as => :receptive_language_score
		resources :answers, only: [:create, :update, :destroy]
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
