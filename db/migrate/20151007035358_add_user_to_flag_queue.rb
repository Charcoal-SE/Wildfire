class AddUserToFlagQueue < ActiveRecord::Migration
  def change
    add_reference :flag_queues, :user, index: true, foreign_key: true
  end
end
