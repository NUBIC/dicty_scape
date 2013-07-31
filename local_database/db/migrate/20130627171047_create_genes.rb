class CreateGenes < ActiveRecord::Migration
  def change
    create_table :genes do |t|
      t.string :db_object_id
      t.string :db_object_symbol
      t.string :db_object_name
      t.string :db_object_synonym
    end
  end
end
