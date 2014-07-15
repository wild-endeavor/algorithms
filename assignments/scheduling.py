#!/usr/bin/env python3.4

import re
import pprint

class Interval:
    def __init__(self, weight, length):
        self.weight = weight
        self.length = length
        # TODO: better to just assign rank here

    def __lt__(self, other):
        rank_self = float(self.weight) / self.length
        rank_other = float(other.weight) / other.length

        if rank_self > rank_other:
            return True
        elif rank_self == rank_other:
            if self.weight > other.weight:
                return True
            else:
                return False

    def __str__(self):
        return "W: %d L: %d R: %f" % (self.weight, self.length, \
            float(self.weight) / self.length)

    def __repr__(self):
        return self.__str__()


def read_file(file_name):
    intervals = []
    interval_pattern = re.compile("(.*)\\s(.*)")
    with open(file_name) as fh:
        i = 0
        for line in fh:
            line = line.rstrip("\n")
            weight, length = re.split('\s', line)
            intervals.append(Interval(int(weight), int(length)))
            # print("Weight %d, Length %d" % (int(weight), int(length)))
            # i += 1
            # if i == 10:
            #     break

    return intervals

def compute_weighted_completion(sorted_input):
    current_time = 0
    weighted_score = 0
    for job in sorted_input:
        current_time += job.length
        weighted_score += job.weight * current_time
    print("Final time")
    print(current_time)
    return weighted_score

intervals = read_file("assignments/input_files/jobs.txt")
sorted_intervals = sorted(intervals)
score = compute_weighted_completion(sorted_intervals)
print(score)
# pprint.pprint(sorted_intervals)


