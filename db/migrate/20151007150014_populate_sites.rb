class PopulateSites < ActiveRecord::Migration
  def change
    SitesHelper.updateSites
  end
end
