#!/usr/bin/env ruby

class Vertex
  attr_accessor :value, :parent, :left, :right

  def initialize(value, parent = nil, left = nil, right = nil)
    @value = value
    @parent = parent
    @left = left
    @right = right
  end

  def min
    return self.left.nil? ? self.value : self.left.min
  end

  def max
    return self.right.nil? ? self.value : self.right.min
  end

  def display

  end
  
  def insert(vtx)
    vtx = Vertex.new(vtx) if !vtx.is_a?(Vertex)

    if vtx.value >= self.value
      if self.right.nil?
        self.right = vtx
        vtx.parent = self
      else
        self.right.insert(vtx)
      end
    else
      if self.left.nil?
        self.left = vtx
        vtx.parent = self
      else
        self.left.insert(vtx)
      end
    end
  end

  def size
    return 1 if self.right.nil? && self.left.nil?

    left_size = 0
    right_size = 0
    if self.left
      left_size = self.left.size
    end

    if self.right
      right_size = self.right.size
    end

    return 1 + left_size + right_size
  end

  def to_array
    res = [self.value];

    if self.left
      res += self.left.to_array
    end

    if self.right
      res += self.right.to_array
    end
    res
  end

end


 #    30
 #   /  \
 #  20  40
 #  /   / \
 # 10  35 50

root = Vertex.new(30)
v20 = Vertex.new(20, root)
v40 = Vertex.new(40, root)
root.left = v20
root.right = v40
v10 = Vertex.new(10, v20)
v20.left = v10
v35 = Vertex.new(35, v40)
v50 = Vertex.new(50, v40)
v40.left = v35
v40.right = v50

p root.to_array
