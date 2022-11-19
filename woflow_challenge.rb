# httparty.rb
require 'httparty'
require 'json'


def woflow_challenge()

    # saving nodes and counter
    nodes_db = Hash.new 0 

    # firs node
    response = HTTParty.get('https://nodes-on-nodes-challenge.herokuapp.com/nodes/089ef556-dfff-4ff2-9733-654645be56fe')
    node = JSON.parse(response.body)

    # travel in graph
    traverse_graph(node[0], nodes_db)

    # order by how many times we visited the node
    nodes_order_by_count = nodes_db.sort_by {|_key, value| -value}.to_h

    p "What is the most common node ID?: " + nodes_order_by_count.keys[0].to_s
    p "total number of unique node IDs: " + nodes_db.keys.count.to_s
end



def traverse_graph(current_node, nodes_db)
    p "visiting node: " + current_node["id"]

    if nodes_db.has_key?(current_node["id"])
        nodes_db[current_node["id"]] += 1
        return
    else
        nodes_db[current_node["id"]] = 1
    end

    current_node["child_node_ids"].each do |node_id|
        url = 'https://nodes-on-nodes-challenge.herokuapp.com/nodes/' + node_id 
        response = HTTParty.get(url)
        node = JSON.parse(response.body)
        
        traverse_graph(node[0], nodes_db)
    end

end


woflow_challenge()


# ------------------ ANSWER ------------------

# What is the most common node ID?: a06c90bf-e635-4812-992e-f7b1e2408a3f
# total number of unique node IDs: 30

# GEMS
# gem install httparty 
# gem install json 

# RUN
# install ruby , I use ruby 2.6.8
# ruby woflow_challenge.rb