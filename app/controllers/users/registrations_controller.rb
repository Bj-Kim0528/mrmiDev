class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # 회원가입 후, 사용자가 아직 확인되지 않았으므로
  # after_inactive_sign_up_path_for를 재정의하여 인증번호 입력 페이지로 리다이렉트합니다.
  def after_inactive_sign_up_path_for(resource)
    confirm_email_path  # 아래에서 설정할 이메일 인증번호 입력 페이지의 라우트
  end

  # 추가 파라미터 허용 (이 예제에서는 회원가입 폼에 name만 추가되었으므로 별도의 추가는 필요없습니다)
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
