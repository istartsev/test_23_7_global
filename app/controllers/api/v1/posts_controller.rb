require 'json'

class Api::V1::PostsController < ApplicationController

  before_action :check_current_user, only: [:like, :dislike]

  def current_user
    @current_user = User.not_deleted.find_by_id(params[:user_id])
  end

  def check_current_user
    unless current_user
      render :json => {:error => "user %d not found" % params[:user_id]}.to_json, status: :bad_request
    end
  end

  # GET /posts?user_id=<id>
  def index
    @posts = Post.not_deleted
    @liked_posts_ids = []
    if current_user
      @liked_posts_ids = current_user.likes.not_deleted.pluck(:post_id)
    end

    render json: @posts.map { |p| post_to_json(p)  }
  end

  # GET /posts/<id>
  def show
    @post = Post.all.find_by_id(params[:id])
    if @post.nil?
      render :json => {:error => "not-found"}.to_json, status: :not_found
      return
    end
    render json: @post, status: :ok
  end

  # POST /posts/:post_id/like?user_id=<id>
  def like

    @post = Post.not_deleted.find(params[:post_id])
    like = current_user.likes.find_by(post_id: @post.id)
    if like && like.deleted_at.blank?
      return render json: @post , status: :ok
    end

    ActiveRecord::Base.transaction do
      if like.blank?
        @post.likes.create!(user_id: current_user.id)
      else
        like.update!(deleted_at: nil)
      end

      @post.likes_count = @post.likes_count + 1
      @post.save!
    end
    render json: @post, status: :ok
  end

  # DELETE /posts/:post_id/like?user_id=<id>
  def dislike
    @post = Post.not_deleted.find_by_id(params[:post_id])

    like = current_user.likes.find_by(post_id: params[:post_id])
    if like.blank? || like.deleted_at.present?
      return render json: @post , status: :ok
    end

    ActiveRecord::Base.transaction do
      like.update!(deleted_at: Time.current)
      @post.likes_count = @post.likes_count - 1
      @post.save!
    end
    render json: @post, status: :ok
  end

  private

  def post_to_json(post)
    {
      'comment' => post.title,
      'body' => post.body,
      'owner' => post.user_id,
      'status' => post.status,
      'liked' => @liked_posts_ids.include?(post.id),
      'likes_count' => post.likes_count,
      'publication_date' => post.created_at,
      'deleted_at' => post.deleted_at
    }
  end
end
