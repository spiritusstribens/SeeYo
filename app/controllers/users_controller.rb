class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    if @user.information.nil? && !@user.is_admin?
      @info = @user.create_information
    else
      @info = @user.information
    end
    @page_title = @user.username + '\'s Account'
  end

  def show
    @user = User.find(params[:id]);
    @info = @user.information
    if @user == current_user
      @yochats = @user.yochats.page(params[:page]).per(10)
    else
      @yochats = @user.yochats.where(:share_with => 'public').page(params[:page]).per(10)
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

  private
  def info_params
    params.require(:information).permit(:gender, :location, :about, :birthday, :blog, :interest_ids => [])
  end


end
