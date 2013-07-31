class RelationshipsController < ApplicationController
    before_action :set_relationship, only: [:show]

    # GET /relationships
    # GET /relationships.json
    def index
        @relationships = Relationship.all
    end

    # GET /relationships/1
    # GET /relationships/1.json
    def show
    end


    private
    # Use callbacks to share common setup or constraints between actions.
        def set_relationship
            @relationship = Relationship.find_by_id(params[:id]) || Relationship.where(:go_id => params[:id])

        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def relationship_params
          params.require(:relationship).permit(:go_id, :parent_go_id)
        end
end
