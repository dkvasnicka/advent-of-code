#![feature(iterator_fold_self)]
use itertools::Itertools;
use std::io::*;

fn main() {
    let stdin = stdin();
    let nums = stdin
        .lock()
        .lines()
        .map(|l| l.unwrap().trim().parse::<i64>().unwrap())
        .collect_vec();
    let nums_slice = nums.as_slice();

    let result = nums_slice.windows(26).find_map(|win| {
        let (last, previous) = win.split_last().unwrap();
        if previous
            .iter()
            .combinations(2)
            .any(|c| c[0] + c[1] == *last)
        {
            None
        } else {
            Some(last)
        }
    });

    println!("{:?}", result.unwrap());
}
