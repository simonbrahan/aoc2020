use std::fs::File;
use std::io::{BufRead, BufReader, Error, ErrorKind, Read};

fn main() -> Result<(), Error> {
    let input = read_input(File::open("input.txt")?)?;
    println!("{}", solve(input));
    Ok(())
}

fn solve(mut input: Vec<usize>) -> usize {
    input.sort_unstable();

    let mut low_idx = 0;
    let mut high_idx = input.len() - 1;

    while input[low_idx] + input[high_idx] != 2020 {
        if input[low_idx] + input[high_idx] < 2020 {
            low_idx += 1;
        } else {
            high_idx -= 1;
        }
    }

    input[low_idx] * input[high_idx]
}

fn read_input<R: Read>(io: R) -> Result<Vec<usize>, Error> {
    let br = BufReader::new(io);
    br.lines()
        .map(|line| line.and_then(|v| v.parse().map_err(|e| Error::new(ErrorKind::InvalidData, e))))
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let input = vec![1721, 979, 366, 299, 675, 1456];

        assert_eq!(514579, solve(input));
    }
}
