class CreateFlagQueues < ActiveRecord::Migration
  def change
    create_table :flag_queues do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
