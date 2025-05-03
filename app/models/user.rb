class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :submissions, dependent: :destroy

  has_many :conversation_memberships, dependent: :destroy
  has_many :conversations, through: :conversation_memberships

  def self.from_omniauth(access_token)
    data = access_token.info
    provider = access_token.provider
    uid = access_token.uid

    # 먼저 provider와 uid로 기존 사용자를 찾습니다.
    user = User.where(provider: provider, uid: uid).first

    if user
      # 이미 가입된 사용자가 있다면 그대로 반환
      user
    else
      # 만약 없으면, 이메일로 사용자를 찾아봅니다.
      user = User.find_by(email: data['email'])
      if user
        # 기존 계정이 있으나 provider, uid가 기록되지 않은 경우, 업데이트
        user.update(provider: provider, uid: uid)
        user
      else
        # 신규 사용자 객체를 초기화만 하고, 저장은 회원가입 폼에서 진행
        User.new(
          email: data['email'],
          password: Devise.friendly_token[0,20],
          provider: provider,
          uid: uid,
          name: data['name']
        )
      end
    end
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
