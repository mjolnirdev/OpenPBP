class Chapter < ActiveRecord::Base
  belongs_to :campaign
  has_many :scenes, dependent: :destroy

  validates :title, :slug, presence: true
  validates :title, :slug, length: { maximum: 64 }

  def update_chapter(params)
    self.title = params[:title]
    self.slug = slug_sanitize(params[:slug])
    self.description = params[:description]
  end

end
