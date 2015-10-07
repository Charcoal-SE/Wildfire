class PopulateFlagTypes < ActiveRecord::Migration
  def change
    ["not an answer", "very low quality"].each do |reason|
      t = FlagType.new
      t.name = reason
      t.save!
    end
  end
end
