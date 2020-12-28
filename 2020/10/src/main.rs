#![feature(iterator_fold_self)]
use itertools::Itertools;
use petgraph::algo::all_simple_paths;
use petgraph::prelude::*;
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
    let max_joltage = nums.last().unwrap().to_owned();
    nums.push(max_joltage + 3);
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

    nums.append(&mut vec![255, 255, 255, 255]);
    let edges = nums
        .as_slice()
        .windows(4)
        .map(|w| {
            let (head, tail) = w.split_first().unwrap();
            tail.iter().filter_map(move |n| match n - head {
                1..=3 => Some((head.to_owned(), n.to_owned())),
                _ => None,
            })
        })
        .flatten();

    let graph = DiGraph::<(), (), u8>::from_edges(edges);
    let paths =
        all_simple_paths::<Vec<NodeIndex<u8>>, _>(&graph, 0u8.into(), max_joltage.into(), 1, None);

    println!("Part 2: {:?}", paths.count());
}
