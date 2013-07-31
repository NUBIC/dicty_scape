class Relationship < ActiveRecord::Base
    has_one :annotation, :primary_key=>'parent_go_id', :foreign_key=>'go_id'
end
