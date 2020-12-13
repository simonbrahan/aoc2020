input = File.open("input.txt")

now = input.gets.strip.to_i
timetable = input.gets.strip.split(",")

def solve_part1(now, timetable)
    next_bus = timetable
        .reject { |i| i == "x" }
        .map do |bus|
            bus = bus.to_i
            last_time = now - (now % bus)
            next_time = last_time + bus
            [bus, next_time]
        end
        .sort_by { |bus_time| bus_time[1] }
        .first

    return (next_bus[1] - now) * next_bus[0]
end

puts solve_part1(now, timetable)
