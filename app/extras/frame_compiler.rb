require 'open-uri'

class FrameCompiler
  attr_reader :frame

  def initialize(frame)
    @frame = frame
  end

  def compile
    frame.banners.each { |b| write_to_cloud(File.join(frame_path, banner_path(b)), open(b.picture.url).read) }
    write_to_cloud(File.join(frame_path, "include.html"), build_include_page)
  end

  def build_include_page
    <<-HTML
<!DOCTYPE html>
<html lang="ru">
  <head>
    <meta charset="UTF-8">
    <style>
      body { padding: 0px; margin: 0px; border 0px; }
    </style>
  </head>
  <body>
    <script src="http://yandex.st/jquery/2.1.0/jquery.min.js"></script>

    <div id="container" style="width: #{frame.width}px; height: #{frame.height}; overflow: hidden"></div>

    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
       (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
       m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
       })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', '#{ENV['GA_CODE']}', 'russianpulse.ru');
      ga('send', 'pageview');
    </script>

    <script>
      $(function() {
        var banners = [
        #{frame.banners.map{ |b| { src: banner_url(b), url: b.url, name: "##{b.id} #{b.title}" }.to_json }.join(",")}
        ];

        var banner =  banners[Math.floor(Math.random() * banners.length)];
        var obj = $("<a>").append($("<img>").attr({ "src": banner.src })).attr({ "href": banner.url, target: "blank" });

        obj.click(function() {
          ga('send', 'bannerclick', 'banners', 'click', banner.name, 1, {'nonInteraction': 1});
        });

        $("#container").append(obj);
        ga('send', 'bannerview', 'banners', 'view', banner.name, 1, {'nonInteraction': 1});
      });
    </script>
  </body>
</html>
    HTML
  end

  def root_url
    "http://s3.amazonaws.com/#{ENV['S3_BUCKET_NAME']}"
  end

  def frame_path
    "frames/frame-#{frame.id}"
  end

  def frame_url
    File.join(root_url, frame_path)
  end

  def banner_file_name(banner)
    "#{banner.id}.#{banner.picture_file_name.match(/\.([^.]*)$/)[1].downcase}"
  end

  def banner_path(banner)
    File.join(frame_path, "#{banner_file_name(banner)}")
  end

  def banner_url(banner)
    File.join(root_url, frame_path, "#{banner_file_name(banner)}?r=#{rand}&u=#{banner.updated_at.to_i}")
  end

  def write_to_cloud(path, data)
    bucket = AWS_STORE.directories.get ENV['S3_BUCKET_NAME']
    bucket.files.create(:key => path, :body => data, :public => true)
  end
end
