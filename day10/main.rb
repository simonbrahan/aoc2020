input = File.readlines("input.txt").map { |line| line.to_i }.sort

def solve_part1(input)
    gaps = Hash.new { |h, k| h[k] = 0 }
    prev = 0
    input.each { |num|
        gaps[num - prev] += 1
        prev = num
    }

    # +1 "3" gap from built in adaptor
    return gaps[1] * (gaps[3] + 1)
end

def solve_part2(input)
    adaptors = input.clone
    adaptors.unshift(0)
    adaptors.append(adaptors[-1] + 3)

    return adaptors
        .chunk_while { |prev, nxt| prev + 1 == nxt }
        .map { |chunk| trib(chunk.length + 1) }
        .reduce(:*)
end

def trib(num)
    tribs = [0, 0, 1]

    while tribs.length < num
        tribs.append(tribs[-1] + tribs[-2] + tribs[-3])
    end

    return tribs[num]
end

puts solve_part1(input)

puts solve_part2(input)
