class RegistrationsController < Devise::RegistrationsController
  # GET /resource/sign_up
  def new
    redirect_to new_content_path
  end
end
