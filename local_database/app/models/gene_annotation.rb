class GeneAnnotation < ActiveRecord::Base
    has_one :gene, :primary_key=>'db_object_symbol', :foreign_key=>'db_object_symbol'
    has_one :annotation, :primary_key=>'go_id', :foreign_key=>'go_id'

end
