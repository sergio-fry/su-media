class AddBannerIdsToFrames < ActiveRecord::Migration
  def change
    add_column :frames, :banner_ids, :text
  end
end
