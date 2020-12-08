require "set"

def parse_contents(contents)
    return [] if contents == "no other bags."

    output = []
    for content_def in contents.split(", ")
        def_parts = content_def.split(" ")
        count = def_parts[0].to_i
        bag_name = def_parts[1..2].join(" ")
        output.push({ :name => bag_name, :count => count })
    end

    return output
end

def solve_part1(bag_parents)
    bags_containing_target = Set.new
    bags_to_check = ["shiny gold"]

    while !bags_to_check.empty?
        bag_to_check = bags_to_check.shift
        checked_bag_parents = bag_parents[bag_to_check]
        bags_containing_target = bags_containing_target.merge(checked_bag_parents)
        bags_to_check.concat(checked_bag_parents)
    end

    return bags_containing_target.length
end

def solve_part2(bag_defs)
    bag_count = 0
    bags_to_check = ["shiny gold"]

    while !bags_to_check.empty?
        bag_to_check = bags_to_check.shift
        for bag in bag_defs[bag_to_check]
            bag_count += bag[:count]
            bags_to_check += [bag[:name]] * bag[:count]
        end
    end

    return bag_count
end

bag_defs = {}
bag_parents = Hash.new { |h, k| h[k] = [] }
File.foreach("input.txt") { |line|
    bag_def = line.chomp.split(" ")
    parent_bag = bag_def[0..1].join(" ")
    contents_def = parse_contents(bag_def[4..].join(" "))
    bag_defs[parent_bag] = contents_def
    for bag in contents_def
        bag_parents[bag[:name]].push(parent_bag)
    end
}

puts solve_part1(bag_parents)
puts solve_part2(bag_defs)
