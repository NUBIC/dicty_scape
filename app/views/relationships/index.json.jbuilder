json.array!(@relationships) do |relationship|
  json.extract! relationship, :go_id, :parent_id, :lft, :rgt, :depth
  json.url relationship_url(relationship, format: :json)
end
