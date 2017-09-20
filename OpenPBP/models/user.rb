class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << "Email address is not valid."
    end
  end
end

class User < ActiveRecord::Base
  has_many :campaign_memberships
  has_many :campaigns, through: :campaign_memberships
  has_many :characters
  has_many :posts
  has_many :post_rolls
  has_many :reply_rolls
  has_many :notes

  validates :email, uniqueness: true, email: true
  validates :email, :password, presence: true
  validates :email, :display_name, length: { maximum: 64 }

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def create_user(params, request)
    self.uid = SecureRandom.urlsafe_base64(4, false)
    self.email = params[:email]
    self.password = params[:password]
    self.display_name = params[:display_name]
  end

  def update_details(params)
    self.email = params[:email]
    self.display_name = params[:display_name]
  end

  def update_password(params)
    self.password = params[:new_password]
  end

  def create_session(request)
    self.save
    self.id
  end

  def drop_primary(campaign)
    self.characters.where(campaign_id: campaign.id).each do |character|
      character.default = false
      character.save
    end
  end
end
