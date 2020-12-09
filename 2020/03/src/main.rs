use std::io;
use std::io::prelude::*;

fn main() {
    let stdin = io::stdin();
    let count: u8 = stdin
        .lock()
        .lines()
        .skip(1)
        .map(|line| line.unwrap())
        .scan(0, |pos, l| {
            *pos = (*pos + 3) % l.len();
            Some(match l.get(*pos..*pos + 1).unwrap() {
                "#" => 1,
                "." => 0,
                _ => panic!(),
            })
        })
        .sum();

    println!("{:?}", count)
}
