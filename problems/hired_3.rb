#!/usr/bin/env ruby


def hills(arr)
  return 0 if arr.empty?
  puts "Original array:"
  p arr
  change_array = []

  arr.each_with_index do |el, idx|
    change_array << idx - el
  end

  change_min = change_array.min
  change_max = change_array.max
  range = change_max - change_min
  if range.odd?
    proper_max = range / 2 + 1
  else
    proper_max = range / 2
  end

  puts "X is: #{proper_max}"

  change_adjustor = proper_max - change_max
  change_array.map! { |ele| ele + change_adjustor }

  puts "Change array:"
  p change_array

  arr.each_index do |idx|
    arr[idx] = arr[idx] + change_array[idx]
  end
  puts "Final array:"
  p arr
  arr
end
 

hills([5, 3, -6, 21, -5, 8])
hills([5, 4, 3, 2, 8])


# Given an array: [5, 3, -6, 21, -5, 8]

# What do you need to get: [0, 1, 2, 3, 4, 5]?  You do this:
# [-5, -2, +8, -18, +9, -3]

# Now normalize that new array around 0... the range is -18 to +9, which means we need a range of 27
# 27 / 2 = 13
# current max is 9, add 4 to make it 13

# [-5, -2, +8, -18, +9, -3] =>
# [-1, +2, +12, -14, +13, +1]


# [-5, -2, +8, -18, +8, -3] => range is 26 / 2 = 13

# so let's set the max of the change array (currently +10) to +13 instead.

# [-1, +2, +12, -13, +13, +1]

# Apply this to the original array:
# [4, 5, 6, 7, 8, 9]






