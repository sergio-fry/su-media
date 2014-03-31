json.array!(@banners) do |banner|
  json.extract! banner, :id, :title
  json.url banner_url(banner, format: :json)
end
