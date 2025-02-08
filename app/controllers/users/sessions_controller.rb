# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  def guest_sign_in
    user = User.guest
    if user
      sign_in user
      redirect_to root_path, notice: "게스트 계정으로 로그인되었습니다."
    else
      redirect_to new_user_session_path, alert: "게스트 계정 생성에 실패했습니다."
    end
  end

  def destroy
    if current_user.guest?
      current_user.destroy 
      reset_session 
    end
    super 
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
