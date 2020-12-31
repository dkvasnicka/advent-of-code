#![feature(iterator_fold_self)]
use itertools::Itertools;
use std::io::*;
use std::ops::Mul;

struct Counter(usize);

impl Default for Counter {
    fn default() -> Self {
        Counter(0)
    }
}

impl<'a> Extend<&'a u8> for Counter {
    fn extend<T: IntoIterator<Item = &'a u8>>(&mut self, iter: T) {
        self.0 += iter.into_iter().count();
    }
}

impl Mul for Counter {
    type Output = usize;

    fn mul(self, rhs: Self) -> Self::Output {
        self.0 * rhs.0
    }
}

struct Tribonacci(Vec<u64>);

impl Iterator for Tribonacci {
    type Item = u64;

    fn next(&mut self) -> Option<Self::Item> {
        let val = match self.0.len() {
            1 => 1,
            _ => self.0.iter().rev().take(3).sum(),
        };
        self.0.push(val);
        Some(val)
    }

    fn nth(&mut self, n: usize) -> Option<Self::Item> {
        self.0
            .get(n)
            .map(|x| x.to_owned())
            .or_else(|| self.take(n + 1).last())
    }
}

impl Default for Tribonacci {
    fn default() -> Self {
        Tribonacci(Vec::new())
    }
}

fn main() {
    let stdin = stdin();
    let mut nums = stdin
        .lock()
        .lines()
        .map(|l| l.unwrap().trim().parse::<u8>().unwrap())
        .chain(0..1)
        .collect_vec();
    nums.sort();
    let max_joltage = nums.last().unwrap().to_owned();
    nums.push(max_joltage + 3);

    let (head, tail) = nums.split_first().unwrap();
    let diffs: Vec<u8> = tail
        .iter()
        .scan(head, |state, n| {
            let diff = n - *state;
            *state = n;
            match diff {
                1 | 3 => Some(diff),
                _ => None,
            }
        })
        .collect();
    let (ones, threes): (Counter, Counter) = diffs.iter().partition(|diff| *diff == &1);

    println!("Part 1: {:?}", ones * threes);

    let one_runs = diffs.iter().group_by(|d| d.to_owned());
    let mut tribbo = Tribonacci::default();
    let result2: u64 = one_runs
        .into_iter()
        .filter_map(|(k, grp)| match k {
            1 => {
                let size = grp.into_iter().count();
                match size {
                    s if s > 1 => tribbo.nth(s + 1),
                    _ => None,
                }
            }
            _ => None,
        })
        .product();

    println!("Part 2: {:?}", result2);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_tribonacci_nth() {
        let mut tseq = Tribonacci::default();
        assert_eq!(tseq.nth(5), Some(7));
    }

    #[test]
    fn test_tribonacci_seq() {
        let tseq = Tribonacci::default();
        assert_eq!(
            tseq.take(10).collect_vec(),
            vec![0, 1, 1, 2, 4, 7, 13, 24, 44, 81]
        );
    }
}
