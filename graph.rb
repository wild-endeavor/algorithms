#!/usr/bin/env ruby
module GraphLibrary

  class Vertex
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
    attr_accessor :source, :dest

    def initialize(source, dest)
      @source = source
      @dest = dest
    end

    def inspect
      "Edge #{origin.label}-#{dest.label}\n"
    end

  end

  class Graph

    def self.load(filename)
      vtx = {}
      edges = []
      File.open(filename, "r") do |file|
        file.each_line do |line|
          source_v, dest_v = *line.chomp.split(/\s+/)
          vtx[source_v] = vtx[source_v] || Vertex.new(source_v)
          vtx[dest_v] = vtx[dest_v] || Vertex.new(dest_v)
          edge = Edge.new(vtx[source_v], vtx[dest_v])
          edges << edge
        end
      end
      vtx = vtx.map { |k, v| v }
      Graph.populate_edges(edges)
      [vtx, edges]
    end

    # This should take vertices and edges and populate the edges array of the vertices
    def self.populate_edges(edges)
      edges.each do |edge|
        edge.source.edges << edge
        edge.dest.edges << edge
      end
      edges
    end

  end
end

vtx, edges = *GraphLibrary::Graph.load("./sample_scc.txt")

vtx.each { |v| p v }


