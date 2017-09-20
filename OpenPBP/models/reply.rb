class Reply < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :character

  has_many :reply_rolls, dependent: :destroy

  validates :reply, presence: true

  def new_reply(params, user_id)
    self.rid = SecureRandom.urlsafe_base64(6, false)
    self.user_id = user_id
    self.character_id = Character.find_by_charid(params[:charid]).id
    self.reply = params[:reply]
  end

  def update_reply(params)
    self.reply = params[:reply]
  end
end
