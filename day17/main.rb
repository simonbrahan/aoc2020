def new_grid(default_cell_val)
    return Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = default_cell_val } } }
end

def get_keys(hash)
  ( hash.keys + hash.values.grep(Hash){|sub_hash| get_keys(sub_hash) } ).flatten
end

def print_grid(grid)
    start = get_keys(grid).min
    finish = get_keys(grid).max

    for z in (start..finish)
        puts z
        for y in (start..finish)
            puts (start..finish).map { |x| grid[z][y][x] || " " }.join(" ") + " -- " + y.to_s
        end
    end
end

def neighbours(z, y, x)
    out = []

    mods = [
        [-1, -1, -1], [-1, -1, 0], [-1, -1, 1], [-1, 0, -1], [-1, 0, 0], [-1, 0, 1],
        [-1, 1, -1], [-1, 1, 0], [-1, 1, 1], [0, -1, -1], [0, -1, 0], [0, -1, 1],
        [0, 0, -1], [0, 0, 1], [0, 1, -1], [0, 1, 0], [0, 1, 1], [1, -1, -1], [1, -1, 0],
        [1, -1, 1], [1, 0, -1], [1, 0, 0], [1, 0, 1], [1, 1, -1], [1, 1, 0], [1, 1, 1]
    ]

    for zmod, ymod, xmod in mods
        out.append([z + zmod, y + ymod, x + xmod])
    end

    return out
end

def count_in_grid(grid, cell_val)
    out = 0
    for layer in grid.values
        for row in layer.values
            for cell in row.values
                if cell == cell_val
                    out += 1
                end
            end
        end
    end

    return out
end

def neighbour_counts(grid)
    out = new_grid(0)

    for gz, layer in grid.to_a
        for gy, row in layer.to_a
            for gx, cell in row.to_a
                if cell == "#"
                    for nz, ny, nx in neighbours(gz, gy, gx)
                        out[nz][ny][nx] += 1
                    end
                end
            end
        end
    end

    return out
end

def grid_from_neighbour_counts(grid, counts)
    out = new_grid(".")

    for z, layer in counts.to_a
        for y, row in layer.to_a
            for x, cell_neighbour_count in row.to_a
                if grid[z][y][x] == "#"
                    if [2, 3].include?(cell_neighbour_count)
                        out[z][y][x] = "#"
                    else
                        out[z][y][x] = "."
                    end
                else
                    if cell_neighbour_count == 3
                        out[z][y][x] = "#"
                    else
                        out[z][y][x] = "."
                    end
                end
            end
        end
    end

    return out
end

def solve_part1(grid)
    current_grid = grid.clone

    for i in (1..6)
        next_grid = grid_from_neighbour_counts(current_grid, neighbour_counts(current_grid))

        current_grid = next_grid
    end

    return count_in_grid(current_grid, "#")
end

input = new_grid(".")

for line, y in File.readlines("input.txt", chomp: true).each_with_index
    for char, x in line.split("").each_with_index
        input[0][y][x] = char
    end
end

puts solve_part1(input)
