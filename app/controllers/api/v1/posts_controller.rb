class Api::V1::PostsController < ApplicationController

  # GET /posts
  def index
    render json: Post.all
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
    @post = Post.find(params[:post_id])
    if @post.likes.where(user_id: params[:user_id], post_id: params[:post_id]).empty? == false
      render json: @post , status: :ok
      return
    end

    @post.likes.new(user_id: params[:user_id], post_id: params[:post_id])
    @post.likes_count = @post.likes_count + 1
    @post.save

    render json: @post, status: :ok
  end

  # DELETE /posts/:post_id/like
  def dislike
    @post = Post.find(params[:post_id])
    if @post.likes.where(user_id: params[:user_id], post_id: params[:post_id]).empty?
      render json: @post, status: :ok
    end

    @post.likes.destroy(user_id: params[:user_id], post_id: params[:post_id])
    @post.likes_count = @post.likes_count - 1
    @post.save

    render json: @post, status: :ok
  end
end
