class CreateFlagTypes < ActiveRecord::Migration
  def change
    create_table :flag_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
