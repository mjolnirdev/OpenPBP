class ChatMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign

  has_many :chat_messages

  def new_chat_message(params, user_id)
    self.user_id = user_id
    self.name = params[:name]
    self.message = params[:message]
  end

end
