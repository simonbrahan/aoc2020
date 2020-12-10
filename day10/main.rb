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

puts solve_part1(input)
