class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_none_admin

  def index
    @user = current_user
    if @user.information.nil?
      @info = @user.create_information
    else
      @info = @user.information
    end
    @page_title = @user.username + '\'s Account'
  end

  def show
    @user = User.find(params[:id]);
    
    Friend.where(:userf_id => @user.id).each do |f|
      if User.find_by_id(f.usert_id).nil?
         f.destroy
      end
    end
    Friend.where(:usert_id => @user.id).each do |f|
      if User.find_by_id(f.userf_id).nil?
         f.destroy
      end
    end

    @info = @user.information
    if @user == current_user
      @yochats = @user.yochats.order('created_at DESC').page(params[:page]).per(10)
    else
      @yochats = @user.yochats.where(:share_with => 'public').order('created_at DESC').page(params[:page]).per(10)
    end
      @page_title = @user.username + '\'s Home'
  end

  def edit
    @user = current_user
    @info = @user.information
    @page_title = 'Edit Profile'
  end

  def update
    @user = current_user
    @info = @user.information
    if @info.update(info_params)
      redirect_to user_url(@user)
      flash[:notice] = 'Information was successfully updated!'
    else
      render :edit
      flash[:alert] = 'Information updated failed!'
    end
  end

  def show_messages
    @messages = current_user.messages.order('created_at DESC').page(params[:page]).per(10)
  end

  private
  def set_none_admin
    if current_user.is_admin
      redirect_to admin_users_url
    end
  end

  def info_params
    params.require(:information).permit(:gender, :location, :about, :birthday, :blog, :interest_ids => [])
  end


end
