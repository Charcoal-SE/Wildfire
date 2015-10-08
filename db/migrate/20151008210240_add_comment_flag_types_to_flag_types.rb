class AddCommentFlagTypesToFlagTypes < ActiveRecord::Migration
  def change
    ["obsolete", "not constructive", "too chatty", "rude or offensive"].each do |type|
      ftype = FlagType.new
      ftype.name = type
      ftype.save!
    end
  end
end
