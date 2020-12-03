use std::collections::HashSet;

type Point = (usize, usize);

struct Slope {
    trees: HashSet<Point>,
    length: usize,
    repeat_at: usize
}

impl Slope {
    fn past_end(&self, pos: &Point) -> bool {
        pos.1 > self.length
    }

    fn is_tree(&self, pos: &Point) -> bool {
        let patterned_pos = (pos.0 % self.repeat_at, pos.1);
        self.trees.contains(&patterned_pos)
    }
}

fn main() {
    println!("Hello, world!");
}

fn solve_part1(slope: Slope, speed_right: usize, speed_down: usize) -> usize {
    let mut pos = (0, 0);
    let mut out = 0;

    while !slope.past_end(&pos) {
        if slope.is_tree(&pos) {
            out += 1;
        }

        pos.0 += speed_right;
        pos.1 += speed_down;
    }

    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve_part1() {
        let input = Slope {
            trees: vec![
                (2, 0),
                (3, 0),
                (0, 1),
                (4, 1),
                (8, 1),
                (1, 2),
                (6, 2),
                (9, 2),
                (2, 3),
                (4, 3),
                (8, 3),
                (10, 3),
                (1, 4),
                (5, 4),
                (6, 4),
                (9, 4),
                (2, 5),
                (4, 5),
                (5, 5),
                (1, 6),
                (3, 6),
                (5, 6),
                (10, 6),
                (1, 7),
                (10, 7),
                (0, 8),
                (2, 8),
                (3, 8),
                (7, 8),
                (0, 9),
                (4, 9),
                (5, 9),
                (10, 9),
                (1, 10),
                (4, 10),
                (8, 10),
                (10, 10),
            ]
            .into_iter()
            .collect(),
            length: 11,
            repeat_at: 11
        };

        assert_eq!(7, solve_part1(input, 3, 1));
    }
}
