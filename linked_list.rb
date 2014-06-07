#!/usr/bin/env ruby


class V
  attr_accessor :next_v, :label
  def initialize(label, next_v)
    @label = label
    @next_v = next_v
  end

  def to_s
    @label
  end

  def inspect
    if @next_v == nil
      @label
    else
      "#{@label} " + self.next_v.inspect 
    end
  end
end

d = V.new("d", nil)
c = V.new("c", d)
b = V.new("b", c)
a = V.new("a", b)

def reverse(start)
  current = start
  next_v = current.next_v
  prev_v = nil
  while next_v != nil
    next_v = current.next_v
    current.next_v = prev_v
    prev_v = current
    current = next_v
  end
  current
end

p a
reverse(a)
p d

