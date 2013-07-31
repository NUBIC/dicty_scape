require "rubygems";
require "json";
def getColorCode(string)
	result = nil;
    case string
    when "F"
        result = "#0000FF";
    when "P"
        result = "#00FF00";    
    when "C"
        result = "#FF0000";
    else
        result = "#444";
    end
    return result; 
end
def getEvidenceCodeNum(string)
	result = nil;
    case string
    when "EXP"
    	result = 20;    				
    when "IDA"
    	result = 20;    		
    when "IPI"
    	result = 20;   				
    when "IMP"
    	result = 20;    				
    when "IGI"
    	result = 20;   				
    when "IEP"
    	result = 10;   				
    when "ISS"
    	result = 5;   				
    when "ISO"
    	result = 5;			
    when "ISA"
    	result = 5;			
    when "ISM"
    	result = 5;				
    when "IGC"
    	result = 5; 				
    when "IBA"
    	result = 5;				
    when "IBD"
    	result = 5;			
    when "IKR"
    	result = 5;    				
    when "IRD"
    	result = 5;			
    when "RCA"
    	result = 5;			
    when "TAS"
    	result = 10;    				
    when "NAS"
   		result = 10;    				
    when "IC"
    	result = 1;	
    when "ND"
    	result = 0;	
    when "IEA"
    	result = 5;	
    when "NR"
      	result = 0;		
    else
    	result = 0;
    end
    return result;
end
def getObjects(file = "data.txt")
	data = [];
	File.open(file,"r") do |f|	
		f.read.split(/\r/).each do |tsv|
			data << tsv.split(/\t/);
		end
	end
	objects = [];
	for i in 1...data.length do
		temp = Hash.new;
		for j in 0...data[0].length do
			temp.merge!(Hash[data[0][j] => data[i][j]]);
		end
		objects << temp;
	end
	return objects;
end
def getGeneElements(gene = "", file = "data.txt")
	objects = getObjects(file);
	centerNode = gene;
	allEdges = [];
	nodes_GO_annotation = [];
	nodes_gene = [];
	allNodes = [];
	objects.each do |i|
		if i["db_object_id"] == centerNode
			present = false;
			nodes_GO_annotation.each do |j|
				if i["GO_ID"] == j["data"]["id"]
					present = true;
				end
			end
			if !present
				nodes_GO_annotation <<
				{
					"data" => 
					{
						"id" => i["GO_ID"],
						"group" => "go_annotation",
						"depth" => 1,
					},
					"group" => "nodes",
					"grabbable" => false,
					"locked" => true
				}
			end
		end
	end
	otherwise = true;
	if nodes_GO_annotation.length == 0
		puts "Your gene is unavailable or has no Go annotations"
		otherwise = false;
		return nil;
	end
	i = 0;
	while i < nodes_GO_annotation.length
		numConnetions = 0;
		objects.each do |j|
			if j["GO_ID"] == nodes_GO_annotation[i]["data"]["id"]
				numConnetions += 1;
			end
		end
		nodes_GO_annotation[i]["data"]["connections"] = numConnetions;
		nodes_GO_annotation[i]["data"]["tooltiptext"] = "GO ID: #{nodes_GO_annotation[i]["data"]["id"]}\nConnections: #{numConnetions}";
		if numConnetions > 50
			nodes_GO_annotation.delete_at(i);
			i -= 1;
		end
		i += 1;
	end
	if otherwise && nodes_GO_annotation.length == 0
		puts "The go annotations of the gene have connections greater than 50";
		return nil;
	end
	objects.each do |i|
		nodes_GO_annotation.each do |j|
			if i["GO_ID"] == j["data"]["id"]
				present = false;
				nodes_gene.each do |k|
					if k["data"]["id"] == i["db_object_id"]
						present = true;
					end
				end
				if !present
					if i["db_object_id"] != centerNode
						nodes_gene <<
						{
							"data" =>
							{
								"id" => i["db_object_id"],
								"group" => "gene",
								"depth" => 2,
								"tooltiptext" => "ID: #{i["db_object_id"]}\nName: #{i["db_object_synonym"]}"
							},
							"group" => "nodes",
							"grabbable" => false,
							"locked" => true
						};
					else
						nodes_gene <<
						{
							"data" =>
							{
								"id" => i["db_object_id"],
								"group" => "centergene",
								"depth" => 0,
								"tooltiptext" => "ID: #{i["db_object_id"]}\nName: #{i["db_object_synonym"]}"
							},
							"group" => "nodes",
							"grabbable" => false,
							"locked" => true
						};
					end
				end
				allEdges <<
				{
					"data" =>
					{
						"target" => i["GO_ID"],
						"source" => i["db_object_id"],
						"color" => getColorCode(i["aspect"]),
						"tooltiptext" => "Evidence Code: #{i["evidence_code"]}\nAspect: #{i["aspect"]}\nConnecting: #{i["db_object_id"]} and #{i["GO_ID"]}",
						"weight" => getEvidenceCodeNum(i["evidence_code"])
					},
					"group" => "edges"
				};
			end
		end
	end
	allNodes = nodes_gene + nodes_GO_annotation;
	return [allNodes,allEdges];
end
objects = getObjects("data.txt");
all = [];
objects.each do |i|
	present = false;
	all.each do |j|
		if j == i["db_object_id"];
			present = true;
		end
	end
	if !present
		all << i["db_object_id"];
	end
end
index = 0.0;
all.each do |i|
	file = File.new("data/#{i}.json","w")
	file.write(getGeneElements(i).to_json);
	index += 1.0;
	percent = (index/all.length*10000).round/100.0;
	file.close();
	puts "#{percent}%";
end



	
