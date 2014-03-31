class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.string :title
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
