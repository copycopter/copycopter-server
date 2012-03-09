Copycopter::Application.routes.draw do
  namespace :api do
    namespace :v2 do
      resources :projects, :only => [] do
        resources :deploys, :only => [:create]
        resources :draft_blurbs, :only => [:create, :index]
        resources :published_blurbs, :only => [:index]
      end
    end
  end

  resources :projects do
    resources :blurbs, :only => [:destroy]
    resources :locales, :only => [:new]
  end

  resources :localizations, :only => [] do
    resources :versions, :only => [:new, :create]
  end

  root :to => 'projects#index'
end
