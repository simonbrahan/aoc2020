input = File.readlines("input.txt").map { |line| line.to_i }

preamble = 25

idx = preamble
while idx < input.length
    candidate = input[idx]
    sum_options = input[idx-preamble..idx-1]

    if !sum_options.combination(2).any? { |combo| combo.reduce(:+) == candidate }
        puts candidate
        break
    end

    idx += 1
end
