use anyhow::Result;
use itertools::Itertools;
use std::io;
use std::io::prelude::*;

fn main() -> Result<()> {
    let stdin = io::stdin();
    let nums = stdin.lock().lines().filter_map(|line| {
        let digits = line
            .unwrap()
            .trim()
            .chars()
            .filter(|c| c.is_digit(10))
            .collect_vec();

        digits.first().and_then(|d1| {
            digits.last().map(|d2| {
                vec![d1, d2]
                    .iter()
                    .map(|x| x.to_owned())
                    .collect::<String>()
                    .parse::<i32>()
                    .unwrap()
            })
        })
    });

    println!("{:?}", nums.sum::<i32>());
    Ok(())
}
