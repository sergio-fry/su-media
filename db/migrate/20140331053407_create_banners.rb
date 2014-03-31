class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title
      t.attachment :picture

      t.timestamps
    end
  end
end
