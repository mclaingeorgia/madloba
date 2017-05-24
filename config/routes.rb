Madloba::Application.routes.draw do


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

    get 'faq', to: 'root#faq'
    get 'contact', to: 'root#contact'
    get 'privacy_policy', to: 'root#privacy_policy'
    get 'terms_of_use', to: 'root#terms_of_use'
    get 'place/:id', to: 'root#place', as: 'place'


    namespace :manage, :module => :admin, :constraints => { format: :html } do
      get '/', to: '/admin#user_profile'
      get 'user/(:page)', to: '/admin#user_profile', :as => :user_profile
      get 'provider/:page/(:id)/(:edit)', to: '/admin#provider_profile', :as => :provider_profile, constraints: { id: /(new)|(\d+)/, edit: 'edit' }
      get 'admin', to: '/admin#admin_profile', :as => :admin_profile

      # scope 'admin' do
      # end
      # namespace :manage do
        resources :providers#, controller: 'providers'
        resources :places#, controller: '/admin'
        resources :users
        resources :page_contents
      # end
    end


    root 'root#index'
    get "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
  end

  get '', :to => redirect("/#{I18n.default_locale}") # handles /
  get '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
