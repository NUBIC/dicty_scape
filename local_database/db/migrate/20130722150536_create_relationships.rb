class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :go_id
      t.string :parent_go_id
    end
  end
end
