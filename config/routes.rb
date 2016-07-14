Rails.application.routes.draw do
  root 'welcome#index'

  resources :users do
    post 'mini-update', to: 'users#mini_update'
    get 'change-password', to: 'users#change_password'
    post 'change-password', to: 'users#process_change_password'
    get 'change-notifications', to: 'users#change_notifications'
    post 'change-notifications', to: 'users#process_change_notifications',
      as: 'process_change_notifications'
  end

  get '/sign', to: 'welcome#sign'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  post '/forgot', to: 'users#process_forgot_password'

  post '/check', to: 'users#check_unique'
  get '/verify/:verification', to: 'users#verify', as: :verify
  get 'reset-password/:verification', to: 'users#reset_password', as: 'reset_password'
  post 'reset-password/:verification', to: 'users#process_reset_password', as: 'process_reset_password'

  resources :contests do
    get 'admin', to: 'contests#admin'
    get 'rules', to: 'contests#show_rules'
    post 'rules', to: 'contests#accept_rules'
    get 'feedback', to: 'contests#give_feedback'
    post 'feedback', to: 'contests#feedback_submit'
    get 'download', to: 'contests#download_feedback'

    resources :short_problems, path: '/short-problems'
    post 'create-short-submissions', to: 'contests#create_short_submissions'
    resources :long_problems, path: '/long-problems'

    resources :feedback_questions, path: '/feedback-questions'

    post 'give-points', to: 'contests#give_points'
  end

  #resources :market_items, path: '/market-items'

  get '/mark-solo/:id', to: 'long_problems#mark_solo', as: :mark_solo
  get '/mark-final/:id', to: 'long_problems#mark_final', as: :mark_final

  get '/home', to: 'home#index'
  get '/faq', to: 'home#faq'
  get '/book', to: 'home#book'
  get '/donate', to: 'home#donate'
  get '/about', to: 'home#about'
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  get '/contact', to: 'home#contact'
  get '/penguasa', to: 'home#admin', as: :admin

  resources :long_submissions, path: '/long-submissions' do
    post 'submit' => 'long_submissions#submit', on: :member
  end

  get '/assign/:id', to: 'contests#assign_markers', as: :assign_markers
  post 'create-marker', to: 'roles#create_marker'
  delete 'remove-marker', to: 'roles#remove_marker'
end
