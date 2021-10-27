require 'json'

class Api::V1::PostsController < ApplicationController

  before_action :check_current_user, only: [:like, :dislike]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {}, status: 404
  end

  def current_user
    @current_user ||= User.not_deleted.find_by_id(params[:user_id])
  end

  def current_post
    @post ||= Post.not_deleted.find(params[:post_id])
  end

  def check_current_user
    unless current_user
      render json: {error: "user %d not found" % params[:user_id]}.to_json, status: :bad_request
    end
  end

  PAGE_SIZE = 50
  # GET /posts?offset=<int> where offset is the last post id which
  def index
    @posts = Post.not_deleted.limit(PAGE_SIZE).reverse
    if params[:offset].present?
      @posts.where(:post_id < params[:offset])
    end
    render json: @posts
  end

  # GET /posts/<id>
  def show
    render json: current_post, status: :ok
  end

  # POST /posts/:post_id/like?user_id=<id>
  def like
    current_post.likes.create(user_id: current_user.id)
  rescue ActiveRecord::RecordNotUnique => e
    logger.info e
  ensure
    render json: current_post, status: :ok
  end

  # DELETE /posts/:post_id/like?user_id=<id>
  def dislike
    current_post.likes.find_by(user_id: current_user.id)&.destroy
    render json: current_post, status: :ok
  end

  # GET /posts/:post_id/like?user_id=<id>
  def is_liked
    like = current_post.likes.find_by(user_id: current_user.id)
    render json: like.present?, status: :ok
  end
end
