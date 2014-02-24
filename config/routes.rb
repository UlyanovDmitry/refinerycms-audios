Refinery::Core::Engine.routes.draw do

  # Frontend routes
  #namespace :audios do
  #  resources :audios, :path => '', :only => [:index, :show]
  #end

  # Admin routes
  namespace :audios, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :audios, :except => :show do
        get :download
        collection do
          post :update_positions
          get :insert
          get :audio_to_html
          post :audio_to_html
        end
      end
    end
  end

end
