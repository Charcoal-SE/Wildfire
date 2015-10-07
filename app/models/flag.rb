class Flag < ActiveRecord::Base
  belongs_to :site
  belongs_to :flag_queue
  belongs_to :flag_type
end
