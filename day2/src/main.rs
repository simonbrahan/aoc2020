use std::fs::File;
use std::io::{BufRead, BufReader, Error, ErrorKind, Read};

type PasswordDeclaration<'a> = (usize, usize, char, &'a str);

fn main() -> Result<(), Error> {
    println!("{}", solve_part1(read_input()?));
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

fn read_input() -> Result<Vec<PasswordDeclaration<'static>>, Error> {
    Ok(vec![
        (1, 3, 'a', "abcde"),
        (1, 3, 'b', "cdefg"),
        (2, 9, 'c', "ccccccccc")
    ])
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve_part1() {
        let input = vec![
            (1, 3, 'a', "abcde"),
            (1, 3, 'b', "cdefg"),
            (2, 9, 'c', "ccccccccc")
        ];

        assert_eq!(2, solve_part1(input));
    }
}
