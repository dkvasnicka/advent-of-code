use itertools::Itertools;
use std::{collections::HashSet, io::*};

fn main() {
    let stdin = stdin();
    let groups = stdin
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .group_by(|l| l.trim().is_empty());

    let result: &usize = &groups
        .into_iter()
        .step_by(2)
        .map(|(_k, g)| {
            g.map(|s| s.chars().collect_vec())
                .flatten()
                .collect::<HashSet<char>>()
                .len()
        })
        .sum();

    println!("{:?}", result)
}
