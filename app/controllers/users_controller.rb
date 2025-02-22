class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @organization = Organization.create(members: [@user])

      #TODO: LOGIN USER

      flash[:success] = t("users.create.welcome", name: @user.name)
      redirect_to root_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
  end
end

private 
def user_params
  params.require(:user).permit(:name, :email, :password)
  end
end
