class Event < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :attendees
  has_many :users, through: :attendees
  validates :name, :location, presence: true, length: { minimum: 2 }
  validates :date, presence: true
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end   
end