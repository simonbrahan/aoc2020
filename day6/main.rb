require "set"

total_answers = 0
group_answers = Set.new
File.foreach("input.txt") { |line|
    if line == "\n"
        total_answers += group_answers.length
        group_answers.clear
        next
    end

    group_answers.merge(line.strip.split(""))
}

total_answers += group_answers.length

puts total_answers
