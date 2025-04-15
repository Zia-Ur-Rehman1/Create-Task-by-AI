class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    flash[:alert] = params[:message]
  end
end
