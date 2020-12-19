tests = [
    ["1 + 2 * 3 + 4 * 5 + 6", 71],
    ["1 + (2 * 3) + (4 * (5 + 6))", 51],
    ["2 * 3 + (4 * 5)", 26],
    ["5 + (8 * 3 + 9 + 3 * 4 * 3)", 437],
    ["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240],
    ["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632]
]

def is_int(token)
    return token.is_a? Integer
end

def lex(expr)
    return expr.gsub("(", "( ").gsub(")", " )").split.map do |token|
        maybe_num = token.to_i

        if maybe_num.to_s == token
            next maybe_num
        else
            next token
        end
    end
end

def to_postfix(expr)
    out = []
    opstack = []

    for token in lex(expr)
        if is_int(token)
            out.append(token)
        end

        if ["*", "+"].include?(token)
            while opstack.last && opstack.last != "("
                out.append(opstack.pop)
            end

            opstack.append(token)
        end

        if token == "("
            opstack.append("(")
        end

        if token == ")"
            while op = opstack.pop
                if op == "("
                    break
                end

                out.append(op)
            end
        end
    end

    while op = opstack.pop
        out.append(op)
    end

    return out
end

def solve(expr)
    stack = []

    for token in to_postfix(expr)
        if token == "*"
            stack.append(stack.pop * stack.pop)
        elsif token == "+"
            stack.append(stack.pop + stack.pop)
        else
            stack.append(token)
        end
    end

    return stack.pop
end

for expr, expect in tests
    raise "failed " + expr if solve(expr) != expect
end

def solve_part1(input)
    return input.map { |expr| solve(expr) }.sum
end

input = File.readlines("input.txt").map { |line| line.strip }

puts solve_part1(input)
