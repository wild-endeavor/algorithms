#!/usr/bin/env ruby

class Heap
  attr_accessor :heap

  def swap(source, dest)
    if source >= self.heap.length || dest >= self.heap.length
      raise "Heap error: index out of bounds"
    end
    tmp = self.heap[dest]
    self.heap[dest] = self.heap[source]
    self.heap[source] = tmp
  end

  def initialize(array = nil)
    @heap = []
    @heap = array.sort! if array
  end

  def parent_index(i)
    raise "Heap error: already root" if i == 0
    (i - 1) / 2
  end

  # TODO: consider whether these should be class methods
  def left_child_idx(i)
    2 * i + 1
  end

  def right_child_idx(i)
    2 * i + 2
  end

  def insert(value)
    self.heap << value
    self.bubble_up
  end

  def check
    i = 0
    until left_child_idx(i) > self.heap.length - 1
      p self.heap if self.heap[left_child_idx(i)] < self.heap[i]
      raise "bad heap left" if self.heap[left_child_idx(i)] < self.heap[i]
      if right_child_idx(i) < self.heap.length
        raise "bad heap right" if self.heap[right_child_idx(i)] < self.heap[i]
      end
      i += 1
    end
  end

  # Currently these versions of bubble up and down work on the last and
  # first elements of the array respectively.  We can also make it
  # recursive and have the functions take an input
  def bubble_up
    current_idx = self.heap.length - 1
    while current_idx > 0 &&
        self.heap[current_idx] < self.heap[parent_index(current_idx)]
      self.swap(current_idx, parent_index(current_idx))
      current_idx = parent_index(current_idx)
    end
  end

  def bubble_down
    return if self.heap.length == 0
    current = 0
    while left_child_idx(current) < self.heap.length
      left_value = self.heap[left_child_idx(current)]
      # if the right child exists
      if right_child_idx(current) < self.heap.length
        right_value = self.heap[right_child_idx(current)]
        if self.heap[current] <= left_value && self.heap[current] <= right_value
          break
        elsif right_value < left_value
          self.swap(current, right_child_idx(current))
          current = right_child_idx(current)
        else
          self.swap(current, left_child_idx(current))
          current = left_child_idx(current)
        end
      else # if only the left child exists
        if self.heap[current] <= left_value
          break
        else
          self.swap(current, left_child_idx(current))
          current = left_child_idx(current)
        end
      end
    end
  end

  def extract_min
    root = self.heap[0]
    new_root = self.heap.pop
    return new_root if self.heap.empty?
    self.heap[0] = new_root
    self.bubble_down
    root
  end

  def size
    self.heap.length
  end

  def peek
    self.heap.first
  end

end

def test
  h = Heap.new()
  h.insert(6331)
  h.insert(9290)
  h.insert(2793)
  h.insert(6195)
  h.extract_min
  h.insert(2793)
  h.insert(5685)
  h.extract_min
  h = Heap.new()
  h.insert(5)
  p h.heap
  h.insert(5)
  p h.heap
  h.insert(3)
  p h.heap
  h.insert(2)
  p h.heap
  h.insert(6)
  p h.heap
  h.insert(7)
  p h.heap
  min = h.extract_min
  p min
  p h.heap
end

if __FILE__ == $PROGRAM_NAME
  test
end

