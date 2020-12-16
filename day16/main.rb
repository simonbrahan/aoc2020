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

def column_is_valid(tickets, column, ranges)
    for ticket in tickets
        if !value_is_valid(ticket[column], ranges)
            return false
        end
    end

    return true
end

def field_matching_single_rule(tickets, fields, exclude_columns, exclude_fields)
    columns_to_check = (0..tickets[0].length).reject { |num| exclude_columns.include?(num) }
    fields_to_check = fields.reject { |field, ranges| exclude_fields.include?(field) }

    for column in columns_to_check
        matching_rules_count = 0
        for field, ranges in fields_to_check.to_a
            if column_is_valid(tickets, column, ranges)
                matching_rules_count += 1
                matching_field = field
            end
        end

        if matching_rules_count == 1
            return [matching_field, column]
        end
    end

    return nil
end

def get_field_order(validations, tickets)
    field_names = validations.keys
    field_names_by_position = {}
    matched_columns = []
    matched_fields = []

    while field_names_by_position.length < validations.length
        field_name, idx = field_matching_single_rule(tickets, validations, matched_columns, matched_fields)
        field_names_by_position[idx] = field_name
        matched_columns.append(idx)
        matched_fields.append(field_name)
    end

    return field_names_by_position.to_a.sort_by { |field| field[0] }.map { |field| field[1] }
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

    return labelled_ticket.select { |field, val| field.start_with?("departure") }.values.reduce(:*)
end

field_validation = field_validation_from_input(field_validation_input)
nearby_tickets = nearby_tickets_from_input(nearby_tickets_input)
my_ticket = my_ticket_from_input(my_ticket_input)

puts solve_part1(field_validation, nearby_tickets)
puts solve_part2(field_validation, nearby_tickets, my_ticket)
