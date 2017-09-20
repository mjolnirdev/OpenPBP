class Post < ActiveRecord::Base
  belongs_to :scene
  belongs_to :user
  belongs_to :character
  
  has_many :replies, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :post_rolls, dependent: :destroy

  validates :post, presence: true

  def new_post(params, user_id)
    self.pid = SecureRandom.urlsafe_base64(6, false)
    self.user_id = user_id
    self.character_id = Character.find_by_charid(params[:charid]).id
    self.post = params[:post]
  end

  def update_post(params)
    self.post = params[:post]
  end

end
