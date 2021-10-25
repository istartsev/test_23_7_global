require 'rails_helper'
require 'json'

describe 'Post API', type: :request do
  before :each do
    @user1 = FactoryBot.create(:user, username: 'testUser1', password: 'secret_pass')
    @user2 = FactoryBot.create(:user, username: 'testUser2', password: 'secret_pass')
    @user_deleted = FactoryBot.create(:user, username: 'testUser3', deleted_at: Time.now, password: 'secret_pass')

    @post1 = FactoryBot.create(:post, title: "My 1st post", body: "Body of 1st post", status: "public", user_id: @user1.id, likes_count: 0)
    @post2 = FactoryBot.create(:post, title: "My 2st post", body: "Body of 2st post", status: "public", user_id: @user1.id, likes_count: 0)
  end

  context 'common functionality' do
    it 'return all posts' do
      get '/api/v1/posts'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'return all posts for user with likes' do
      get '/api/v1/posts?user_id=%d' % [@user1.id]

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)

      post '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, @user1.id]

      get '/api/v1/posts?user_id=%d' % [@user1.id]

      expect(response).to have_http_status(:success)
      resp = JSON.parse(response.body)
      expect(resp.size).to eq(2)
      expect(resp.any? { |post| post['liked'] }).to eq(true)
      expect(resp.count { |post| post['liked'] }).to eq(1)
    end

    it 'get post' do
      get '/api/v1/posts/%d' % [@post1.id]

      expect(response).to have_http_status(:success)

      get '/api/v1/posts/9999'
      expect(response).to have_http_status(404)
    end

    it 'like and dislike posts' do
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

      # checking that another user can like a post if it's already liked by another
      post '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, @user1.id]

      expect(response).to have_http_status(:success)

      get '/api/v1/posts/%d' % [@post1.id]
      expect(response).to have_http_status(:success)
      res_json = JSON.parse(response.body)
      expect(res_json['likes_count']).to eq(2)

      # check dislikes
      delete '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, @user1.id]

      expect(response).to have_http_status(:success)

      get '/api/v1/posts/%d' % [@post1.id]
      expect(response).to have_http_status(:success)
      res_json = JSON.parse(response.body)
      expect(res_json['likes_count']).to eq(1)

      # check that a user cannot dislike what is not liked
      delete '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, @user1.id]

      expect(response).to have_http_status(:success)

      get '/api/v1/posts/%d' % [@post1.id]
      expect(response).to have_http_status(:success)
      res_json = JSON.parse(response.body)
      expect(res_json['likes_count']).to eq(1)
    end
  end

  context 'bad cases' do
    it 'should fail if the user doesn`t exist' do
      post '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, 9999]
      expect(response).to have_http_status(400)
    end

    it 'should fail if the user is deleted' do
      post '/api/v1/posts/%d/like?user_id=%d' % [@post1.id, @user_deleted.id]
      expect(response).to have_http_status(400)
    end
  end
end