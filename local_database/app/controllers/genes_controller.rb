class GenesController < ApplicationController
    before_action :set_gene, only: [:show, :get_info, :get_relationship, :get_parent]

  # GET /genes
  # GET /genes.json
    def index
    @genes = Gene.all
    respond_to do |format|
        format.html  { render :index } # index.html.erb
        format.json  { render :json => @genes.pluck("db_object_symbol").concat(@genes.pluck("db_object_id")).uniq.to_json}
    end

    end


    # GET /genes/1
    # GET /genes/1.json
    def show
    end

    def get_relationship
        respond_to do |format|
            format.json  { render :json => nil.to_json}
        end
    end

    def get_parent
        respond_to do |format|
            format.json  { render :json => nil.to_json}
        end
    end

    def get_info
        gene = @gene
        if gene != nil
            annotations = gene.annotations
            annotations = annotations.reject {|i| i.gene_annotations.length > 50}
            if annotations.length > 0
                all_genes = annotations.map{|i| i.genes}.flatten.uniq
                gene_annotations = annotations.map{|i| i.gene_annotations}.flatten.uniq
                all = []
                allEdges = []
                allNodes = []
                nodes_GO_annotations = []
                nodes_gene = []
                all_genes.each do |i|
                    if i != gene
                        nodes_gene <<
                        {
                            "data" =>
                            {
                                "id" => i["db_object_symbol"],
                                "group" => "gene",
                                "depth" => 2,
                                "tooltiptext" => ["ID: " ,i["db_object_id"],"\nName: ", i["db_object_name"], "\nSynonym: ",i["db_object_synonym"], "\nSymbol: ",i["db_object_symbol"]].join()
                            },
                            "group" => "nodes",
                            "grabbable" => false,
                            "locked" => true,
                            "selectable" => false
                        }
                    else
                        nodes_gene <<
                        {
                            "data" =>
                            {
                                "id" => i["db_object_symbol"],
                                "group" => "gene",
                                "depth" => 0,
                                "tooltiptext" => ["ID: " ,i["db_object_id"],"\nName: ", i["db_object_name"], "\nSynonym: ",i["db_object_synonym"], "\nSymbol: ",i["db_object_symbol"]].join()
                            },
                            "group" => "nodes",
                            "grabbable" => false,
                            "locked" => true,
                            "selectable" => false
                        }

                    end
                end
                annotations.each do |i|
                    nodes_GO_annotations <<
                    {
                        "data" =>
                        {
                            "id" => i["go_id"],
                            "group" => "annotation",
                            "depth" => 1,
                            "tooltiptext" => ["GO ID: ", i["go_id"],"\nName: ",i["annotation_name"]].join()
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
                            "group" => "gene_annotation",
                            "tooltiptext" => ["Evidence Code: ",i["evidence_code"],"\nAspect: ",i["aspect"],"\nConnecting: ",i["db_object_symbol"]," and ",i["go_id"]].join()
                        },
                        "group" => "edges",
                        "grabbable" => false,
                        "selectable" => false
                    }
                end
                allEdges = allEdges.uniq
                allNodes = allNodes.uniq
                allNodes.concat(nodes_gene)
                allNodes.concat(nodes_GO_annotations)
                data = 
                {
                    "type" => "Gene to GO Annotation",
                    "annotations" => annotations.uniq.length,
                    "genes" => all_genes.uniq.length,
                    "connections" => allEdges.uniq.length,
                    "parents" => false,
                    "children" => false
                }
                all << allNodes
                all << allEdges
                all << data
                respond_to do |format|
                    format.html  { render :show } # index.html.erb
                    format.json  { render :json => all.to_json}
                end
            else
                nodes = []
                puts gene
                nodes <<
                {
                    "data" =>
                    {
                        "id" => gene["db_object_symbol"],
                        "group" => "gene",
                        "depth" => 0,
                        "tooltiptext" => ["ID: " ,gene["db_object_id"],"\nName: ", gene["db_object_name"], "\nSynonym: ",gene["db_object_synonym"], "\nSymbol: ",gene["db_object_symbol"]].join()
                    },
                    "group" => "nodes",
                    "grabbable" => false,
                    "locked" => true,
                    "selectable" => false
                }
                data = 
                {
                    "type" => "Gene to GO Annotation",
                    "annotations" => 0,
                    "genes" => 1,
                    "connections" => 0,
                    "parents" => false,
                    "children" => false
                }
                respond_to do |format|
                    format.json  { render :json => [nodes,[],data].to_json}
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
    def set_gene
        @gene = Gene.find_by_id(params[:id]) || Gene.find_by_db_object_symbol(params[:id]) || Gene.find_by_db_object_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gene_params
      params.require(:gene).permit(:db_object_id, :db_object_symbol, :db_object_name, :db_object_synonym)
    end
end
