#[macro_use]
extern crate lazy_static;

use regex::Regex;
use std::io;
use std::io::prelude::*;

lazy_static! {
    static ref RE: Regex =
        Regex::new(r"(?P<lower>\d+)-(?P<upper>\d+) (?P<letter>[a-z]{1}): (?P<password>[a-z]+)")
            .unwrap();
}

fn main() {
    let stdin = io::stdin();
    let nums = stdin
        .lock()
        .lines()
        .map(|line| {
            let line_str = line.unwrap();
            let parsed = RE.captures(line_str.as_str()).unwrap();
            (
                parsed["lower"].parse::<usize>().unwrap(),
                parsed["upper"].parse::<usize>().unwrap(),
                parsed["letter"].to_string(),
                parsed["password"].to_string(),
            )
        })
        .collect::<Vec<(usize, usize, String, String)>>();

    let cnt = nums
        .iter()
        .filter(|(lower, upper, letter, pwd)| {
            let letter_count = pwd.matches(letter).count();
            (*lower..upper + 1).contains(&letter_count)
        })
        .count();

    println!("{}", cnt);

    let cnt2 = nums
        .iter()
        .filter(|(lower, upper, letter, pwd)| {
            let idxs = pwd
                .match_indices(letter)
                .map(|p| p.0 + 1)
                .collect::<Vec<usize>>();
            idxs.contains(lower) ^ idxs.contains(upper)
        })
        .count();

    println!("{}", cnt2)
}
