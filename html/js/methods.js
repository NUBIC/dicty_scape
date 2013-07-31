$(function()
{	
	$.extend(
	{
        getValuesJSON: function(url) // method to get data from file
        {
            window.cy= $("#demo").cytoscape("get");
            $.ajax(
            {
                url: url,
                dataType: "json",
                type: "get",
                success: function(data) {
                    if (data != null)
                    {
                        if (cy.elements()!= null)
                        {
                            cy.remove(cy.elements());
                            cy.off();
                        }
                        $.create(data);
                        $.setData(data[2]);
                    }
                }
            }); 
        },
        setPositionRadial : function(cy)
        {
            var nodeCount = cy.nodes().length;
            var go_annotationCount = 0;
            var geneCount = 0;
            var center_index = 0;
            for (var i = 0; i < nodeCount; i++)
            {
                if(cy.nodes()[i].data("group")=="annotation"&&cy.nodes()[i].data("depth")!=0)
                    go_annotationCount++;
                else if(cy.nodes()[i].data("group")=="gene"&&cy.nodes()[i].data("depth")!=0)
                    geneCount++;
                else
                    center_index = i;
            }
            if (nodeCount!=0)
            {
                var center = [cy.container().clientWidth / 2, cy.container().clientHeight / 2];
                cy.nodes()[center_index].position({x: center[0], y : center[1]});
            }
            var genes = 0;
            var go_annotations = 0;
            for (var i = 0; i < nodeCount; i++)
            {
                var angle_genes = genes / (geneCount)* Math.PI * 2;
                var angle_go_annotations = go_annotations / (go_annotationCount)* Math.PI * 2;
                var radius = Math.min(cy.container().clientWidth, cy.container().clientHeight) * 0.6*cy.nodes()[i].data("depth");   
                if (radius != 0)
                {
                    if(cy.nodes()[i].data("group")=="gene")
                    {
                        var nodePos = [Math.cos(angle_genes) * radius + center[0], Math.sin(angle_genes) * radius + center[1]];
                        cy.nodes()[i].position({x: nodePos[0], y : nodePos[1]});
                        genes++;
                    }
                    else 
                    {
                        var nodePos = [Math.cos(angle_go_annotations) * radius + center[0], Math.sin(angle_go_annotations) * radius + center[1]];
                        cy.nodes()[i].position({x: nodePos[0], y : nodePos[1]});
                        go_annotations++;
                    }
                }
            }
        },
        setPositionTree : function(cy)
        {
            var nodeCount = cy.nodes().length;
            var go_annotationCount = 0.0;
            var geneCount = 0.0;
            var center_index = 0;
            for (var i = 0; i < nodeCount; i++)
            {
                if(cy.nodes()[i].data("group")=="annotation"&&cy.nodes()[i].data("depth")!=0)
                    go_annotationCount++;
                else if(cy.nodes()[i].data("group")=="gene"&&cy.nodes()[i].data("depth")!=0)
                    geneCount++;
                else
                    center_index = i;
            }
            if (go_annotationCount != 0 && geneCount != 0)
            {
                if (nodeCount!=0)
                {
                    var center = [cy.container().clientWidth*-3/2, cy.container().clientHeight / 2];
                    cy.nodes()[center_index].position({x: center[0], y : center[1]});
                }
                var genes = 0;
                var go_annotations = 0;
                for (var i = 0; i < nodeCount; i++)
                {
                    if (i != center_index)
                    {
                        if(cy.nodes()[i].data("group")=="gene")
                        {
                            var nodePos = [((cy.nodes()[i].data("depth")-1)*4+1) * 2 * cy.container().clientWidth / 4,(genes + 1) * 4 * cy.container().clientHeight / (geneCount+1)-cy.container().clientHeight*3/2];
                            cy.nodes()[i].position({x: nodePos[0], y : nodePos[1]});
                            genes++;
                        }
                        else 
                        {
                            var nodePos = [((cy.nodes()[i].data("depth")-1)*4+1) * 2 * cy.container().clientWidth / 4,(go_annotations + 1) * 4 * cy.container().clientHeight / (go_annotationCount+1)-cy.container().clientHeight*3/2];
                            cy.nodes()[i].position({x: nodePos[0], y : nodePos[1]});
                            go_annotations++;
                        }
                    }
                }
            }
            else
            {
                if (nodeCount!=0)
                {
                    if (nodeCount!=1)
                        var center = [0, cy.container().clientHeight / 2];
                    else
                        var center = [cy.container().clientWidth / 2, cy.container().clientHeight / 2]; 
                    cy.nodes()[center_index].position({x: center[0], y : center[1]});
                }
                var genes = 0;
                var go_annotations = 0;
                for (var i = 0; i < nodeCount; i++)
                {
                    if (i != center_index)
                    {
                        if(cy.nodes()[i].data("group")=="gene")
                        {
                            var nodePos = [ cy.container().clientWidth,(genes + 1) * 4 * cy.container().clientHeight / (geneCount+1)-cy.container().clientHeight*3/2];
                            cy.nodes()[i].position({x: nodePos[0], y : nodePos[1]});
                            genes++;
                        }
                        else if(cy.nodes()[i].data("group")=="annotation")
                        {
                            var nodePos = [cy.container().clientWidth,(go_annotations + 1) * 4 * cy.container().clientHeight / (go_annotationCount+1)-cy.container().clientHeight*3/2];
                            cy.nodes()[i].position({x: nodePos[0], y : nodePos[1]});
                            go_annotations++;
                        }
                    }
                }
            }
        },
        setPositionForceDirected : function(cy)
        {
            var nodeCount = cy.nodes().length;
            for (var i = nodeCount-1; i >= 0; i--)
            {
                if (cy.nodes()[i].data("depth")==2)
                    cy.remove(cy.nodes()[i]);
            }
            nodeCount = cy.nodes().length;
            var center_index = 0;
            for (var i = 0; i <nodeCount; i++)
            {
                if(cy.nodes()[i].data("depth")==0)
                    center_index=i;
            }
            var strength = {}
            for (var i = 0; i<nodeCount; i++)
            {
                if (i!=center_index)
                {
                    strength[cy.nodes()[i].data("id")] = 0;
                    var edges = [];
                    var temp = cy.nodes()[i].edgesWith(cy.nodes()[center_index]);
                    for (var j = 0; j< temp.length;j++)
                        strength[cy.nodes()[i].data("id")] = strength[cy.nodes()[i].data("id")] + temp[j].data("weight");
                }
                else 
                    strength[cy.nodes()[i].data("id")] = 1;
                
            }
            if (nodeCount!=0)
            {
                var center = [cy.container().clientWidth / 2, cy.container().clientHeight / 2];
                cy.nodes()[center_index].position({x: center[0], y : center[1]});
            }
            var nodes = 0;
            for (var i = 0; i < nodeCount; i++)
            {
                var angle = nodes / (nodeCount-1)* Math.PI * 2;
                var radius = Math.min(cy.container().clientWidth, cy.container().clientHeight) * 6.0 / strength[cy.nodes()[i].data("id")]*cy.nodes()[i].data("depth");
                if (radius != 0)
                {
                    var nodePos = [Math.cos(angle) * radius + center[0], Math.sin(angle) * radius + center[1]];
                    cy.nodes()[i].position({x: nodePos[0], y : nodePos[1]});
                    nodes++;
                }
            }
        },
        setPositionRandomNetwork : function(cy)
        {
            var nodeCount = cy.nodes().length;
            var center_index = 0;
            for (var i = 0; i < nodeCount; i++)
            {
                if(cy.nodes()[i].data("depth")==0)
                    center_index = i;
            }
            if (nodeCount!=0)
            {
                var center = [cy.container().clientWidth / 2, cy.container().clientHeight / 2];
                cy.nodes()[center_index].position({x: center[0], y : center[1]});
            }
            for (var i = 0; i < nodeCount; i++)
            {
                if(cy.nodes()[i].data("depth")!=0)
                {
                    var nodePos = [cy.container().clientWidth*2*(Math.random()*2-1)+center[0], cy.container().clientHeight*2*(Math.random()*2-1)+ center[1]];
                    cy.nodes()[i].position({x: nodePos[0], y : nodePos[1]});
                }
            }
        },
        setOpacity : function(cy)
        {
        var edgeCount = cy.edges().length;
            for (var i = 0; i <edgeCount; i++)
            {
                cy.edges()[i].css("opacity", cy.edges()[i].data("weight")/20);
                if (cy.edges()[i].data("group")=="gene_annotation")
                    cy.edges()[i].css("content", cy.edges()[i].data("weight"));
            }
        },
        fitWindow : function (cy)
        {
            cy.fit();
            var length = Math.max( $("#demo").width(), $("#demo").height() );
            var zoom = cy.zoom() * (length - 150*2*cy.zoom())/length;
            cy.zoom({
                level: zoom,
                renderedPosition: {
                    x: $("#demo").width()/2,
                    y: $("#demo").height()/2
                }
            });
        },
        tooltipBind : function (cy)
        {
            cy.on("mouseover",cy.elements(),function(oEvent){
                $("#demo").qtip("destroy",true);
                $("#demo").qtip(
                {
                    overwrite: true,
                    content: 
                    {
                        text: oEvent.cyTarget.data("tooltiptext")
                    },
                    show: 
                    {
                        delay: 0,
                        event: false,
                        ready: true,
                        effect: false
                    },
                    hide: 
                    {
                        event: "click mouseleave"
                    }, 
                    position: 
                    {
                        my:"top right",
                        at:"top right",
                        viewport: true

                    },
                    style: 
                    {
                        classes: "qtip-green"
                    }   
                });
            });
        },
        create : function(eles)
        {
            $('#demo').cytoscape(
            {
                style: cytoscape.stylesheet()
                .selector("node")
                    .css
                    ({
                        "cursor": "pointer",
                        "content": "data(id)",
                        "border-width": 3,
                        "background-color": "#DDD",
                        "border-color": "#555",
                     })
                .selector("edge")
                    .css
                    ({
                        "width": "mapData(weight, 0, 20, 1, 7)",
                        "target-arrow-shape": "triangle",
                        "source-arrow-shape": "circle",
                        "line-color": "data(color)"
                    }),
                minZoom: 1e-1,
                maxZoom: 1e1,
                ready: function()
                {
                    window.cy = $("#demo").cytoscape("get");
                    cy.add(eles[0].concat(eles[1]));
                    if (document.getElementById("radio3").checked)
                        $.setPositionRadial(cy);
                    else if (document.getElementById("radio4").checked)
                        $.setPositionForceDirected(cy);
                    else if (document.getElementById("radio5").checked)       
                        $.setPositionTree(cy);
                    else
                        $.setPositionRandomNetwork(cy);
                    $.setOpacity(cy);
                    if(cy.nodes().length!=1&&cy.nodes().length!=2)
                        $.fitWindow(cy);
                    else if (cy.nodes().length==2)
                        cy.fit(cy.nodes(),150);
                    else
                    {
                        cy.fit();
                        cy.center(cy.nodes());
                        cy.zoom({level:cy.zoom()-10,position:cy.nodes()[0].position()})
                    }
                    $("#demo").cytoscapePanzoom();
                    $("#demo").cytoscapeEdgehandles();
                    $.nodeBind(cy);
                    $.tooltipBind(cy);
                }   
            });
        },
        getSite : function()
        {
            if (document.getElementById("radio1").checked)
                return "info"
            else
            {
                if (document.getElementById("radio4").checked)
                {
                    document.getElementById("radio4").checked=false;
                    document.getElementById("radio3").checked=true;
                }
                if (window.parentpresent)
                {
                    return "parent"
                }
                else
                    return "relationship"
            }
        },
        setData : function(data)
        {
            if (!data.children&&!data.parents)
                document.getElementById("data").innerHTML = "Type:<br>"+data.type+"<br><br>Number of Genes:<br>"+data.genes+"<br><br>Number of GO Annotations:<br>"+data.annotations+"<br><br>Number of Connections:<br>"+data.connections
            else if (data.children)
                document.getElementById("data").innerHTML = "Type:<br>"+data.type+"<br><br>Number of Genes:<br>"+data.genes+"<br><br>Number of GO Annotations:<br>"+data.annotations+"<br><br>Number of Connections:<br>"+data.connections+"<br><br>Children Surrounding Parent"
            else
                document.getElementById("data").innerHTML = "Type:<br>"+data.type+"<br><br>Number of Genes:<br>"+data.genes+"<br><br>Number of GO Annotations:<br>"+data.annotations+"<br><br>Number of Connections:<br>"+data.connections+"<br><br>Parents Surrounding Child"
        },
        nodeBind : function(cy)
        {            
            cy.on("tap", "node", function(oEvent){
                if(oEvent.cyTarget.data("depth")==0&&oEvent.cyTarget.data("group")=="gene")  
                {            
                    window.open("http://dictybase.org/gene/"+oEvent.cyTarget.data("id"));
                    $("input[id=genes]").val(oEvent.cyTarget.data("id"));
                }
                else if(oEvent.cyTarget.data("depth")==0&&oEvent.cyTarget.data("group")=="annotation")
                {
                    if (document.getElementById("radio1").checked)
                    {
                        window.open("http://www.ebi.ac.uk/QuickGO/GTerm?id="+oEvent.cyTarget.data("id"));
                        $("input[id=genes]").val(oEvent.cyTarget.data("id"));
                    }
                    else if (!window.parentpresent)
                    {
                        $.getValuesJSON("http://0.0.0.0:3000/annotations/"+oEvent.cyTarget.data("id")+"/get_parent.json") 
                        window.parentpresent = true;
                    }
                    else
                    {
                        $.getValuesJSON("http://0.0.0.0:3000/annotations/"+oEvent.cyTarget.data("id")+"/get_relationship.json") 
                        window.parentpresent = false;
                    }
                }
                else
                {
                    if (oEvent.cyTarget.data("group")=="gene")
                    {
                        document.getElementById("radio8").checked=false;
                        document.getElementById("radio7").checked=true;
                        document.getElementById("radio1").checked=true;
                        document.getElementById("radio2").checked=false;
                        $("#radio4").show();
                        $("#label4").show();
                        $("#radio2").hide();
                        $("#label2").hide();
                        $("#genes").autocomplete({source: window.genes,minLength: 2,select: function(event,ui){$.getValuesJSON("http://0.0.0.0:3000/genes/"+ui.item.label+"/get_"+$.getSite()+".json");}});
                    }
                    else
                    {
                        document.getElementById("radio8").checked=true;
                        document.getElementById("radio7").checked=false;
                        $("#radio4").hide();
                        $("#label4").hide();
                        $("#radio2").show();
                        $("#label2").show();
                        $("#genes").autocomplete({source: window.annotations,minLength: 4,select: function(event,ui){$.getValuesJSON("http://0.0.0.0:3000/annotations/"+ui.item.label+"/get_"+$.getSite()+".json");}});
                    }
                    $.getValuesJSON("http://0.0.0.0:3000/"+oEvent.cyTarget.data("group")+"s/"+oEvent.cyTarget.data("id")+"/get_"+$.getSite()+".json") 
                    $("input[id=genes]").val(oEvent.cyTarget.data("id"));
                }       
            });
        }
    });
});