Copycopter::Application.routes.draw do
  namespace :api do
    namespace :v2 do
      resources :projects, :only => [] do
        resources :draft_blurbs, :only => [:create, :index]
        resources :published_blurbs, :only => [:index]
        resources :deploys, :only => [:create]
      end
    end
  end

  resource :dashboard, :only => [:show]

  resources :projects do
    resources :blurbs, :only => [:destroy]
    resources :locales, :only => [:new]
  end

  resources :localizations, :only => [] do
    resources :versions, :only => [:new, :create]
  end

  resource :home, :only => [:show]

  root :to => 'homes#show'
end
