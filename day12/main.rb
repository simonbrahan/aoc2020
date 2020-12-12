input = File.readlines("input.txt").map do |line|
    com, num = line.strip.split("", 2)
    { :cmd => com, :num => num.to_i }
end

def new_dir(current_dir, rotate_by)
    #input rotations are always in multiples of 90, so we'll end up pointed in another cardinal direction
    dirs = ["N", "E", "S", "W"]

    current_dir_idx = dirs.index(current_dir)

    rotate_count = rotate_by / 90

    new_dir_idx = (current_dir_idx + rotate_count) % 4

    return dirs[new_dir_idx]
end

def new_pos(current_pos, dir, num)
    dirmod = { "N" => [0, 1], "E" => [1, 0], "S" => [0, -1], "W" => [-1, 0] }[dir]

    return [current_pos[0] + dirmod[0] * num, current_pos[1] + dirmod[1] * num]
end

def solve_part1(input)
    boat_pos = [0, 0]
    boat_dir = "E"

    for cmd in input
        case cmd[:cmd]
        when "N"
            boat_pos[1] += cmd[:num]
        when "S"
            boat_pos[1] -= cmd[:num]
        when "E"
            boat_pos[0] += cmd[:num]
        when "W"
            boat_pos[0] -= cmd[:num]
        when "L"
            boat_dir = new_dir(boat_dir, -cmd[:num])
        when "R"
            boat_dir = new_dir(boat_dir, cmd[:num])
        when "F"
            boat_pos = new_pos(boat_pos, boat_dir, cmd[:num])
        end
    end

    return boat_pos[0].abs + boat_pos[1].abs
end

puts solve_part1(input)
