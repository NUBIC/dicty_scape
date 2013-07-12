class Annotation < ActiveRecord::Base
    has_many :gene_annotations, :primary_key=>'go_id', :foreign_key=>'go_id'
    has_many :genes, :through => :gene_annotations
end
