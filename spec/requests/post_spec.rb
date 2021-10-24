require 'rails_helper'

describe 'Post API', type: :request do
  before :each do
    @user1 = FactoryBot.create(:user, username: 'testUser1', active: true, password: 'secret_pass')
    @user2 = FactoryBot.create(:user, username: 'testUser2', active: true, password: 'secret_pass')

    @post1 = FactoryBot.create(:post, title: "My 1st post", body: "Body of 1st post", status: "public", user_id: @user1.id, likes_count: 0)
    @post2 = FactoryBot.create(:post, title: "My 2st post", body: "Body of 2st post", status: "public", user_id: @user1.id, likes_count: 0)
  end

  it 'return all posts' do
    get '/api/v1/posts'

    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body).size).to eq(2)
  end

  it 'like posts' do
    post '/api/v1/posts/1/like?user_id=2'

    expect(response).to have_http_status(:success)
  end

end