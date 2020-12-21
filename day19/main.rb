rules_input, messages = File.read("input.txt")
    .split("\n\n")
    .map { |section| section.split("\n") }

rules = {}
for rule_input in rules_input
    rule_num, rule = rule_input.split(": ")

    if /^"\w"$/.match(rule)
        parsed = rule[1]
    else
        parsed = rule.split(" | ").map { |nums| nums.split.map { |num| num.to_i } }
    end

    rules[rule_num.to_i] = parsed
end

