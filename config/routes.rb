Madloba::Application.routes.draw do


  scope ':locale', locale: /#{I18n.available_locales.join("|")}/ do

    # devise_for :user, path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'new' }, controllers: { registrations: 'user/registrations'}
    #
    # Home page
    # as :user do
    #   get 'login', to: 'devise/sessions#new'
    # end
    # devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}
    devise_scope :user do
      get "/password_reset", to: "users/passwords#new", as: "new_user_password"
      get "/password_reset/edit", to: "users/passwords#edit", as: "edit_user_password"
    end
    devise_for :users, path: '', controllers: { sessions: 'users/sessions', passwords: 'users/passwords', confirmations: 'users/confirmations', registrations: 'users/registrations' }

    # get 'home/index'
    get 'about', to: 'root#about'
    get 'faq', to: 'root#faq'
    get 'contact', to: 'root#contact'
    get 'privacy_policy', to: 'root#privacy_policy'
    get 'terms_of_use', to: 'root#terms_of_use'
    get 'place/:id', to: 'root#place', as: 'place'

    # post 'search', to: 'home#render_search_results'
    # get 'results', to: 'home#results'
    # get 'refine_state', to: 'home#refine_state'

    # # About page
    # get 'about', to: 'home#about'

    # # FAQ page
    # get 'faq', to: 'home#faq'

    # # TOS page
    # get 'tos', to: 'home#tos'
    # post 'update_tos', to: 'home#update_tos'

    # Setup pages
    # get 'setup/language', to: 'setup#show_choose_language'
    # post 'setup/language/process', to: 'setup#process_chosen_language'
    # get 'setup', to: 'setup#show_welcome'
    # get 'setup/general', to: 'setup#show_general'
    # post 'setup/general/process', to: 'setup#process_general'
    # get 'setup/map', to: 'setup#show_map'
    # post 'setup/map/process', to: 'setup#process_map'
    # get 'setup/image', to: 'setup#show_image'
    # post 'setup/image/process', to: 'setup#process_image'
    # get 'setup/admin', to: 'setup#show_admin'
    # post 'setup/admin/process', to: 'setup#process_admin'
    # get 'setup/done', to: 'setup#show_finish'

    # Redirection to custom error screens
    match '/404' => 'errors#error404', via: [ :get, :post, :patch, :delete ]
    match '/500' => 'errors#error500', via: [ :get, :post, :patch, :delete ]


    resources :providers, :controller => 'admin/providers'
    post 'send_message', as: 'send_message', :controller => 'admin/providers'
    resources :places, :controller => 'admin/places'

    namespace :manage, :module => :admin, :constraints => { format: :html } do
      get '/', to: '/admin#index'
      get 'user/(:page)', to: '/admin#user_profile', :as => :user_profile
      get 'provider/:page/(:id)/(:edit)', to: '/admin#provider_profile', :as => :provider_profile, constraints: { id: /(new)|(\d+)/, edit: 'edit' }
      get 'admin', to: '/admin#admin_profile', :as => :admin_profile

      scope 'admin' do
        resources :page_contents


      end
      # get :categories, :to => "/admin#category", :as => :categories
      # resources :users do
      #   collection do
      #     get 'deffered'
      #   end
      # end
      # resources :datasets, only: [:index, :show, :new, :create, :destroy]
      # resources :donorsets, only: [:index, :show, :new, :create, :destroy]
      # resources :periods, only: [:index, :show, :new, :create, :edit, :update, :destroy]
      # resources :parties do
      #   collection do
      #     get 'bulk'
      #     post 'bulk_update'
      #   end
      # end
      # resources :media

    end


    # namespace :user do



      # resources :users
      # resources :locations, :categories, :items, :users, :faqs
      # resources :posts, :only => [:edit, :update, :destroy], path: :services, as: :services

      # get 'index', 'home', to: 'admin_panel#index'
      # get 'managerecords', to: 'admin_panel#managerecords'
      # get 'manageusers', to: 'admin_panel#manageusers'
      # get 'manageposts', to: 'admin_panel#manageposts'
      # get 'manageprofile', to: 'users#edit'
      # get 'generalsettings', to: 'admin_panel#general_settings'
      # get 'mapsettings', to: 'admin_panel#map_settings'
      # get 'areasettings', to: 'admin_panel#area_settings'
      # get 'favorite', to: 'admin_panel#favorite'

      # post 'mapsettings/update', to: 'admin_panel#update_map_settings'
      # post 'generalsettings/update', to: 'admin_panel#update_general_settings'
      # post 'areasettings/update', to: 'admin_panel#update_area_settings'

      # post 'favorite/add', to: 'admin_panel#add_favorite'
      # post 'favorite/remove', to: 'admin_panel#remove_favorite'
      # post 'areasettings/update_areas', to: 'admin_panel#update_areas'
      # post 'areasettings/update_area_name', to: 'admin_panel#update_area_name'
      # post 'areasettings/save_area', to: 'admin_panel#save_area'
      # post 'areasettings/delete_area', to: 'admin_panel#delete_area'

      # get 'getAreaSettings', to: 'admin_panel#getAreaSettings'
      # # get 'posts/:id/edit', to: 'posts#edit'

      # # This POST method is called when the deletion of a category is made through a form
      # post 'categories/:id', to: 'categories#destroy'
    # end

    # resources :posts, :only => [:show, :index, :new, :create], :controller => 'user/posts', path: :services, as: :services
    # post 'posts/send_message', to: 'user/posts#send_message'
    # get 'posts/goToService', to: 'user/posts#go_to_service'

    # # Ajax calls to get details about a location (geocodes, exact address)
    # get '/getNominatimLocationResponses', to: 'application#nominatim_location_responses'
    # get '/getCityGeocodes', to: 'user/locations#retrieve_geocodes'

    # # Ajax call to get the list of items, for autocomplete, when searching for an item, or creating/editing an post.
    # get '/getItems', to: 'application#get_items'

    # # Ajax call to show the posts related to 1 type of item and to 1 area/area.
    # get '/showSpecificAds', to: 'home#showSpecificPosts'

    # # To change languages.
    # get '/change_locale/:locale', to: 'settings#change_locale', as: :change_locale

    # # Ajax call to show popup content, when marker clicked on home page.
    # get '/showPostPopup', to: 'home#show_post_popup'
    # get '/showAreaPopup', to: 'home#show_area_popup'

    root 'root#index'
    get "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
  end

  get '', :to => redirect("/#{I18n.default_locale}") # handles /
  get '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
