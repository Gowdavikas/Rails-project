Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

    # Custom routes for news
    get '/top_headlines', to: 'news#top_headlines'
    get '/all_articles', to: 'news#all_articles'
    get '/sources', to: 'news#sources'

  # root "articles#index"
  get 'getquestion', to: 'questions#filtered_questions'
  post 'submitanswer', to: 'questions#submit_answers'

  get 'user', to: 'users#show'
   # SMS verification endpoint
   post 'users/sms_confirmation', to: 'accounts#sms_confirm'
   resources :profiles,:choices,:questions,:termsandconditions, :companies
  
  get 'get_roles', to: 'users#get_roles'

  resources :companies
  resources :jobs

   
end
