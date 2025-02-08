class ConfirmationsController < ApplicationController
  # 인증번호 입력 폼을 보여주는 액션
  def new
    # 새 사용자에게 인증번호 입력 폼을 보여줍니다.
    # 현재 로그인 상태가 아니더라도, 회원가입 과정에서 생성된(미확인) 사용자 레코드가 있으므로,
    # 입력 폼만 보여줍니다.
  end

  # 사용자가 입력한 인증번호를 검증하는 액션
  def create
    token = params[:confirmation_token]
    # Devise의 confirm_by_token 메소드를 사용하여 사용자 계정을 확인합니다.
    user = User.confirm_by_token(token)
    if user.errors.empty?
      flash[:notice] = "이메일 인증이 완료되었습니다."
      sign_in(user)  # 사용자 자동 로그인
      redirect_to root_path
    else
      flash.now[:alert] = "인증번호가 올바르지 않습니다. 다시 입력해주세요."
      render :new
    end
  end
end
