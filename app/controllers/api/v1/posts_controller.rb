require 'json'

class Api::V1::PostsController < ApplicationController
  # GET /posts
  def index
    user_id = params[:user_id]
    if user_id.nil?
      render json: Post.all
      return
    end
    @posts = Post.all
    resp = []
    @user = User.find_by_id(user_id)
    @posts.each do |p| resp <<
      {
        'title' => p.title,
        'body' => p.body,
        'liked' => @user.likes.where(user_id: user_id, post_id: p.id).first.nil? == false,
        'likes_count' => p.likes_count,
        'publication_date' => p.created_at
      }
    end
    render json: resp
  end

  def show
    @post = Post.find_by_id(params[:id])
    if @post.nil?
      render :json => {:error => "not-found"}.to_json, status: :not_found
      return
    end
    render json: @post, status: :ok
  end

  # POST /posts/:post_id/like
  def like
    user = User.find_by_id(params[:user_id])
    if user.nil?
      render :json => {:error => "user %d not found" % params[:user_id]}.to_json, status: :bad_request
      return
    end

    like = user.likes.where(user_id: user.id, post_id: params[:post_id]).first
    if like.nil? == false
      render json: @post , status: :ok
      return
    end

    @post = Post.find_by_id(params[:post_id])
    user.likes.new(user_id: params[:user_id], post_id: params[:post_id])
    user.save
    @post.likes_count = @post.likes_count + 1
    @post.save

    render json: @post, status: :ok
  end

  # DELETE /posts/:post_id/like
  def dislike
    user = User.find_by_id(params[:user_id])
    if user.nil?
      render :json => {:error => "user %d not found" % params[:user_id]}.to_json, status: :bad_request
      return
    end

    like = user.likes.where(user_id: user.id, post_id: params[:post_id]).first
    if like.nil?
      render json: @post , status: :ok
      return
    end

    @post = Post.find_by_id(params[:post_id])
    like.destroy
    user.save
    @post.likes_count = @post.likes_count - 1
    @post.save

    render json: @post, status: :ok
  end
end
