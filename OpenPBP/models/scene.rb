class Scene < ActiveRecord::Base
  belongs_to :chapter
  has_many :posts, dependent: :destroy

  validates :title, :slug, presence: true
  validates :title, :slug, length: { maximum: 64 }

  def update_scene(params)
    self.title = params[:title]
    self.slug = slug_sanitize(params[:slug])
    self.description = params[:description]
  end
end
