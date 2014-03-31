class Frame < ActiveRecord::Base
  serialize :banner_ids
  after_save :compile, :unless => lambda { Rails.env.development? }

  def banners
    Banner.where(:id => banner_ids)
  end

  def compile
    compiler = FrameCompiler.new(self)
    compiler.compile
  end
end
