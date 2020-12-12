use itertools::Itertools;
use literally::hset;
use std::collections::HashSet;
use std::io;
use std::io::prelude::*;

fn main() {
    let stdin = io::stdin();
    let passports = stdin
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .group_by(|l| l.trim().is_empty());

    let result = &passports
        .into_iter()
        .step_by(2)
        .map(|(_k, g)| {
            g.map(|s| s.split_whitespace().map(str::to_owned).collect_vec())
                .flatten()
                .map(|f| f.split(':').map(str::to_owned).next().unwrap())
                .collect::<HashSet<String>>()
        })
        .filter(|pfields| {
            pfields.is_superset(&hset! { "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" })
        })
        .count();

    println!("{:?}", result)
}
