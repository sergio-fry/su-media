class Banner < ActiveRecord::Base
  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
end
