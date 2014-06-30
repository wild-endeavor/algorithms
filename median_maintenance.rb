#!/usr/bin/env ruby

require_relative "heap"

class Maintainer
  attr_accessor :smaller, :larger

  def initialize
    # make two heaps, one min and one max
    # the smaller one is an extract-max hash
    @smaller = Heap.new()
    @larger = Heap.new()
  end

  def get_median
    median = -self.smaller.peek
  end

  def insert(value)
    largest_of_smaller = self.smaller.peek
    if largest_of_smaller.nil? || value <= -1 * largest_of_smaller
      self.smaller.insert(value * -1)
    else
      self.larger.insert(value)
    end
    self.rebalance
    # self.display
  end

  # when rebalancing, if even, then make even
  # if odd, then put the odd element into the smaller one
  def rebalance
    total = smaller.size + larger.size
    if larger.size > smaller.size
      while larger.size > smaller.size
        ele = larger.extract_min
        ele *= -1
        smaller.insert(ele)
      end
    else
      while smaller.size > larger.size + 1
        ele = smaller.extract_min
        ele *= -1
        larger.insert(ele)

      end
    end
  end

  def display
    left_half_max = -1 * smaller.peek
    right_half_min = larger.peek
    puts "L: #{smaller.size} / #{left_half_max} R: #{larger.size} / #{right_half_min}"
  end

end


# if something comes in, see if it is bigger than the biggest thing in the smaller set,
# if so, then put it into the bigger one, then rebalance.
input_array = []
File.open("median_input.txt", "r") do |file|
  file.each_line do |line|
    input_array << Integer(line.chomp)
  end
end

med = Maintainer.new
sum = 0
while input_array.length > 0
  current = input_array.shift
  med.insert(current)
  sum += med.get_median
end
med.display
p sum
p sum % 10000

# 46831213
# 1213

