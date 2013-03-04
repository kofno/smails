Golpher::Application.routes.draw do

  resources :queues do
    member do
      delete :clear
    end
  end

end
