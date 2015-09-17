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
    @user = User.find(params[:id])
    @links = User.includes(:links).where('user_id = "ruby is awesome"')
    @links = current_user.links.most_recent if current_user.links
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
