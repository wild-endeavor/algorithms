#!/usr/bin/env ruby

def zero(input)
  input

end

def max_subsequence(arr)
  max = 0
  current_max = 0
  l_idx = 0
  r_idx = 0
  left = 0

  arr.each_index do |idx|
    current_max += arr[idx]

    if current_max < 0
      left = idx + 1
      current_max = 0
    elsif current_max > max
      max = current_max
      l_idx = left
      r_idx = idx
    end
  end
  [l_idx, r_idx]
end

0, -9, -2, 9, 8, -3, 9, -1, -6, 1, -1, -6, 8, -3, -10, -4, -8, 8, 6, 6, -8, -10, -7, -10, -8, -6, 4, 3, 8, -10, 0, -3, -9, 9, -4, 9, -7, -8, -5, -3, 3, 3, -1, -2, 10, 0, 4, -9, -3, 0