require "set"

total_answered_by_anyone = 0
any_member_answered = Set.new
File.foreach("input.txt") { |line|
    if line == "\n"
        total_answered_by_anyone += any_member_answered.length
        any_member_answered.clear
        next
    end

    any_member_answered.merge(line.strip.split(""))
}

total_answered_by_anyone += any_member_answered.length

puts total_answered_by_anyone
