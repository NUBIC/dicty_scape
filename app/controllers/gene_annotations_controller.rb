class GeneAnnotationsController < ApplicationController
  before_action :set_gene_annotation, only: [:show]

  # GET /gene_annotations
  # GET /gene_annotations.json
  def index
    @gene_annotations = GeneAnnotation.all
  end

  # GET /gene_annotations/1
  # GET /gene_annotations/1.json
  def show
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gene_annotation
      @gene_annotation = GeneAnnotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gene_annotation_params
        params.require(:gene_annotation).permit(:db_object_symbol, :go_id, :evidence_code, :aspect, :reference, :aspect_num, :color_code)
    end
end
