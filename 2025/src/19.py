from time import perf_counter
import math

def solve(FILENAME):
    raw = None
    with open(FILENAME) as FILE:
        raw = FILE.read()
    time0 = perf_counter()
    lines = raw.splitlines()
    
    max_dist_plus_height = 0
    curr_dist = 0
    
    for line in lines:
        dist, height, gap = map(int, line.split(","))
        
        if dist > curr_dist:
            max_dist_plus_height = max(dist + height, max_dist_plus_height)
            curr_dist = dist
            
    score = math.ceil(max_dist_plus_height / 2)

    time1 = perf_counter()
    print(f'{score}, {(time1-time0)*1e3:.3f}ms')

solve('./inputs/19p1.txt')
solve('./inputs/19p2.txt')
solve('./inputs/19p3.txt')