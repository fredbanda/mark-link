class UsersController < ApplicationController
  skip_authentication only: [ :new, :create ]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @organization = Organization.create(members: [ @user ])

      @pp_session = @user.app_sessions.create
      log_in(@pp_session)

      redirect_to root_path, status: :see_other

      flash[:success] = t("users.create.welcome", name: @user.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

private
def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end
end
