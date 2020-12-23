#![feature(iterator_fold_self)]
use itertools::Itertools;
use std::io::*;
use std::result::Result;

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

    let result2: Option<Result<(), i64>> = (0..nums.len()).find_map(|start| {
        (start..nums.len())
            .try_fold((0i64, nums[start], nums[start]), |(sum, min, max), idx| {
                let new_sum = sum + nums[idx];
                let new_min = min.min(nums[idx]);
                let new_max = max.max(nums[idx]);
                if new_sum == 2089807806i64 {
                    return Err(new_min + new_max);
                }
                Ok((new_sum, new_min, new_max))
            })
            .map(|_| None)
            .transpose()
    });

    println!("Part 2: {:?}", result2.unwrap().unwrap_err());
}
