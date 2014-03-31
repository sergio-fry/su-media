class AddUrlToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :url, :text
  end
end
