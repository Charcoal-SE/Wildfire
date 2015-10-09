class AddBatchSizeToFlagQueue < ActiveRecord::Migration
  def change
    add_column :flag_queues, :batch_size, :integer, :default => 1
  end
end
