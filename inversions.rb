#!/usr/bin/env ruby

def read_input_file
  x = []
  f = File.open("./IntegerArray.txt", "r")
  f.each_line do |line|
    x.push(Integer(line.chomp));
  end
  x
end

input = read_input_file

def merge_and_count(left_arr, right_arr)
  merged = []
  count = 0

  until left_arr.empty? || right_arr.empty?
    if (left_arr[0] <= right_arr[0])
      merged.push(left_arr.shift)
    else
      merged.push(right_arr.shift)
      count += left_arr.length
    end
  end
  merged = merged + left_arr + right_arr

  [merged, count]
end

def count_inversions(array)
  return [array, 0] if array.length <= 1
  pivot  = array.length / 2
  left_arr = array.take(pivot)
  right_arr = array.drop(pivot)

  left_sorted = count_inversions(left_arr)
  right_sorted = count_inversions(right_arr)

  merge, count = merge_and_count(left_sorted[0], right_sorted[0])
  count = count + left_sorted[1] + right_sorted[1]
  [merge, count]
end



left = [6, 7, 8, 20, 20]; right = [2, 11, 13, 13, 14];

# output = merge_and_count(left, right)
# puts output
# count_inversions(left + right)

p count_inversions(input)[1]



