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

impl Extend<u8> for Counter {
    fn extend<T: IntoIterator<Item = u8>>(&mut self, iter: T) {
        self.0 += iter.into_iter().count();
    }
}

impl Mul for Counter {
    type Output = usize;

    fn mul(self, rhs: Self) -> Self::Output {
        self.0 * rhs.0
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
    nums.push(nums.last().unwrap() + 3);
    let (head, tail) = nums.split_first().unwrap();

    let (ones, threes): (Counter, Counter) = tail
        .iter()
        .scan(head, |state, n| {
            let diff = n - *state;
            *state = n;
            match diff {
                1 | 3 => Some(diff),
                _ => None,
            }
        })
        .partition(|diff| diff == &1);

    println!("Part 1: {:?}", ones * threes);
}
