class DashboardsController < ApplicationController
  # before_action :authenticate_user!

  def show
    if user_signed_in?
      @user = current_user
    else
      redirect_to new_content_path
    end
  end
end
