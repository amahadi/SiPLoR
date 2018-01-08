class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_content_path
    end
  end
end
