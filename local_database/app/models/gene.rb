class Gene < ActiveRecord::Base
    has_many :gene_annotations, :primary_key=>'db_object_symbol', :foreign_key=>'db_object_symbol'
    has_many :annotations, :through => :gene_annotations
end
