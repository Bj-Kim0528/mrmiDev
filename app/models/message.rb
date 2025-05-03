class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  after_create_commit do
    # Action Cable 브로드캐스트
    ChatChannel.broadcast_to(conversation, render_message)
  end

  private

  def render_message
    ApplicationController.renderer.render(
      partial: 'messages/message',
      locals: { message: self }
    )
  end
end
