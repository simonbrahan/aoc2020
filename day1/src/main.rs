use std::fs::File;
use std::io::{BufRead, BufReader, Error, ErrorKind, Read};

fn main() -> Result<(), Error> {
    let input = read_input(File::open("input.txt")?)?;
    println!("{}", solve_part1(input.clone()));
    println!("{}", solve_part2(input));
    Ok(())
}

fn solve_part1(mut input: Vec<usize>) -> usize {
    input.sort_unstable();
    product_of_summing_double(&input, 2020).expect("No pair of inputs sums to 2020")
}

fn solve_part2(mut input: Vec<usize>) -> usize {
    input.sort_unstable();

    for (idx, num) in input.iter().enumerate() {
        match product_of_summing_double(&input[idx..], 2020 - num) {
            Some(sum_of_double) => return sum_of_double * num,
            None => continue
        }
    }

    panic!("No triplet of inputs sums to 2020");
}

fn product_of_summing_double(input: &[usize], sum: usize) -> Option<usize> {
    let mut low_idx = 0;
    let mut high_idx = input.len() - 1;

    while input[low_idx] + input[high_idx] != sum {
        if input[low_idx] + input[high_idx] < sum {
            low_idx += 1;
        } else {
            high_idx -= 1;
        }

        if low_idx >= high_idx {
            return None;
        }
    }

    Some(input[low_idx] * input[high_idx])
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
    fn test_solve_part1() {
        let input = vec![1721, 979, 366, 299, 675, 1456];

        assert_eq!(514579, solve_part1(input));
    }

    #[test]
    fn test_solve_part2() {
        let input = vec![1721, 979, 366, 299, 675, 1456];

        assert_eq!(241861950, solve_part2(input));
    }
}
