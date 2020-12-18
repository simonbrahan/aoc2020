input = "1 + 2 * 3 + 4 * 5 + 6"

def char_is_numeric(char)
    return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].include?(char)
end

def next_part(expr)
    if !expr || expr.empty?
        return [nil, nil]
    end

    if ["+", "*"].include?(expr[0])
        return [expr[0], expr[1..-1]]
    end

    idx = 0
    while char_is_numeric(expr[idx])
        idx += 1
    end

    return [expr[0...idx].to_i, expr[idx..]]
end

def solve(expr)
    expr.gsub!(/\s+/, "")

    acc, expr = next_part(expr)

    loop do
        op, expr = next_part(expr)
        num, expr = next_part(expr)

        if !op
            break
        end

        if op == "+"
            acc += num
        else
            acc *= num
        end
    end

    return acc
end

puts solve(input)
