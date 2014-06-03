#!/usr/bin/env ruby



class Item
  def initialize(item)
    @next = item
  end
end


# to reverse

def reverse(current, previous)
  tempitem = current.next
  current.next = previous

end

reverse(start, nil)