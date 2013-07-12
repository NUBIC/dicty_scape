class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :go_id
      t.string :annotation_name
    end
  end
end
