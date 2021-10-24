Rails.application.routes.draw do

  get "/api/v1/posts", to:"api/v1/posts#index"
  post "/api/v1/posts/:post_id/like", to:"api/v1/posts#like"
  delete "/api/v1/posts/:post_id/like", to:"api/v1/posts#dislike"
end
