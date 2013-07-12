json.array!(@gene_annotations) do |gene_annotation|
  json.extract! gene_annotation, :db_object_symbol, :go_id, :evidence_code, :aspect, :reference, :aspect_num, :color_code
  json.url gene_annotation_url(gene_annotation, format: :json)
end
