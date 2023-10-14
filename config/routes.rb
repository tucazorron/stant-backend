Rails.application.routes.draw do
  post 'upload-file', to: 'talks#upload_file'
  get 'talks', to: 'talks#index'
end
