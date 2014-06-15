#!/usr/bin/env ruby
module GraphLibrary

  class Vertex
    attr_accessor :label, :edges_outgoing, :edges_incoming,
      :explored, :finishing_time, :starting_vertex

    def initialize(label)
      @label = label
      @edges_outgoing = []
      @edges_incoming = []
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
    attr_accessor :source, :dest

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

    def initialize(filename)
      @vertices = []
      @edges = []
      @finishing_time = 0
      @vertices, @edges = *Graph.load(filename)
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

    # This should take vertices and edges and populate the edges array of the vertices
    def self.populate_edges(edges)
      edges.each do |edge|
        edge.source.edges_outgoing << edge
        edge.dest.edges_incoming << edge
      end
      edges
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
  end
end

# g = GraphLibrary::Graph.new("./sample_scc.txt")
# p g.vertices
# g.scc
# p g.vertices
# p g.sccs

# g2 = GraphLibrary::Graph.new("./sample_scc.txt")
# p g2.vertices
# g2.scc_stack
# p g2.vertices
# p g2.sccs

gf = GraphLibrary::Graph.new("./scc.txt")
# p gf.vertices
gf.scc_stack
# p gf.vertices
p gf.sccs.values.sort.reverse

