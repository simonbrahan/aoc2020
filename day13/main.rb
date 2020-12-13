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

def solve_part2(timetable)
    times = []
    timetable.each_with_index do |bus, idx|
        if bus == "x"
            next
        end

        times.append({ :bus => bus.to_i, :offset => idx })
    end

    search_step = times[0][:bus]
    current_step = 0
    bus_to_match = 1
    # the bus times are sorted prime numbers
    # If we step through timestamps by the lowest number, we can find the first time where:
    #   bus 1 has arrived
    #   bus 2 arrives in 1 minute
    #
    # We then need a new step size: one that bus 1 and 2 will next appear at.
    # Since the bus times are prime, this must be bus 1 time * bus 2 time.
    # This is our new step size.
    # Every time we find a time that fits the next bus, we find the new step size and start looking for the next one.
    while bus_to_match < times.length
        current_step += search_step

        if (current_step + times[bus_to_match][:offset]) % times[bus_to_match][:bus] == 0
            search_step = times[..bus_to_match].map { |bus| bus[:bus] }.reduce(:*)
            bus_to_match +=1
        end
    end

    return current_step
end

puts solve_part1(now, timetable)
puts solve_part2(timetable)
