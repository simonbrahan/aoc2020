input = File.readlines("input.txt").map { |line| line.strip.split("") }

def num_neighbours(input, x, y)
    out = 0

    dirs = [[0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1]]

    for xmod, ymod in dirs
        neighbour_x = x + xmod
        neighbour_y = y + ymod

        if neighbour_y < 0 || neighbour_y >= input.length || neighbour_x < 0 || neighbour_x >= input[0].length
            next
        end

        if (input[neighbour_y][neighbour_x]) == "#"
            out += 1
        end
    end

    return out
end

def process_by_neighbours(input, x, y)
    if input[y][x] == "."
        return "."
    end

    if input[y][x] == "L" && num_neighbours(input, x, y) == 0
        return "#"
    end

    if input[y][x] == "#" && num_neighbours(input, x, y) >= 4
        return "L"
    end

    return input[y][x]
end

def process_seats(input, seat_func)
    return input.each_with_index.map do |row, y|
        row.each_with_index.map do |seat, x|
            method(seat_func).call(input, x, y)
        end
    end
end

def count_occupied(input)
    return input.flatten.filter { |seat| seat == "#" }.length
end

def solve_part1(input)
    seats = input

    loop do
        prev = seats

        seats = process_seats(seats, :process_by_neighbours)

        if prev == seats
            break
        end
    end

    return count_occupied(seats)
end

puts solve_part1(input)

