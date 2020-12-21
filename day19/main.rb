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

def rule_is_terminal(rule)
    return rule.is_a? String
end

def validate(message, rules, apply_seq = [0])
    # If message and rule apply sequence are both empty, this apply sequence has validated the message
    # If only one is empty, this apply sequence cannot validate the message
    if message.empty? || apply_seq.empty?
       return message.empty? && apply_seq.empty?
    end

    rule = rules[apply_seq[0]]

    if rule_is_terminal(rule)
        # If rule is a character...
        if message[0] == rule
            # and it matches the next character in the message...
            # validate the remainder of the message with the remainder of the rule apply sequence
            return validate(message[1..], rules, apply_seq[1..])
        else
            # if it does not match the next character in the message, this apply sequence cannot validate the message
            return false
        end
    end

    # Rule is expandable. Expand it in the apply sequence and try to validate against any expansion
    for expansion in rule
        if validate(message, rules, expansion + apply_seq[1..])
            return true
        end
    end

    return false
end

puts messages.select { |message| validate(message, rules) }.length
