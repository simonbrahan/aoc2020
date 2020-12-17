def new_grid(default_cell_val, dimensions)
    if dimensions == 1
        return Hash.new { |h, k| h[k] = default_cell_val }
    end

    return Hash.new { |h, k| h[k] = new_grid(default_cell_val, dimensions - 1) }
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

def dir_mods(num_dimensions)
    mods = [-1, 0, 1]

    return [-1, 0, 1].repeated_permutation(num_dimensions).reject { |pos| pos == [0] * num_dimensions }
end

def neighbours(*args)
    out = []

    for dir_parts in dir_mods(args.length)
        out.append(args.zip(dir_parts).map { |dir| dir.sum })
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
    out = new_grid(0, 3)

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
    out = new_grid(".", 3)

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

def solve_part1()
    grid = new_grid(".", 3)

    for line, y in File.readlines("input.txt", chomp: true).each_with_index
        for char, x in line.split("").each_with_index
            grid[0][y][x] = char
        end
    end

    for i in (1..6)
        next_grid = grid_from_neighbour_counts(grid, neighbour_counts(grid))

        grid = next_grid
    end

    return count_in_grid(grid, "#")
end

puts solve_part1()
