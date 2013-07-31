json.array!(@annotations) do |annotation|
  json.extract! annotation, :go_id, :annotation_name
  json.url annotation_url(annotation, format: :json)
end
