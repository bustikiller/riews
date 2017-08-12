Riews::Engine.routes.draw do
  resources :views do
    resources :columns
    resources :filter_criterias, as: 'filters', path: 'filters'
  end
end
