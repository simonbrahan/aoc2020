require "set"

total_answered_by_anyone = 0
total_answered_by_everyone = 0
any_member_answered = Set.new
all_members_answered = Set.new(("a".."z"))
File.foreach("input.txt") { |line|
    if line == "\n"
        total_answered_by_anyone += any_member_answered.length
        total_answered_by_everyone += all_members_answered.length
        any_member_answered.clear
        all_members_answered.replace(("a".."z"))
        next
    end

    member_answers = line.strip.split("")
    any_member_answered.merge(member_answers)
    all_members_answered = all_members_answered.intersection(member_answers)
}

total_answered_by_anyone += any_member_answered.length
total_answered_by_everyone += all_members_answered.length

puts total_answered_by_anyone
puts total_answered_by_everyone
