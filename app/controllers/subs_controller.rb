class SubsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :require_moderator, only:[:edit, :update]

  def index
    @subs = Sub.all
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = current_user.subs.build(sub_params)
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    # @sub = Sub.find(params[:id])
  end

  def update
    # @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def show
    @sub = Sub.find(params[:id])
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def require_moderator
    @sub = Sub.find(params[:id])
    unless @sub.moderator == current_user
      flash[:notice] = "You don't have permission for that sub."
      redirect_to subs_url
    end
  end

end
