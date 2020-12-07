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
            let chars = pwd.chars().collect::<Vec<char>>();
            let letter_char = letter.chars().next().unwrap();
            (chars[*lower - 1] == letter_char) ^ (chars[*upper - 1] == letter_char)
        })
        .count();

    println!("{}", cnt2)
}
