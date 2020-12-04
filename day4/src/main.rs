use std::collections::HashSet;
use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error + 'static>> {
    let input = fs::read_to_string("input.txt")?;

    println!("{}", solve_part1(&input));

    Ok(())
}

fn solve_part1(input: &str) -> usize {
    let mut out = 0;

    for passport in input.split("\n\n") {
        if passport_contains_required_fields(&passport) {
            out += 1;
        }
    }

    out
}

fn passport_contains_required_fields(passport: &str) -> bool {
    let required_parts: HashSet<&str> = vec!["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        .into_iter()
        .collect();

    let provided_parts: HashSet<&str> = passport
        .split_whitespace()
        .map(|part| part.split(':').next().unwrap())
        .collect();

    required_parts.is_subset(&provided_parts)
}
