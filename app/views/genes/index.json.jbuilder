json.array!(@genes) do |gene|
  json.extract! gene, :db_object_id, :db_object_symbol, :db_object_name, :db_object_synonym
  json.url gene_url(gene, format: :json)
end
