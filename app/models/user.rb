class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :submissions, dependent: :destroy

  # Omniauth 콜백을 통해 사용자 정보를 처리하는 클래스 메소드
  def self.from_omniauth(access_token)
    data = access_token.info
    # provider와 uid로 사용자를 검색합니다.
    user = User.where(provider: access_token.provider, uid: access_token.uid).first
    unless user
      user = User.new(
        email: data['email'],
        password: Devise.friendly_token[0,20],
        provider: access_token.provider,
        uid: access_token.uid,
        name: data['name']
      )
      # Google OAuth를 통해 가입하는 경우에는 이메일 인증을 건너뛰어 자동으로 confirmed 상태로 만듭니다.
      if access_token.provider == "google_oauth2"
        user.skip_confirmation!
      end
      user.save!
    end
    user
  end

  def self.guest
    guest = find_or_initialize_by(email: 'guest@example.com')
    if guest.new_record?
      guest.password = SecureRandom.urlsafe_base64
      guest.name = "게스트 사용자"
      guest.skip_confirmation!
      guest.save!
    elsif !guest.confirmed?
      # 기존 계정이 존재하지만 아직 확인되지 않은 경우
      guest.skip_confirmation!
      guest.save!
    end
    guest
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "게스트 계정 생성 실패: #{e.message}"
    nil
  end

  def guest?
    email == "guest@example.com"
  end
end
