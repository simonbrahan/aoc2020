require "set"

instructions = File.read("input.txt").split("\n").map {
    |instr|
        instr_parts = instr.split
        { :instr => instr_parts[0], :num => instr_parts[1].to_i }
}

instr_pointer = 0
visited_instructions = Set.new
accumulator = 0

while !visited_instructions.include?(instr_pointer)
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

puts accumulator
