#!/usr/bin/env ruby
require 'set'

# **********************  Strings ********************** #
def longest(str1, str2)
  longest = nil
  str1.length.times do |ii|
    str2.length.times do |jj|
      if str1[ii] == str2[jj]
        cur_str_length = 1
        inc = 0
        until ii + inc >= str1.length || jj + inc >= str2.length
          if str1[ii..ii+inc] == str2[jj..jj+inc]
            cur_str_length = inc + 1
          end
          inc += 1
        end
        longest = cur_str_length if !longest || cur_str_length > longest
      end
    end
  end
  longest
end
# p longest("catf", "attacatf")


# **********************  Numbers ********************** #
def droot(num)
  while num > 10
    num = num / 10 + num % 10
  end
  num
end
# p droot(4325) # 9 + 5 = 14 = 5

def pair_sum(arr, k)
  seen = Set.new
  pairs = Set.new

  arr.each do |val|
    seek = k - val
    if seen.include?(seek)
      pairs.add([val, seek].sort)
    end

    seen.add(val)
  end
  pairs

end
p pair_sum([1, 2, -1, -1, -2], 0)
