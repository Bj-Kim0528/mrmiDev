class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Omniauth 콜백을 통해 사용자 정보를 처리하는 클래스 메소드
  def self.from_omniauth(access_token)
    data = access_token.info
    # provider와 uid를 저장할 컬럼이 필요합니다.
    # 예를 들어, provider: string, uid: string 컬럼을 추가합니다.
    user = User.where(provider: access_token.provider, uid: access_token.uid).first

    # 사용자가 없으면 새로 생성
    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0,20],
        provider: access_token.provider,
        uid: access_token.uid,
        # 추가 정보가 있다면 여기에 저장
        name: data['name']  # 예: 사용자 이름
      )
    end
    user
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "게스트 사용자" # name 필드가 있다면 기본값 추가
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "게스트 계정 생성 실패: #{e.message}"
    nil
  end

  def guest?
    email == "guest@example.com"
  end
end
