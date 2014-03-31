json.array!(@frames) do |frame|
  json.extract! frame, :id, :title, :width, :height
  json.url frame_url(frame, format: :json)
end
