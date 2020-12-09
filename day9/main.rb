input = File.readlines("input.txt").map { |line| line.to_i }

def solve_part1(input)
    preamble = 25
    idx = preamble

    while idx < input.length
        candidate = input[idx]
        sum_options = input[idx-preamble..idx-1]

        if !sum_options.combination(2).any? { |combo| combo.reduce(:+) == candidate }
            return candidate
        end

        idx += 1
    end
end

def solve_part2(input, bad_number)
    contiguous_sums = []
    sum = 0

    for num in input
        sum += num
        contiguous_sums.push([sum, num])
    end

    left = 0
    right = 0

    while right < contiguous_sums.length
        candidate_sum = contiguous_sums[right][0] - contiguous_sums[left][0]

        if candidate_sum == bad_number
            break
        end

        if candidate_sum < bad_number
            right += 1
        else
            left += 1
        end
    end

    summing_nums = contiguous_sums[left+1..right].map { |sum| sum[1] }

    return summing_nums.max + summing_nums.min
end

bad_number = solve_part1(input)

puts bad_number

puts solve_part2(input, bad_number)
