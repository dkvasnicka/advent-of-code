use anyhow::Result;
use itertools::Itertools;
use std::io;
use std::io::prelude::*;

fn main() -> Result<()> {
    let stdin = io::stdin();
    let nums = stdin.lock().lines().filter_map(|line| {
        let digits = line.ok()?.chars().filter(|c| c.is_digit(10)).collect_vec();

        digits.first().and_then(|d1| {
            digits.last().and_then(|d2| {
                let mut s = String::from(*d1);
                s.push(*d2);
                s.parse::<i32>().ok()
            })
        })
    });

    println!("{:?}", nums.sum::<i32>());
    Ok(())
}
