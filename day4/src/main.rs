use std::collections::HashSet;
use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error + 'static>> {
    let input = fs::read_to_string("input.txt")?;

    println!("{}", solve_part1(&input));

    println!("{}", solve_part2(&input));

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

fn solve_part2(input: &str) -> usize {
    let mut out = 0;

    for passport in input.split("\n\n") {
        if passport_contains_required_fields(&passport) &&
            passport_fields_valid(&passport) {
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

fn passport_fields_valid(passport: &str) -> bool {
    for part in passport.split_whitespace() {
        let mut split_part = part.split(':');
        let part_label = split_part.next().unwrap();
        let part_value = split_part.next().unwrap();

        let part_valid = match part_label {
            "byr" => birth_year_valid(part_value),
            "iyr" => issue_year_valid(part_value),
            "eyr" => expiration_year_valid(part_value),
            "hgt" => height_valid(part_value),
            "hcl" => hair_colour_valid(part_value),
            "ecl" => eye_colour_valid(part_value),
            "pid" => pid_valid(part_value),
            // No validation for other fields
            _ => true
        };

        if !part_valid {
            return false;
        }
    }

    true
}

fn birth_year_valid(input: &str) -> bool {
    year_between(input, 1920, 2002)
}

fn issue_year_valid(input: &str) -> bool {
    year_between(input, 2010, 2020)
}

fn expiration_year_valid(input: &str) -> bool {
    year_between(input, 2020, 2030)
}

fn year_between(input: &str, from: usize, to: usize) -> bool {
    if input.len() != 4 {
        return false;
    }

    if let Ok(year) = input.parse::<usize>() {
        return year >= from && year <= to;
    }

    false
}

fn height_valid(input: &str) -> bool {
    if let Some(height_str) = input.strip_suffix("cm") {
        if let Ok(height) = height_str.parse::<usize>() {
            return height >= 150 && height <= 193;
        }
    }

    if let Some(height_str) = input.strip_suffix("in") {
        if let Ok(height) = height_str.parse::<usize>() {
            return height >= 59 && height <= 76;
        }
    }

    false
}

fn hair_colour_valid(input: &str) -> bool {
    if let Some(hex_str) = input.strip_prefix("#") {
        if hex_str.len() != 6 {
            return false;
        }

        return hex_str.chars().all(|c| {
            vec![
                'a', 'b', 'c', 'd', 'e', 'f', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
            ]
            .contains(&c)
        });
    }

    false
}

fn eye_colour_valid(input: &str) -> bool {
    vec!["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(&input)
}

fn pid_valid(input: &str) -> bool {
    if input.len() != 9 {
        return false;
    }

    if let Ok(as_num) = input.parse::<usize>() {
        return as_num <= 999999999;
    }

    false
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_birth_year_valid() {
        assert!(!birth_year_valid("920"));
        assert!(!birth_year_valid("19920"));

        assert!(!birth_year_valid("1919"));
        assert!(birth_year_valid("1920"));
        assert!(birth_year_valid("2002"));
        assert!(!birth_year_valid("2003"));
    }

    #[test]
    fn test_issue_year_valid() {
        assert!(!issue_year_valid("920"));
        assert!(!issue_year_valid("19920"));

        assert!(!issue_year_valid("2009"));
        assert!(issue_year_valid("2010"));
        assert!(issue_year_valid("2020"));
        assert!(!issue_year_valid("2021"));
    }

    #[test]
    fn text_expiration_year_valid() {
        assert!(!expiration_year_valid("920"));
        assert!(!expiration_year_valid("19920"));

        assert!(!expiration_year_valid("2019"));
        assert!(expiration_year_valid("2020"));
        assert!(expiration_year_valid("2030"));
        assert!(!expiration_year_valid("2031"));
    }

    #[test]
    fn test_height_valid() {
        assert!(!height_valid("1"));
        assert!(!height_valid("cm"));
        assert!(!height_valid("70cm"));
        assert!(!height_valid("150in"));

        assert!(!height_valid("149cm"));
        assert!(height_valid("150cm"));
        assert!(height_valid("193cm"));
        assert!(!height_valid("194cm"));

        assert!(!height_valid("58in"));
        assert!(height_valid("59in"));
        assert!(height_valid("76in"));
        assert!(!height_valid("77in"));
    }

    #[test]
    fn test_hair_colour_valid() {
        assert!(!hair_colour_valid("123abc"));
        assert!(!hair_colour_valid("23abc"));
        assert!(!hair_colour_valid("#123abz"));
        assert!(hair_colour_valid("#123abc"));
    }

    #[test]
    fn test_eye_colour_valid() {
        assert!(eye_colour_valid("amb"));
        assert!(!eye_colour_valid("fake"));
    }

    #[test]
    fn test_pid_valid() {
        assert!(pid_valid("000000001"));
        assert!(pid_valid("999999999"));
        assert!(!pid_valid("0000000001"));
        assert!(!pid_valid("a99999999"));
    }
}
