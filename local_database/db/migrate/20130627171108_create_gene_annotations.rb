class CreateGeneAnnotations < ActiveRecord::Migration
  def change
    create_table :gene_annotations do |t|
      t.string :db_object_symbol
      t.string :go_id
      t.string :evidence_code
      t.string :aspect
      t.string :reference
      t.integer :aspect_num
      t.string :color_code
    end
  end
end
