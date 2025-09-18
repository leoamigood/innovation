class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]

  # GET /posts or /posts.json
  def index
    @posts = default_authorized_scope.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = default_authorized_scope.find(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts or /posts.json
  def create
    handle_result(Posts::Create, post_params) do |post|
      respond_to do |format|
        format.html { redirect_to post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: post }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    handle_result(Posts::Destroy, default_authorized_scope.find(params[:id])) do
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end
  end

  private

  def on_failure_result(error)
    @post = Post.new
    @post.errors.add(:base, error)

    super(error)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.expect(post: [ :title, :body ])
  end
end
