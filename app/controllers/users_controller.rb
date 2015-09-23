class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome #{user_params[:name]} !"
      redirect_to user_path(@user)
    else
      flash.now[:error] = "One or more required fields are missing"
      render "new"
    end
  end

  def show
    @user = User.find(params[:id]) if logged_in?
    if logged_in? && @user == current_user 
      @date_joined = @user.created_at.strftime('%d/%m/%Y')
      sort
    else
      redirect_to root_path
    end
  end

  def sort
  @user = User.includes(:links).where(:id => params[:id]).first
    if params["key"] == "2"
      @links = @user.links.popularity.all
      respond_to do |format|
        format.js
      end
    else 
      @links = @user.links.most_recent if current_user.links
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end


