class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # omniauth.auth 정보는 request.env["omniauth.auth"]에 담겨 있습니다.
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      # 성공적으로 인증된 경우, 로그인하고 리디렉션
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      # 저장에 실패한 경우, 세션에 데이터 저장 후 회원가입 페이지로 이동
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  # 다른 프로바이더(예: Facebook 등)를 사용하는 경우 유사하게 메소드를 추가합니다.
  
  def failure
    redirect_to root_path
  end
end