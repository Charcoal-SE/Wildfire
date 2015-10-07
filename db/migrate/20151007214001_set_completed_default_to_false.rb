class SetCompletedDefaultToFalse < ActiveRecord::Migration
  def change
    change_column_default(:flags, :completed, false)
  end
end
