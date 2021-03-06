#![feature(iterator_fold_self)]
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
            g.map(|s| s.chars().collect::<HashSet<char>>())
                .fold_first(|l, r| l.intersection(&r).map(char::to_owned).collect())
                .unwrap()
                .len()
        })
        .sum();

    println!("{:?}", result)
}
