input = File.read("input.txt").strip.split(",").map { |char| char.to_i }

def num_from_record(record)
    if record.length == 1
        return 0
    end

    return record[-1] - record[-2]
end

def play_game(input, turns)
    spoken = Hash.new { |h, k| h[k] = [] }
    input.each_with_index { |num, idx| spoken[num].append(idx+1) }
    last_spoken = input[-1]
    current_turn = spoken.length + 1

    while current_turn <= turns
        num_record = spoken[last_spoken]

        next_num = num_from_record(num_record)

        spoken[next_num].append(current_turn)
        last_spoken = next_num
        current_turn += 1
    end

    return last_spoken
end

puts play_game(input, 2020)
puts play_game(input, 30000000)
