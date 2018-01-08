class SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    redirect_to new_content_path
  end
end
