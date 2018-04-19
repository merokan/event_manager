class User < ActiveRecord::Base
  has_secure_password
  has_many :events
  has_many :comments
  has_many :attendees
  has_many :events_attended, through: :attendees, source: :event
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, :email, :location, presence: true, length: { minimum: 2 }
  validates :password, length: { minimum: 8 }, :on => :create
  validates :email, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
  before_save :downcase_fields
  def downcase_fields
    self.email.downcase!
  end
end
