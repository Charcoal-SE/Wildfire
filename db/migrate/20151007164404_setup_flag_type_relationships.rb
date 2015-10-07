class SetupFlagTypeRelationships < ActiveRecord::Migration
  def change
    change_table :flags do |t|
      t.belongs_to :flag_type
    end
  end
end
