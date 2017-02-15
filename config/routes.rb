Madloba::Application.routes.draw do


  scope ':locale', locale: /#{I18n.available_locales.join("|")}/ do

    devise_for :user, path: 'user', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'new' }, controllers: { registrations: 'user/registrations'}
    # Home page

    get 'home/index'
    post 'search', to: 'home#render_search_results'
    get 'results', to: 'home#results'
    get 'refine_state', to: 'home#refine_state'

    # About page
    get 'about', to: 'home#about'

    # FAQ page
    get 'faq', to: 'home#faq'

    # TOS page
    get 'tos', to: 'home#tos'
    post 'update_tos', to: 'home#update_tos'

    # Setup pages
    get 'setup/language', to: 'setup#show_choose_language'
    post 'setup/language/process', to: 'setup#process_chosen_language'
    get 'setup', to: 'setup#show_welcome'
    get 'setup/general', to: 'setup#show_general'
    post 'setup/general/process', to: 'setup#process_general'
    get 'setup/map', to: 'setup#show_map'
    post 'setup/map/process', to: 'setup#process_map'
    get 'setup/image', to: 'setup#show_image'
    post 'setup/image/process', to: 'setup#process_image'
    get 'setup/admin', to: 'setup#show_admin'
    post 'setup/admin/process', to: 'setup#process_admin'
    get 'setup/done', to: 'setup#show_finish'

    # Redirection to custom error screens
    match '/404' => 'errors#error404', via: [ :get, :post, :patch, :delete ]
    match '/500' => 'errors#error500', via: [ :get, :post, :patch, :delete ]

    namespace :user do
      get '/', to: 'admin_panel#index'

      resources :locations, :categories, :items, :users, :faqs
      resources :posts, :only => [:edit, :update, :destroy], path: :services, as: :services

      get 'index', 'home', to: 'admin_panel#index'
      get 'managerecords', to: 'admin_panel#managerecords'
      get 'manageusers', to: 'admin_panel#manageusers'
      get 'manageposts', to: 'admin_panel#manageposts'
      get 'manageprofile', to: 'users#edit'
      get 'generalsettings', to: 'admin_panel#general_settings'
      get 'mapsettings', to: 'admin_panel#map_settings'
      get 'areasettings', to: 'admin_panel#area_settings'
      get 'favorite', to: 'admin_panel#favorite'

      post 'mapsettings/update', to: 'admin_panel#update_map_settings'
      post 'generalsettings/update', to: 'admin_panel#update_general_settings'
      post 'areasettings/update', to: 'admin_panel#update_area_settings'

      post 'favorite/add', to: 'admin_panel#add_favorite'
      post 'favorite/remove', to: 'admin_panel#remove_favorite'
      post 'areasettings/update_areas', to: 'admin_panel#update_areas'
      post 'areasettings/update_area_name', to: 'admin_panel#update_area_name'
      post 'areasettings/save_area', to: 'admin_panel#save_area'
      post 'areasettings/delete_area', to: 'admin_panel#delete_area'

      get 'getAreaSettings', to: 'admin_panel#getAreaSettings'
      # get 'posts/:id/edit', to: 'posts#edit'

      # This POST method is called when the deletion of a category is made through a form
      post 'categories/:id', to: 'categories#destroy'
    end

    resources :posts, :only => [:show, :index, :new, :create], :controller => 'user/posts', path: :services, as: :services
    post 'posts/send_message', to: 'user/posts#send_message'
    get 'posts/goToService', to: 'user/posts#go_to_service'

    # Ajax calls to get details about a location (geocodes, exact address)
    get '/getNominatimLocationResponses', to: 'application#nominatim_location_responses'
    get '/getCityGeocodes', to: 'user/locations#retrieve_geocodes'

    # Ajax call to get the list of items, for autocomplete, when searching for an item, or creating/editing an post.
    get '/getItems', to: 'application#get_items'

    # Ajax call to show the posts related to 1 type of item and to 1 area/area.
    get '/showSpecificPosts', to: 'home#showSpecificPosts'

    # To change languages.
    # get '/change_locale/:locale', to: 'settings#change_locale', as: :change_locale

    # Ajax call to show popup content, when marker clicked on home page.
    get '/showPostPopup', to: 'home#show_post_popup'
    get '/showAreaPopup', to: 'home#show_area_popup'

    root 'home#index'
    get "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
  end

  get '', :to => redirect("/#{I18n.default_locale}") # handles /
  get '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
