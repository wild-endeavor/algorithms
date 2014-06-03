#!/usr/bin/env ruby 

class Node
  attr_accessor :label, :edges

  def initialize(label)
    @label = label
    @edges = []
  end

  def inspect
    "L: #{self.label} edges: #{self.edges.length}\n"
  end
end


class Edge
  attr_accessor :origin, :dest

  def initialize(origin, destination)
    @origin = origin
    @dest = destination
  end

  def inspect
    "Edge #{origin.label}-#{dest.label}\n"
  end
end

nodes = []
all_edges = {}

x = 0
File.open("kargerMinCut.txt", "r") do |f|
# File.open("small_graph.txt", "r") do |f|
  f.each_line do |line|
    arr = line.split(/\s+/)
    source_label = Integer(arr.shift)
    if nodes[source_label - 1].nil?
      # puts "Making node: #{source_label}"
      nodes[source_label - 1] = Node.new(source_label)
    end
    source = nodes[source_label - 1]
    until arr.empty?
      linked_label = Integer(arr.shift)
      if nodes[linked_label - 1].nil?
        nodes[linked_label - 1] = Node.new(linked_label)
      end
      dest = nodes[linked_label - 1]
      key = "#{source_label}-#{linked_label}"
      key2 = "#{linked_label}-#{source_label}"
      if all_edges[key].nil? && all_edges[key2].nil?
        all_edges[key] = Edge.new(source, dest)
      end
    end
    x += 1
    # break if x == 10
  end
  # f.close
  # break
end

# Assign the edges
all_edges = all_edges.map do |k, v|
  v
end

all_edges.each do |edge|
  source_node = nodes[edge.origin.label - 1]
  dest_node = nodes[edge.dest.label - 1]
  source_node.edges << edge
  dest_node.edges << edge
end


def contraction(graph)
  nodes, edges = *graph
  return [nodes, edges] if nodes.length == 2

  # else, pick a random edge to contract
  edge_idx = rand(edges.length)
  edge = edges[edge_idx]
  # p "Deleting edge #{edge.inspect}"
  # Delete it from the main collection
  edges.delete_at(edge_idx)  

  # take the two nodes that the edge corresponds to and make it into one node
  #   delete the second node
  #   take all the other edges that were incident on the node to be deleted
  #   change them so that the source or dest that was originally pointed at the current node to be deleted
  #   is now pointed to the remaining node.
  #   add the edge to the edge set of the remaining node, iff it doesn't already exist in it.
  # delete self-loops

  source = edge.origin
  dest = edge.dest
  dest_idx = nodes.find_index(dest)
  raise "error - missing node" if dest_idx == nil
  nodes.delete_at(dest_idx)

  other_edges = dest.edges
  current_edge_idx = other_edges.find_index(edge)
  raise "error - missing edge" if current_edge_idx == nil
  other_edges.delete_at(current_edge_idx)

  other_edges.each do |sub_edge|
    # update the edge to point to the remaining node
    if sub_edge.origin == dest
      sub_edge.origin = source
    elsif sub_edge.dest == dest
      sub_edge.dest = source
    else
      raise "error - edge belongs to neither source nor origin"
    end

    if source.edges.find_index(sub_edge) == nil
      source.edges << sub_edge
    end
  end

  other_edges.each do |sub_edge|
    if sub_edge.origin == sub_edge.dest
      main_idx = edges.find_index(sub_edge)
      raise "error - self-loop deletion main" if main_idx == nil
      edges.delete_at(main_idx)

      node_idx = source.edges.find_index(sub_edge)
      raise "error - self-loop deletion node" if main_idx == nil
      source.edges.delete_at(node_idx)
    end
  end

  # Delete the edge from the remaining node's collection of edges
  source_edge_idx = source.edges.find_index(edge)
  raise "error deleting source edge" if source_edge_idx == nil
  source.edges.delete_at(source_edge_idx)

end

# puts "Before"
# p nodes
# p all_edges

# contraction([nodes, all_edges])

# puts "After"
# p nodes
# p all_edges



def karger(graph)
  nodes, edges = *graph

  while nodes.length > 2
    contraction([nodes, edges])
  end
 
end

# karger([nodes, all_edges])

# puts "After"
# p nodes
# p all_edges
# p all_edges.length



def create_input(input)
  nodes = []
  all_edges = {}
  input.each do |line|
    arr = line.split(/\s+/)
    source_label = Integer(arr.shift)
    if nodes[source_label - 1].nil?
      nodes[source_label - 1] = Node.new(source_label)
    end
    source = nodes[source_label - 1]
    until arr.empty?
      linked_label = Integer(arr.shift)
      if nodes[linked_label - 1].nil?
        nodes[linked_label - 1] = Node.new(linked_label)
      end
      dest = nodes[linked_label - 1]
      key = "#{source_label}-#{linked_label}"
      key2 = "#{linked_label}-#{source_label}"
      if all_edges[key].nil? && all_edges[key2].nil?
        all_edges[key] = Edge.new(source, dest)
      end
    end
  end

  all_edges = all_edges.map do |k, v|
    v
  end

  all_edges.each do |edge|
    source_node = nodes[edge.origin.label - 1]
    dest_node = nodes[edge.dest.label - 1]
    source_node.edges << edge
    dest_node.edges << edge
  end
  [nodes, all_edges]
end

def repeated_karger
  input = []
  File.open("kargerMinCut.txt", "r") do |f|
    f.each_line do |line|
      input << line
    end
  end
  results = []
  20000.times do |i|
    nodes, edges = *create_input(input)
    karger([nodes, edges])
    results << edges.length

  end
  p results
  p results.sort.first
end

repeated_karger



