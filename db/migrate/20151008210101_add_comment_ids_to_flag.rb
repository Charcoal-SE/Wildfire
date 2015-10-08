class AddCommentIdsToFlag < ActiveRecord::Migration
  def change
    add_column :flags, :comment_ids, :string
  end
end
