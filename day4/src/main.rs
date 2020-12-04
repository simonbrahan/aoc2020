use std::collections::HashSet;
use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error + 'static>> {
    let input = fs::read_to_string("input.txt")?;

    println!("{}", solve_part1(&input));

    Ok(())
}

fn solve_part1(input: &str) -> usize {
    let mut out = 0;

    let required_parts: HashSet<&str> = vec!["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        .into_iter()
        .collect();

    for passport in input.split("\n\n") {
        let provided_parts: HashSet<&str> = passport
            .split_whitespace()
            .map(|part| part.split(':').next().unwrap())
            .collect();

        if required_parts.is_subset(&provided_parts) {
            out += 1;
        }
    }

    out
}
