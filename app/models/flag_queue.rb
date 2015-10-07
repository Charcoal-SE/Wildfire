class FlagQueue < ActiveRecord::Base
  belongs_to :user
  has_many :flags
end
