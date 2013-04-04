NewsSite::Application.routes.draw do
  devise_for :users

  resources :messages
  root :to => 'messages#index'
  
  devise_scope :user do
    get "sign_in", :to => "devise/sessions#new"
  end
  
match 'message/upvote' => "messages#upvote"
match 'message/downvote' => "messages#downvote"
match 'my_messages' => "messages#my_messages"
end
