use std::io;
use std::io::prelude::*;

fn is_triangle(sides: &Vec<i32>) -> bool {
    match sides[..3] {
        [first, second, third] => {
            (first + second > third) & (first + third > second) & (second + third > first)
        }
        _ => false,
    }
}

fn main() {
    let stdin = io::stdin();

    println!(
        "{}",
        stdin
            .lock()
            .lines()
            .map(|line| line
                .unwrap()
                .trim()
                .split_whitespace()
                .map(|s| s.parse::<i32>().unwrap())
                .collect::<Vec<i32>>())
            .filter(is_triangle)
            .count()
    );
}
