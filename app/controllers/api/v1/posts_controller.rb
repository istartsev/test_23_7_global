class Api::V1::PostsController < ApplicationController

  # GET /posts
  def index
    render json: Post.all
  end

  # POST /posts/:post_id/like
  def like
    @post = Post.find(params[:post_id])
    if @post.likes.exists?([params[:user_id], params[:post_id]])
      render json: @post , status: :ok
    end

    @post.likes.new(user_id: params[:user_id], post_id: params[:post_id])
    @post.likes_count = @post.likes_count + 1

    render json: @post, status: :ok
  end

  # DELETE /posts/:post_id/like
  def dislike
    @post = Post.find(params[:post_id])
    if @post.likes.exists?([params[:user_id], params[:post_id]]) == false
      render json: @post, status: :ok
    end

    @post.likes.destroy(user_id: params[:user_id], post_id: params[:post_id])
    @post.likes_count = @post.likes_count - 1

    render json: @post, status: :ok
  end
end
