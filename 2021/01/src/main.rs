#![feature(bool_to_option)]
use itertools::Itertools;
use std::io;
use std::io::prelude::*;

fn main() {
    let stdin = io::stdin();
    let nums = stdin
        .lock()
        .lines()
        .map(|line| line.unwrap().trim().parse::<i32>().unwrap())
        .collect_vec();

    let win_size = 3;
    // let win_size = 1;

    println!(
        "{:?}",
        nums.windows(win_size)
            .map(|w| w.iter().sum::<i32>())
            .tuple_windows()
            .filter_map(|(l, r)| (r > l).then_some(1))
            .sum::<i32>()
    );
}
