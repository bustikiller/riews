Riews::Engine.routes.draw do
  resources :views do
    resources :columns
  end
end
