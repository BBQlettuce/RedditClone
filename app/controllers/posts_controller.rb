class PostsController < ApplicationController
  before_action :require_login, except: :show
  before_action :require_owner, only:[:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    # @post = Post.find(params[:id])
  end

  def update
    # @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def destroy
    # @post = Post.find(params[:id])
    if @post.destroy
      redirect_to sub_url(@post.sub_id)
    else
      flash.now[:errors] = @post.errors.full_messages
      redirect_to post_url(@post)
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end

  def require_owner
    @post = Post.find(params[:id])
    unless @post.author == current_user
      flash[:notice] = "You do not have permission for this action."
      redirect_to sub_url(post.sub_id)
    end
  end
end
