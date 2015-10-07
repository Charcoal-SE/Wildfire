class AddPostTypeToFlag < ActiveRecord::Migration
  def change
    add_column :flags, :post_type, :string
  end
end
