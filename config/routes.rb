Rails.application.routes.draw do
  root to: 'maps#index'
  post :receive, to: 'webhook#receive'
  get :receive, to: 'webhook#receive'
end
