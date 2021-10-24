require 'rails_helper'
require 'json'

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

  it 'get post' do
    get '/api/v1/posts/%d' % [@post1.id]

    expect(response).to have_http_status(:success)

    get '/api/v1/posts/9999'
    expect(response).to have_http_status(404)
  end

  it 'like posts' do
    post '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, @user2.id]

    expect(response).to have_http_status(:success)

    get '/api/v1/posts/%d' % [@post1.id]
    expect(response).to have_http_status(:success)
    res_json = JSON.parse(response.body)
    expect(res_json['likes_count']).to eq(1)

    # checking that same user cannot like twice
    post '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, @user2.id]

    get '/api/v1/posts/%d' % [@post1.id]
    expect(response).to have_http_status(:success)
    res_json = JSON.parse(response.body)
    expect(res_json['likes_count']).to eq(1)

    # checking that can line a post if it's already liked by another
    post '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, @user1.id]

    expect(response).to have_http_status(:success)

    get '/api/v1/posts/%d' % [@post1.id]
    expect(response).to have_http_status(:success)
    res_json = JSON.parse(response.body)
    expect(res_json['likes_count']).to eq(2)
  end

end