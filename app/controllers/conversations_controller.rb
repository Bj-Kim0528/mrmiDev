class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations.includes(:users)
  end

  def show
    other = User.find(params[:id])
    @conversation = Conversation.find_or_create_between(current_user, other)
    @messages = @conversation.messages.order(:created_at)
  end
end
