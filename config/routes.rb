Madloba::Application.routes.draw do


  get 'greetings/hello'

  scope ':locale', locale: /#{I18n.available_locales.join("|")}/ do

    devise_scope :user do
      get "/password_reset", to: "users/passwords#new", as: "new_user_password"
      get "/password_reset/edit", to: "users/passwords#edit", as: "edit_user_password"
    end
    devise_for :users, path: '', controllers: { sessions: 'users/sessions', passwords: 'users/passwords', confirmations: 'users/confirmations', registrations: 'users/registrations' }

    # Redirection to custom error screens
    match '/404' => 'errors#error404', via: [ :get, :post, :patch, :delete ]
    match '/500' => 'errors#error500', via: [ :get, :post, :patch, :delete ]


    post 'send_message', as: 'send_message', :controller => 'admin/providers'


    scope "/", controller: :root do
      get 'faq'
      get 'contact'
      get 'privacy_policy'
      get 'terms_of_use'
      get 'place/:id', to: 'root#place', as: 'place'
    end

    patch 'manage/provider/:id/restore', to: 'admin/providers#restore', as: :restore_manage_provider
    patch 'manage/provider/:id/assign/user/:user_id', to: 'admin/providers#assign_user', as: :manage_assign_user_to_provider
    patch 'manage/provider/:id/unassign/user/:user_id', to: 'admin/providers#unassign_user', as: :manage_unassign_user_from_provider
    patch 'manage/provider/:id/assign/place/:place_id', to: 'admin/providers#assign_place', as: :manage_assign_place_to_provider
    patch 'manage/provider/:id/unassign/place/:place_id', to: 'admin/providers#unassign_place', as: :manage_unassign_place_from_provider

    patch 'manage/place/:id/restore', to: 'admin/places#restore', as: :restore_manage_place

    patch 'manage/user/:id/restore', to: 'admin/users#restore', as: :restore_manage_user

    get 'manage/autocomplete/:type', to: 'admin#autocomplete', as: :manage_autocomplete

    namespace :manage, :module => :admin, :constraints => { format: :html } do
      get '/', to: '/admin#user_profile'
      get 'user/(:page)', to: '/admin#user_profile', :as => :user_profile
      get 'provider/:page/(:id)/(:edit)', to: '/admin#provider_profile', :as => :provider_profile, constraints: { id: /(new)|(\d+)/, edit: 'edit' }
      get 'admin', to: '/admin#admin_profile', :as => :admin_profile


      resources :providers, except: [:show]
      post 'provider/manage-providers/new', to: '/admin/providers#create', :as => :create_provider
      patch 'provider/manage-providers/:id', to: '/admin/providers#update', :as => :update_provider


      resources :places, except: [:show]
      post 'provider/manage-places/new', to: '/admin/places#create', :as => :create_place
      patch 'provider/manage-places/:id', to: '/admin/places#update', :as => :update_place

      put 'place/:id/favorite/:flag', to: '/admin/places#favorite', :as => :place_favorite, :constraints => { rate: /(true|false)/ }
      put 'place/:id/rate/:rate', to: '/admin/places#rate', :as => :place_rate, :constraints => { rate: /(0|1|2|3|4|5)/ }
      post 'place/:id/ownership', to: '/admin/places#ownership', :as => :place_ownership


      resources :users
      patch 'user/manage-profile', to: '/admin/users#update', :as => :update_user

      resources :page_contents, only: [:index, :edit, :update]
      resources :services, only: [:index, :edit, :update]

      resources :uploads, only: [:create]
      put 'moderate/upload_state/:id/:state', to: '/admin/uploads#upload_state_update', :as => :update_moderate_upload_state, :constraints => { state: /(accept|decline)/ }


      get 'moderate/place_report', to: '/admin/moderates#place_report', :as => :moderate_place_report
      put 'moderate/place_report/:id/:state', to: '/admin/moderates#place_report_update', :as => :update_moderate_place_report, :constraints => { state: /(accept|decline)/ }

      get 'moderate/place_ownership', to: '/admin/moderates#place_ownership', :as => :moderate_place_ownership
      put 'moderate/place_ownership/:id/:state', to: '/admin/moderates#place_ownership_update', :as => :update_moderate_place_ownership, :constraints => { state: /(accept|decline)/ }

      get 'moderate/new_provider', to: '/admin/moderates#new_provider', :as => :moderate_new_provider

      get 'moderate/place_tag', to: '/admin/moderates#place_tag', :as => :moderate_place_tag
      put 'moderate/place_tag/:id/:state', to: '/admin/moderates#place_tag_update', :as => :update_moderate_place_tag, :constraints => { state: /(accept|decline)/ }

    end


    root 'root#index'
    get "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
  end

  get '', :to => redirect("/#{I18n.default_locale}") # handles /
  get '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
