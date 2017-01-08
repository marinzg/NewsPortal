Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'home/index'

  root 'home#index'

  get 'home/add'

  get 'home/byNoOfComments'
  
  post 'home/create'

  post 'home/comment'

  post 'home/wordsForAuthors'

  resources :article
end
