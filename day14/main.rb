input = File.readlines("input.txt")
    .map do |line|
        instr_parts = line.strip.split(" = ")
        if instr_parts[0] == "mask"
            next {
                :cmd => "mask",
                :val => instr_parts[1].split("").map { |char| { "0" => "0", "1" => "1" }[char] }
            }
        else
            next {
                :cmd => "mem",
                :addr => instr_parts[0].scan(/\d/).join.to_i,
                :val => instr_parts[1].to_i
            }
        end
    end

def mask_value(val, mask)
    val_as_binary = val.to_s(2).rjust(36, "0").split("")

    return val_as_binary.map.with_index { |bit, idx| mask[idx] || bit }
        .join
        .to_i(2)
end

def solve_part1(input)
    memory = {}
    current_mask = ""

    for instr in input
        if instr[:cmd] == "mem"
            memory[instr[:addr]] = mask_value(instr[:val], current_mask)
        end

        if instr[:cmd] == "mask"
            current_mask = instr[:val]
        end
    end

    return  memory.values.sum
end

puts solve_part1(input)
