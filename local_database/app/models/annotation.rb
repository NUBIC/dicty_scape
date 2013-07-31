class Annotation < ActiveRecord::Base
    has_many :gene_annotations, :primary_key=>'go_id', :foreign_key=>'go_id'
    has_many :genes, :through => :gene_annotations
    has_many :relationships, :primary_key=>'go_id', :foreign_key=>'parent_go_id'
end
