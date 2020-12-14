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

def replace_first_float(masked_val, new_bit)
    out = masked_val.clone

    out[out.index(nil)] = new_bit

    return out
end

def resolve_floats(masked_val)
    if !masked_val.include?(nil)
        return [masked_val.join.to_i(2)]
    end

    return resolve_floats(replace_first_float(masked_val, "0")) + resolve_floats(replace_first_float(masked_val, "1"))
end

def derive_addrs(addr, mask)
    addr_as_binary = addr.to_s(2).rjust(36, "0").split("")

    masked_addr = addr_as_binary.map.with_index { |bit, idx| mask[idx] == "0" ? bit : mask[idx] }

    return resolve_floats(masked_addr)
end

def solve_part2(input)
    memory = {}
    current_mask = ""

    for instr in input
        if instr[:cmd] == "mem"
            for addr in derive_addrs(instr[:addr], current_mask)
                memory[addr] = instr[:val]
            end
        end

        if instr[:cmd] == "mask"
            current_mask = instr[:val]
        end
    end

    return  memory.values.sum
end

puts solve_part1(input)
puts solve_part2(input)
