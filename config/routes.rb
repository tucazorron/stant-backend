Rails.application.routes.draw do
  get 'talks', to: 'talks#index'
  post 'talks', to: 'talks#create'
  get 'talks/:id', to: 'talks#show'
  put 'talks/:id', to: 'talks#update'
  delete 'talks/:id', to: 'talks#destroy'
  delete 'talks', to: 'talks#destroy_all'
  post 'upload-file', to: 'talks#upload_file'
  get 'schedule', to: 'talks#schedule'
end
