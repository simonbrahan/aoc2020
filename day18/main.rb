tests = [
    ["1 + 2 * 3 + 4 * 5 + 6", 71],
    ["1 + (2 * 3) + (4 * (5 + 6))", 51],
    ["2 * 3 + (4 * 5)", 26],
    ["5 + (8 * 3 + 9 + 3 * 4 * 3)", 437],
    ["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240],
    ["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632]
]

def char_is_numeric(char)
    return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].include?(char)
end

def next_subexpr(expr)
    idx = 0
    paren_count = 0

    loop do
        if expr[idx] == "("
            paren_count += 1
        end

        if expr[idx] == ")"
            paren_count -= 1
        end

        break if paren_count == 0

        idx += 1
    end

    return [solve(expr[1...idx]), expr[idx+1..]]
end

def next_part(expr)
    if !expr || expr.empty?
        return [nil, nil]
    end

    if expr[0] == "("
        return next_subexpr(expr)
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

for expr, expect in tests
    raise "failed " + expr if solve(expr) != expect
end

def solve_part1(input)
    return input.map { |expr| solve(expr) }.sum
end

input = File.readlines("input.txt").map { |line| line.strip }

puts solve_part1(input)
