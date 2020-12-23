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
        previous
            .iter()
            .combinations(2)
            .map(|c| c[0] + c[1])
            .find(|s| s == last)
            .xor(Some(*last))
    });

    println!("Part 1: {:?}", result.unwrap());

    let result2 = (0..nums.len()).find_map(|start| {
        let mut sum: i64 = 0;
        let mut max: i64 = nums[start];
        let mut min: i64 = nums[start];
        for idx in start..nums.len() {
            sum += nums[idx];
            max = max.max(nums[idx]);
            min = min.min(nums[idx]);
            if sum == 2089807806i64 {
                return Some(min + max);
            }
        }

        None
    });

    println!("Part 2: {:?}", result2.unwrap());
}
