#!/usr/bin/env ruby

class Array
  def swap(a, b)
    tmp = self[b]
    self[b] = self[a]
    self[a] = tmp
    return self
  end

  def median_of_three(left, right)
    left_val = self[left]
    right_val = self[right]

    if (right - left + 1).odd?
      middle_idx = (right - left) / 2
    else
      middle_idx = left + (right - left) / 2
    end
    
    middle_val = self[middle_idx]

    return middle_idx if left_val <= middle_val && middle_val <= right_val
    return middle_idx if right_val <= middle_val && middle_val <= left_val

    return left if middle_val <= left_val && left_val <= right_val
    return left if right_val <= left_val && left_val <= middle_val

    return right if left_val <= right_val && right_val <= middle_val
    return right if middle_val <= right_val && right_val <= left_val
  end
end


input = [3, 10, 6, 4, 1, 5, 7, 9, 2, 8]

def read_input(filepath)
  input_array = []
  number = 1
  File.open(filepath, "r") do |file|
    file.each_line do |line|
      input_array << Integer(line.chomp)
      number += 1
      # break if number == 100
    end
  end
  input_array
end

# input = read_input("./sample")
input = read_input("./quicksort_input.txt")

# This partition method needs a bit of work... it was meant to comply _exactly_ with
# the process that was advised in the coursera roughgarden class.
def partition(array, left, right)
  if right - left == 0
    return true
  end

  # pick a pivot

  # pivot_idx = left # just the first index # 162085
  # pivot_idx = right # just the last index # 164123
  # pivot_idx = left + rand(right - left + 1) # random
  if right - left >= 2          # 144100
    pivot_idx = array.median_of_three(left, right)
  else
    pivot_idx = right
  end

  array.swap(left, pivot_idx)
  pivot_idx = left
  pivot_value = array[left]
  ii = left + 1
  jj = left + 1
  have_seen_greater = false

  until (jj > right)

    if array[jj] >= pivot_value && !have_seen_greater
      have_seen_greater = true
      ii = jj
    end

    if array[jj] < pivot_value && have_seen_greater
      array.swap(ii, jj)
      ii += 1
    end
    jj += 1
  end

  if have_seen_greater
    array.swap(pivot_idx, ii - 1)
    return ii - 1
  else
    array.swap(left, right)
    return right
  end
end

$temp = 0

def quicksort(array, left, right)

  return if right - left == 0
  raise "Error" if right - left < 0
  $temp += right - left

  pivot_idx = partition(array, left, right)

  quicksort(array, left, pivot_idx - 1) if pivot_idx > left
  quicksort(array, pivot_idx + 1, right) if pivot_idx < right

end

quicksort(input, 0, input.length - 1)
p input
p $temp

