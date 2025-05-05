class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  after_create_commit do
    # Action Cable 브로드캐스트
    ChatChannel.broadcast_to(conversation, render_message)
  end

  after_create_commit :broadcast_preview_update, :broadcast_first_message

  private
  
  def broadcast_preview_update
    conversation.users.each do |participant|
      ConversationsPreviewChannel.broadcast_to(
        participant,
        id: ActionView::RecordIdentifier.dom_id(conversation),
        html: ApplicationController.renderer.render(
          partial: "conversations/conversation_preview",
          locals: {
            conversation: conversation,
            viewer:       participant
          }
        )
      )
    end
  end

  def broadcast_first_message
    # 이 메시지가 conversation의 첫 메시지라면
    return unless conversation.messages.count == 1
  
    conversation.users.each do |participant|
      html = ApplicationController.renderer.render(
        partial: "conversations/conversation_preview",
        locals: { conversation: conversation, viewer: participant }
      )
  
      # 사용자별, conversations_{user.id} 스트림에 prepend
      ActionCable.server.broadcast(
        "conversations_#{participant.id}",
        tag: :prepend,
        target: "conversations_#{participant.id}", 
        html: html
      )
    end
  end

  def render_message
    ApplicationController.renderer.render(
      partial: 'messages/message',
      locals: { message: self }
    )
  end
end
