class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
