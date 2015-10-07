class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|

      t.boolean :completed
      t.string :failure_reason
      t.datetime :attempted_at

      t.belongs_to :flag_queue
      t.belongs_to :site

      t.timestamps null: false
    end
  end
end
