input = File.readlines("input.txt")
    .map do |line|
        instr_parts = line.strip.split(" = ")
        if instr_parts[0] == "mask"
            next { :cmd => "mask", :val => instr_parts[1] }
        else
            next { :cmd => "mem", :addr => instr_parts[0].scan(/\d/).join.to_i, :val => instr_parts[1].to_i }
        end
    end

memory = {}
current_mask = ""

for instr in input
    if instr[:cmd] == "mem"
        memory[instr[:addr]] = instr[:val]
    end
end

puts memory.inspect
