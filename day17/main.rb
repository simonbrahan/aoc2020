def new_grid(default_cell_val, dimensions)
    if dimensions == 1
        return Hash.new { |h, k| h[k] = default_cell_val }
    end

    return Hash.new { |h, k| h[k] = new_grid(default_cell_val, dimensions - 1) }
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
    if !grid.is_a?(Hash)
        return grid == cell_val ? 1 : 0
    end

    return grid.values.map { |subgrid| count_in_grid(subgrid, cell_val) }.sum
end

def neighbour_counts_3d(grid)
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

def neighbour_counts_4d(grid)
    out = new_grid(0, 4)

    for gw, zone in grid.to_a
        for gz, layer in zone.to_a
            for gy, row in layer.to_a
                for gx, cell in row.to_a
                    if cell == "#"
                        for nw, nz, ny, nx in neighbours(gw, gz, gy, gx)
                            out[nw][nz][ny][nx] += 1
                        end
                    end
                end
            end
        end
    end

    return out
end

def grid_from_neighbour_counts_3d(grid, counts)
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

def grid_from_neighbour_counts_4d(grid, counts)
    out = new_grid(".", 4)

    for w, zone in counts.to_a
        for z, layer in zone.to_a
            for y, row in layer.to_a
                for x, cell_neighbour_count in row.to_a
                    if grid[w][z][y][x] == "#"
                        if [2, 3].include?(cell_neighbour_count)
                            out[w][z][y][x] = "#"
                        else
                            out[w][z][y][x] = "."
                        end
                    else
                        if cell_neighbour_count == 3
                            out[w][z][y][x] = "#"
                        else
                            out[w][z][y][x] = "."
                        end
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
        next_grid = grid_from_neighbour_counts_3d(grid, neighbour_counts_3d(grid))

        grid = next_grid
    end

    return count_in_grid(grid, "#")
end

def solve_part2()
    grid = new_grid(".", 4)

    for line, y in File.readlines("input.txt", chomp: true).each_with_index
        for char, x in line.split("").each_with_index
            grid[0][0][y][x] = char
        end
    end

    for i in (1..6)
        next_grid = grid_from_neighbour_counts_4d(grid, neighbour_counts_4d(grid))

        grid = next_grid
    end

    return count_in_grid(grid, "#")
end

puts solve_part1()
puts solve_part2()
