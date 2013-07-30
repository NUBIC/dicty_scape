json.array!(@relationships) do |relationship|
  json.extract! relationship, :go_id, :parent_go_id
  json.url relationship_url(relationship, format: :json)
end
