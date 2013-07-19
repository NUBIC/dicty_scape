class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :go_id
      t.string :parent_id
      t.string :lft
      t.string :rgt
      t.integer :depth
    end
  end
end
