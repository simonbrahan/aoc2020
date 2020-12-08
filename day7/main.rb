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

bag_parents = Hash.new { |h, k| h[k] = [] }
File.foreach("input.txt") { |line|
    bag_def = line.chomp.split(" ")
    parent_bag = bag_def[0..1].join(" ")
    contents_def = parse_contents(bag_def[4..].join(" "))
    for bag in contents_def
        bag_parents[bag[:name]].push(parent_bag)
    end
}

bags_containing_target = Set.new

bags_to_check = ["shiny gold"]
while !bags_to_check.empty?
    bag_to_check = bags_to_check.shift
    checked_bag_parents = bag_parents[bag_to_check]
    bags_containing_target = bags_containing_target.merge(checked_bag_parents)
    bags_to_check.concat(checked_bag_parents)
end

puts bags_containing_target.length
