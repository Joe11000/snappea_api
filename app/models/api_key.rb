class ApiKey < ActiveRecord::Base
  validates :guid, presence: true,
                 length: { is: 32 },
                 uniqueness: true
end
