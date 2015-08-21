class PostsController < ApplicationController
  before_action :require_login, except: :show
  before_action :require_owner, only:[:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.sub_ids = sub_ids
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @associated_subs = @post.subs

  end

  def update
    # @post = Post.find(params[:id])
    if @post.update(post_params.merge(sub_ids: sub_ids))
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
    @subs = @post.subs
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_ids)
  end

  def sub_ids
    # post_params[:sub_ids].keys
    params[:post][:sub_ids].keys
  end

  def require_owner
    @post = Post.find(params[:id])
    unless @post.author == current_user
      flash[:notice] = "You do not have permission for this action."
      redirect_to sub_url(post.sub_id)
    end
  end
end
