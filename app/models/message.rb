class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  after_create_commit do
    # Action Cable 브로드캐스트
    ChatChannel.broadcast_to(conversation, render_message)
  end

  after_create_commit :broadcast_preview_update

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

  def render_message
    ApplicationController.renderer.render(
      partial: 'messages/message',
      locals: { message: self }
    )
  end
end
