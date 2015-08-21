class CommentsController < ApplicationController
  before_action :require_login

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to post_url(@comment.post)
    else
      flash[:errors] = @comment.errors.full_messages
      if @comment.parent_comment_id
        redirect_to comment_url(@comment.parent_comment_id)
      else
        redirect_to new_post_comment_url(@comment.post_id)
      end
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @new_comment = Comment.new
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :post_id, :author_id, :parent_comment_id)
  end
end
