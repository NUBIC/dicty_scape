class AnnotationsController < ApplicationController
    before_action :set_annotation, only: [:show, :get_info]

  # GET /annotations
  # GET /annotations.json
  def index
    @annotations = Annotation.all
    respond_to do |format|
        format.html  { render :index } # index.html.erb
        format.json  { render :json => @annotations.pluck("go_id").concat(@annotations.pluck("annotation_name")).to_json}
    end
  end

  # GET /annotations/1
  # GET /annotations/1.json
  def show
  end
    
  def get_info
    annotation = @annotation
    if annotation != nil 
        genes = annotation.genes
        if !(genes.length>50)&&genes!=[]
            all_annotations = genes.map{|i| i.annotations}.flatten.uniq
            gene_annotations = genes.map{|i| i.gene_annotations}.flatten.uniq
            all = []
            allEdges = []
            allNodes = []
            nodes_GO_annotations = []
            nodes_gene = []
            all_annotations.each do |i|
                if i != annotation
                    nodes_GO_annotations <<
                    {
                        "data" =>
                        {
                            "id" => i["go_id"],
                            "group" => "annotation",
                            "depth" => 2,
                            "tooltiptext" => ["GO ID: ", i["go_id"],"\nName: ",i["annotation_name"]].join()
                        },
                        "group" => "nodes",
                        "grabbable" => false,
                        "locked" => true,
                        "selectable" => false
                    }
                else
                    nodes_GO_annotations <<
                    {
                        "data" =>
                        {
                            "id" => i["go_id"],
                            "group" => "annotation",
                            "depth" => 0,
                            "tooltiptext" => ["GO ID: ", i["go_id"],"\nName: ",i["annotation_name"]].join()
                        },
                        "group" => "nodes",
                        "grabbable" => false,
                        "locked" => true,
                        "selectable" => false
                    }   
                end
            end
            genes.each do |i|
                nodes_gene <<
                {
                    "data" =>
                    {
                        "id" => i["db_object_symbol"],
                        "group" => "gene",
                        "depth" => 1,
                        "center" => false,
                        "tooltiptext" => ["ID: " ,i["db_object_id"],"\nName: ", i["db_object_name"], "\nSynonym: ",i["db_object_synonym"], "\nSymbol: ",i["db_object_symbol"]].join()
                    },
                    "group" => "nodes",
                    "grabbable" => false,
                    "locked" => true,
                    "selectable" => false
                }
            end
            gene_annotations.each do |i|
                allEdges <<
                {
                    "data" =>
                    {
                        "target" => i["go_id"],
                        "source" => i["db_object_symbol"],
                        "color" => i["color_code"],
                        "weight" => i["aspect_num"],
                        "tooltiptext" => ["Evidence Code: ",i["evidence_code"],"\nAspect: ",i["aspect"],"\nConnecting: ",i["db_object_symbol"]," and ",i["go_id"]].join()
                    },
                    "group" => "edges",
                    "grabbable" => false,
                    "selectable" => false
                }
            end
            allEdges = allEdges.uniq
            allNodes = allNodes.uniq
            allNodes.concat(nodes_GO_annotations)
            allNodes.concat(nodes_gene)
            all << allNodes
            all << allEdges
            respond_to do |format|
                format.html  { render :show } # index.html.erb
                format.json  { render :json => all.to_json}
        end
        else
          respond_to do |format|
            format.json  { render :json => nil.to_json}
          end
        end
      else
        respond_to do |format|
            format.json  { render :json => nil.to_json}
        end
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_annotation
      @annotation = Annotation.find_by_id(params[:id]) || Annotation.find_by_go_id(params[:id]) || Annotation.find_by_annotation_name(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def annotation_params
        params.require(:annotation).permit(:go_id, :annotation_name)
    end
end
