Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :<%= app_name.gsub(/^shift-/,'') %> do
    namespace :v1 do

      # Example routes
      ## Resource route
      # jsonapi_resources :resources, only: [ :index, :show ]
      ## Command route
      # resources :create_resource,  only: [ :create ], controller: 'commands', command: '::<%= app_name.gsub(/^shift-/,'').camelize %>::CreateResource'

    end
  end

  get "*all", to: "home#index", constraints: { format: /html/ }
  root to: "home#index", constraints: { format: /html/ }
end
