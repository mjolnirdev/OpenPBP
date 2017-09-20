class Character < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :user
  belongs_to :post

  has_many :posts
  has_many :replies

  def create_character(params, user_id)
    if params[:base64] != ""
      blob = base64_to_blob(params[:base64])
      tempfile = blob_to_tempfile(blob)
      file = file_upload_cropped(tempfile, 'character-portraits')
      self.portrait = file
    end
    self.user_id = user_id
    self.charid = SecureRandom.urlsafe_base64(6, false)
    self.name = params[:name]
    self.bio = params[:bio]
  end

  def update_character(params)
    if params[:base64] != ""
      blob = base64_to_blob(params[:base64])
      tempfile = blob_to_tempfile(blob)
      file = file_replace_cropped(self.portrait, tempfile, 'character-portraits')
      self.portrait = file
    end
    self.name = params[:name]
    self.bio = params[:bio]
  end

  def set_primary(campaign, user_id)
    characters = campaign.characters.where(user_id: user_id)
    characters.each do |character|
      character.default = false
      character.save
    end
    self.default = true
    self.save
  end
  
end
