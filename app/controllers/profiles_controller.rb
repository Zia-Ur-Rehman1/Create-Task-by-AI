class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:view]

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(update_params)

    redirect_to profile_path, notice: 'Updated!'
  end

  def view
    @user = User.find_by!(uuid: params[:uuid], published: true)
  rescue ActiveRecord::RecordNotFound => e
    redirect_to root_path(message: 'Profile not found!')
  end

  private

  def update_params
    params.require(:user).permit(:portfolio_url, :published)
  end
end
