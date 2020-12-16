field_validation_input, my_ticket_input, nearby_tickets_input = File.read("input.txt")
    .split("\n\n")
    .map { |part| part.split("\n") }

def field_validation_from_input(input)
    return input.map do |line|
        field, limits = line.split(": ")
        next {
            :field => field,
            :limits => limits.split(" or ").map { |range| range.split("-").map { |num| num.to_i } }
        }
    end
end

def nearby_tickets_from_input(input)
    input.shift

    return input.map do |line|
        line.split(",").map { |num| num.to_i }
    end
end

def value_is_valid(num, validations)
    for validation in validations
        for start, finish in validation[:limits]
            if num >= start && num <= finish
                return true
            end
        end
    end

    return false
end

def sum_invalid_fields(ticket, validations)
    out = 0

    for field in ticket
        if !value_is_valid(field, validations)
            out += field
        end
    end

    return out
end

def solve_part1(field_validation, nearby_tickets)
    out = 0

    for ticket in nearby_tickets
        out += sum_invalid_fields(ticket, field_validation)
    end

    return out
end

field_validation = field_validation_from_input(field_validation_input)
nearby_tickets = nearby_tickets_from_input(nearby_tickets_input)

puts solve_part1(field_validation, nearby_tickets)
