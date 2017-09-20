class Campaign < ActiveRecord::Base
  has_many :campaign_memberships, dependent: :destroy
  has_many :users, through: :campaign_memberships
  has_many :chapters, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :characters, dependent: :destroy

  validates :title, :slug, presence: true
  validates :title, :slug, length: { maximum: 64 }

  def create_campaign(params)
    if params[:image]
      file = file_upload(params[:image], 'campaign-images')
      self.image = file
    end
    self.cid = SecureRandom.urlsafe_base64(6, false)
    self.title = params[:title]
    self.slug = slug_sanitize(params[:slug])
    self.description = params[:description]
    self.archived = false
    self.join_link = SecureRandom.urlsafe_base64(27, false)
  end

  def seed_campaign(user_id)
    chapter = self.chapters.new
    chapter.title = "My First Chapter"
    chapter.slug = "my-first-chapter"
    chapter.description = "Edit this chapter."
    chapter.save
    scene = chapter.scenes.new
    scene.title = "My First Scene"
    scene.slug = "my-first-scene"
    scene.description = "Edit this scene."
    scene.save
    character = self.characters.new
    character.user_id = user_id
    character.charid = SecureRandom.urlsafe_base64(6, false)
    character.name = "GAME MASTER"
    character.bio = 'The Game Master is a special character whose avatar will
                     not show up on posts and replies.'
    character.default = true
    character.gm = true
    character.save
  end

  def seed_character(user_id)
    character = self.characters.new
    character.user_id = user_id
    character.charid = SecureRandom.urlsafe_base64(6, false)
    character.name = random_character_name()
    character.bio = ""
    character.default = true
    character.save
    character.charid
  end

  def update_campaign(params)
    if params[:image]
      file = file_replace(self.image, params[:image], 'campaign-images')
      self.image = file
    end
    self.title = params[:title]
    self.slug = slug_sanitize(params[:slug])
    self.description = params[:description]
    self.archived = params[:archived]
  end

  def refresh_join_link
    self.join_link = SecureRandom.urlsafe_base64(27, false)
  end
end
