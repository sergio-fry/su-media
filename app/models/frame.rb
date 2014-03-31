class Frame < ActiveRecord::Base
  serialize :banner_ids

  def banners
    Banner.where(:id => banner_ids)
  end
end
