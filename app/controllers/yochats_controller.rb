class YochatsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user
  before_action :set_yochat, :only => [:show, :edit, :update, :destroy]

  def index
    @page_title = 'Yochats Plaza'
    @yochats = Yochat.where(:share_with => 'public').page(params[:page]).per(10)
  end

  def zone
    @page_title = 'Yochats Zone'
    @yochats = Array.new
    focus = Friend.where(:userf_id => @user.id).pluck(:usert_id)
    zone_yochat = Yochat.where(:share_with => 'zone')
    zone_yochat.each do |zy|
      if focus.include?(zy.user_id)
        @yochats.push(zy)
      end
    end
  end

  def circle
    @page_title = 'Yochats Circle'
    @yochats = Array.new
    friends = Array.new
    focus = Friend.where(:userf_id => @user).pluck(:usert_id)
    focus.each do |fid|
      if Friend.exists?(:userf_id => fid, :usert_id => @user.id)
        friends.push(fid)
      end
    end
    circle_yochat = Yochat.where(:share_with => 'circle')
    circle_yochat.each do |cy|
      if friends.include?(cy.user_id)
        @yochats.push(cy)
      end
    end
  end

  def private
    @page_title = 'Yochats for me'
    @yochats = @user.yochats.page(params[:page]).per(10)
  end

  def show
    @page_title = 'Yochat'
    @comments = @yochat.comments
  end

  def new
    @page_title = 'Create a Comment'
    @yochat = @user.yochats.build(:share_with => 'public')
  end

  def create
    @yochat = @user.yochats.build(yochat_params)
    if @yochat.save
      redirect_to yochats_path
      flash[:notice] = "Yochat was successfully created!"
    else
      render :new
      flash[:alert] = "Yochat created faild!"
    end
  end

  def edit
  end

  def update
    @page_title = 'Create a comment'
    if @yochat.update(yochat_modify)
      redirect_to yochat_path(@yochat)
      flash[:notice] = "Yochat was successfully updated!"
    else
      render :edit
      flash[:alert] = "Yochat updated faild!"
    end
  end

  def destroy
    @yochat.destroy
    redirect_to yochats_path
    flash[:notice] = "Yochat was successfully deleted!"
  end

  private
  def set_user
    @user = current_user
  end

  def set_yochat
    @yochat = Yochat.find(params[:id])
  end

  def yochat_params
    params.require(:yochat).permit(:content, :share_with)
  end

  def yochat_modify
    params.require(:yochat).permit(:share_with)
  end

end
