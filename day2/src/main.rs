use std::fs::File;
use std::io::{BufRead, BufReader, Error};

type PasswordDeclaration = (usize, usize, char, String);

fn main() -> Result<(), Error> {
    println!("{}", solve_part1(read_input()?));
    println!("{}", solve_part2(read_input()?));
    Ok(())
}

fn solve_part1(input: Vec<PasswordDeclaration>) -> usize {
    let mut out = 0;

    for (min, max, find, candidate) in input {
        let matched_chars = candidate.matches(find).count();
        if matched_chars >= min && matched_chars <= max {
            out += 1;
        }
    }

    out
}

fn solve_part2(input: Vec<PasswordDeclaration>) -> usize {
    let mut out = 0;

    for (pos1, pos2, find, candidate) in input {
        let pos1_matches = candidate.chars().nth(pos1 - 1).map_or(false, |c| c == find);
        let pos2_matches = candidate.chars().nth(pos2 - 1).map_or(false, |c| c == find);

        if pos1_matches ^ pos2_matches {
            out += 1;
        }
    }

    out
}

fn read_input() -> Result<Vec<PasswordDeclaration>, Error> {
    let input = File::open("input.txt")?;
    let br = BufReader::new(input);

    let mut out = vec![];
    for line in br.lines() {
        if let Ok(entry) = line {
            let parts: Vec<&str> = entry.split(' ').collect();

            let bounds: Vec<usize> = parts[0]
                .split('-')
                .map(|num| num.parse::<usize>().expect("bounds should be integers"))
                .collect();
            let min = bounds[0];
            let max = bounds[1];

            let find = parts[1].chars().next().unwrap();

            let candidate = parts[2].to_string();

            out.push((min, max, find, candidate));
        }
    }

    Ok(out)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve_part1() {
        let input = vec![
            (1, 3, 'a', "abcde".to_string()),
            (1, 3, 'b', "cdefg".to_string()),
            (2, 9, 'c', "ccccccccc".to_string()),
        ];

        assert_eq!(2, solve_part1(input));
    }

    #[test]
    fn test_solve_part2() {
        let input = vec![
            (1, 3, 'a', "abcde".to_string()),
            (1, 3, 'b', "cdefg".to_string()),
            (2, 9, 'c', "ccccccccc".to_string()),
        ];

        assert_eq!(1, solve_part2(input));
    }
}
