require "set"

instructions = File.read("input.txt").split("\n").map {
    |instr|
        instr_parts = instr.split
        { :instr => instr_parts[0], :num => instr_parts[1].to_i }
}

def solve_part1(instructions)
    accumulator, has_terminated = run(instructions)
    return accumulator
end

def solve_part2(instructions)
    instructions.each_with_index {
        |instr, idx|
            old_instr = instr[:instr]
            if !["nop", "jmp"].include?(old_instr)
                next
            end

            new_instr = old_instr == "jmp" ? "nop" : "jmp"
            instructions[idx][:instr] = new_instr
            accumulator, has_terminated = run(instructions)

            if has_terminated
                return accumulator
            end

            instructions[idx][:instr] = old_instr
    }

    return nil
end

def run(instructions)
    instr_pointer = 0
    visited_instructions = Set.new
    accumulator = 0

    while !visited_instructions.include?(instr_pointer) && instr_pointer < instructions.length
        visited_instructions.add(instr_pointer)
        instr = instructions[instr_pointer]

        case instr[:instr]
        when "acc"
            accumulator += instr[:num]
            instr_pointer += 1
        when "jmp"
            instr_pointer += instr[:num]
        when "nop"
            instr_pointer += 1
        end
    end

    return [accumulator, instr_pointer >= instructions.length]
end

puts solve_part1(instructions)
puts solve_part2(instructions)
