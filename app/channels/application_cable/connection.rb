module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # 채널에서 이 이름으로 current_user에 접근할 수 있게 됩니다
    identified_by :current_user

    # 클라이언트가 WebSocket 연결을 시도할 때 실행
    def connect
      self.current_user = find_verified_user
    end

    private

    # Warden(Devise)으로 인증된 사용자를 찾아 돌려줍니다.
    def find_verified_user
      # env['warden']는 Devise가 삽입한 Warden::Proxy입니다.
      if (verified_user = env['warden'].user)
        verified_user
      else
        # 인증 실패하면 연결 거부
        reject_unauthorized_connection
      end
    end
  end
end
