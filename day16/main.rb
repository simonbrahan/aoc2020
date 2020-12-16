field_validation_input, my_ticket_input, nearby_tickets_input = File.read("input.txt")
    .split("\n\n")
    .map { |part| part.split("\n") }

def field_validation_from_input(input)
    out = {}

    for line in input
        field, limits = line.split(": ")
        out[field] = limits.split(" or ").map { |range| range.split("-").map { |num| num.to_i } }

    end

    return out
end

def nearby_tickets_from_input(input)
    input.shift

    return input.map do |line|
        line.split(",").map { |num| num.to_i }
    end
end

def my_ticket_from_input(input)
    return input[1].split(",").map { |num| num.to_i }
end

def value_fits_some_field(num, validations)
    for ranges in validations.values
        if value_is_valid(num, ranges)
            return true
        end
    end

    return false
end

def value_is_valid(num, ranges)
    for start, finish in ranges
        if num >= start && num <= finish
            return true
        end
    end

    return false
end

def sum_invalid_fields(ticket, validations)
    out = 0

    for field in ticket
        if !value_fits_some_field(field, validations)
            out += field
        end
    end

    return out
end

def ticket_is_valid(ticket, validations)
    for field in ticket
        if !value_fits_some_field(field, validations)
            return false
        end
    end

    return true
end

def might_work(validations, tickets, candidate_order)
    # previous fields have already been tested, so just test the last one
    latest_field = candidate_order[-1]
    field_idx = candidate_order.length - 1

    for ticket in tickets
        if !value_is_valid(ticket[field_idx], validations[latest_field])
            return false
        end
    end

    return true
end

def next_candidates(candidate_order, field_names)
    remaining_fields = field_names.reject { |field| candidate_order.include?(field) }

    return remaining_fields.map { |field| candidate_order + [field] }
end

def get_field_order(validations, tickets)
    field_names = validations.keys

    candidates = field_names.map { |field_name| [field_name] }

    while candidate = candidates.shift
        if might_work(validations, tickets, candidate)
            if candidate.length == validations.length
                return candidate
            end

            candidates += next_candidates(candidate, field_names)
        end
    end

    return nil
end

def solve_part1(field_validation, nearby_tickets)
    out = 0

    for ticket in nearby_tickets
        out += sum_invalid_fields(ticket, field_validation)
    end

    return out
end

def solve_part2(field_validation, nearby_tickets, my_ticket)
    valid_tickets = nearby_tickets.select { |ticket| ticket_is_valid(ticket, field_validation) }

    field_order = get_field_order(field_validation, valid_tickets)

    labelled_ticket = Hash[field_order.zip(my_ticket)]

    puts labelled_ticket

    return 0
end

field_validation = field_validation_from_input(field_validation_input)
nearby_tickets = nearby_tickets_from_input(nearby_tickets_input)
my_ticket = my_ticket_from_input(my_ticket_input)

puts solve_part1(field_validation, nearby_tickets)
puts solve_part2(field_validation, nearby_tickets, my_ticket)
