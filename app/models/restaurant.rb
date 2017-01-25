class Restaurant < ActiveRecord::Base
  validates :name, presence: true
  validates :address, presence: true
  validate :rating_validation

  def rating_validation
    unless (0..5).include?(rating.to_f) && rating.to_s.match(/^\d{1}.\d{1}$/)
      errors.add(:rating, "illegal rating format: 5 star rating must be between 0.0 and 5.0" )
    end
  end
end
