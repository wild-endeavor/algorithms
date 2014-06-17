#!/usr/bin/env ruby

module GraphLibrary
  require 'set'
  class Vertex
    attr_accessor :label, :edges_outgoing, :edges_incoming, :edges_all,
      :explored, :finishing_time, :starting_vertex

    def initialize(label)
      @label = label
      @edges_outgoing = []
      @edges_incoming = []
      @edges_all = [] # used for undirected graphs
      @explored = false
      @finishing_time = nil
      @starting_vertex = nil
    end

    def inspect
      string = "L: #{self.label} Out: #{self.edges_outgoing.length} " +
        "In: #{self.edges_incoming.length}"
      string += " FT: #{finishing_time}" if self.finishing_time
      string += "\n"
    end
  end

  class Edge
    attr_accessor :source, :dest, :length

    def initialize(source, dest)
      @source = source
      @dest = dest
    end

    def inspect
      "Edge #{source.label}-#{dest.label}"
    end
  end

  class Graph

    attr_accessor :vertices, :edges, :finishing_time, :sccs

    def initialize(filename, mode)
      @vertices = []
      @edges = []
      @finishing_time = 0
      if mode == 0
        @vertices, @edges = *Graph.load(filename)
      elsif mode == 1
        @vertices, @edges = *Graph.load_with_weights(filename)
      end
      @sccs = Hash.new { 0 }
    end

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

    def self.load_with_weights(filename)
      vtx = {}
      edges = {}
      File.open(filename, "r") do |file|
        file.each_line do |line|
          line_arr = line.chomp.split(/\s+/)
          source_label = line_arr.shift
          vtx[source_label] = vtx[source_label] || Vertex.new(source_label)
          line_arr.each do |pairing|
            dest_label, length = pairing.split(/,/)
            length = Integer(length) # does not do floats!
            vtx[dest_label] = vtx[dest_label] || Vertex.new(dest_label)
            edge = edges["#{source_label}-#{dest_label}"]
            if edge.nil?
              edge = Edge.new(vtx[source_label], vtx[dest_label])
              edge.length = length
              edges["#{source_label}-#{dest_label}"] = edge
              edges["#{dest_label}-#{source_label}"] = edge
            end
          end
        end
      end

      vtx = vtx.map { |k, v| v }
      edges = edges.map { |k, v| v }
      edges.uniq!

      Graph.populate_edges_undirected(edges)
      [vtx, edges]
    end

    # This should take vertices and edges and populate the edges array of the vertices
    # Use this method for directed graphs
    def self.populate_edges(edges)
      edges.each do |edge|
        edge.source.edges_outgoing << edge
        edge.dest.edges_incoming << edge
      end
      edges
    end

    def self.populate_edges_undirected(edges)
      edges.each do |edge|
        edge.source.edges_all << edge
        edge.dest.edges_all << edge
      end
    end

    def scc_dfs_loop(reverse = false)
      self.finishing_time = 0
      self.sccs = Hash.new { 0 }
      starter = nil
      self.vertices.each { |v| v.explored = false }

      self.vertices.each do |vertex|
        if !vertex.explored
          starter = vertex
          reverse ? self.scc_dfs_reverse(vertex, starter) : self.scc_dfs(vertex, starter)
        end
      end
    end

    def scc_dfs_loop_stack(reverse = false)
      self.finishing_time = 0
      self.sccs = Hash.new { 0 }
      starter = nil
      self.vertices.each { |v| v.explored = false }

      self.vertices.each do |vertex|
        if !vertex.explored
          starter = vertex
          reverse ? self.scc_dfs_reverse_stack(vertex) : self.scc_dfs_stack(vertex, starter)
        end
      end
    end

    def scc_dfs_reverse_stack(vertex)
      stack = [vertex]
      vertex.explored = true
      while !stack.empty?
        current = stack.last
        child = nil
        current.edges_incoming.each do |edge|
          if !edge.source.explored
            child = edge.source
            break
          end
        end
        if child.nil?
          stack.pop
          self.finishing_time += 1
          current.finishing_time = self.finishing_time
        else
          stack << child
          child.explored = true
        end
      end
    end

    def scc_dfs_stack(vertex, starter)
      stack = [vertex]
      vertex.explored = true
      while !stack.empty?
        current = stack.last
        child = nil
        current.edges_outgoing.each do |edge|
          if !edge.dest.explored
            child = edge.dest
            break
          end
        end
        if child.nil?
          stack.pop
          self.sccs[starter.label] += 1
        else
          stack << child
          child.explored = true
        end
      end
    end

    def scc_dfs_reverse(vertex, starter = nil)
      vertex.explored = true

      vertex.edges_incoming.each do |edge|
        # puts "Going into: #{edge.source.label} " if !edge.source.explored
        scc_dfs_reverse(edge.source, starter) if !edge.source.explored
      end

      self.finishing_time += 1
      vertex.finishing_time = self.finishing_time
      self.sccs[starter.label] += 1
    end

    def scc_dfs(vertex, starter = nil)
      vertex.explored = true

      vertex.edges_outgoing.each do |edge|
        scc_dfs(edge.dest, starter) if !edge.dest.explored
      end

      self.finishing_time += 1
      self.sccs[starter.label] += 1
    end

    def scc
      self.scc_dfs_loop(true)
      self.vertices.sort_by! { |v| -v.finishing_time }
      self.scc_dfs_loop(false)
    end

    def scc_stack
      self.scc_dfs_loop_stack(true)
      self.vertices.sort_by! { |v| -v.finishing_time }
      self.scc_dfs_loop_stack(false)
    end

    def dijkstras(source)
      if (self.vertices.index(source).nil?)
        raise "Could not find source vertex"
      end
      self.vertices.each { |v| v.explored = false }

      distances = {}
      distances[source.label] = 0
      source.explored = true
      edge_collection = source.edges_all.dup

      while !edge_collection.empty?
        min_edge = nil
        min_distance = nil
        # unexplored_vertex = nil
        # explored_vertex = nil
        edge_collection.each do |edge|
          if !(edge.source.explored ^ edge.dest.explored)
            raise "error with sets and exploration"
          end
          # TODO: factor this out
          unexplored_vertex = edge.source.explored ? edge.dest : edge.source
          explored_vertex = edge.source.explored ? edge.source : edge.dest
          total_distance = distances[explored_vertex.label] + edge.length
          if min_distance.nil? || total_distance < min_distance
            min_distance = total_distance
            min_edge = edge
          end
        end
        raise "min edge is nil" if min_edge.nil?

        # TODO: factor this out
        vertex_to_move = min_edge.source.explored ? min_edge.dest : min_edge.source
        already_explored = min_edge.source.explored ? min_edge.source : min_edge.dest
        distances[vertex_to_move.label] = distances[already_explored.label] +
          min_edge.length
        vertex_to_move.explored = true

        vertex_to_move.edges_all.each do |edge|
          if edge.source.explored && edge.dest.explored
            idx = edge_collection.index(edge)
            if idx
              edge_collection.delete_at(idx)
            else
              puts "hmmmm"
            end
          end

          if edge.source.explored ^ edge.dest.explored
            idx = edge_collection.index(edge)
            if !idx
              edge_collection << edge
            end
          end
        end
      end
      distances
    end
  end
end

# Code to run strongly connected components
# g2 = GraphLibrary::Graph.new("./sample_scc.txt")
# p g2.vertices
# g2.scc_stack
# p g2.vertices
# p g2.sccs

# g = GraphLibrary::Graph.new("./sample_scc.txt", 0)

g = GraphLibrary::Graph.new("dijkstraData.txt", 1)
output = g.dijkstras(g.vertices[0])
vtx = [7,37,59,82,99,115,133,165,188,197]
vtx.each do |ele|
  print output[ele.to_s].to_s + ","
end

