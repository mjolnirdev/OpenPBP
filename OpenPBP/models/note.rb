class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :campaign

  validates :title, :slug, :note, presence: true
  validates :title, :slug, length: { maximum: 64 }

  def new_note(params, campaign, user_id)
    self.nid = SecureRandom.urlsafe_base64(6, false)
    self.user_id = user_id
    self.campaign_id = campaign.id
    self.slug = params[:slug]
    self.title = params[:title]
    self.note = params[:note]
    self.public_note = params[:public_note]
  end

  def update_note(params)
    self.slug = params[:slug]
    self.title = params[:title]
    self.note = params[:note]
    self.public_note = params[:public_note]
  end
end
