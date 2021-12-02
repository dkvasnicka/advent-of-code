#![feature(bool_to_option)]
use itertools::Itertools;
use std::io;
use std::io::prelude::*;

fn main() {
    let stdin = io::stdin();
    let nums = stdin
        .lock()
        .lines()
        .map(|line| line.unwrap().trim().parse::<i32>().unwrap());

    println!(
        "{}",
        nums.tuple_windows()
            .filter_map(|(l, r)| (r > l).then_some(1))
            .sum::<i32>()
    );
}
