class AddPostIdToFlag < ActiveRecord::Migration
  def change
    add_column :flags, :post_id, :integer
  end
end
