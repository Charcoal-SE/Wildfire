class AddFrequencyToFlagQueue < ActiveRecord::Migration
  def change
    add_column :flag_queues, :frequency, :integer, :default => 7200 # Default to 2 hours
    add_column :flag_queues, :last_run, :datetime, :default => Time.now
  end
end
