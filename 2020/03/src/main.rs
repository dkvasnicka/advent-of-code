use std::io;
use std::io::prelude::*;

fn main() {
    let stdin = io::stdin();
    let count = stdin
        .lock()
        .lines()
        .skip(1)
        .map(|line| line.unwrap().chars().collect::<Vec<char>>())
        .fold((0, 0), |(pos, cnt), l| {
            let new_pos = (pos + 3) % l.len();
            (
                new_pos,
                cnt + match l[new_pos] {
                    '#' => 1,
                    '.' => 0,
                    _ => panic!(),
                },
            )
        });

    println!("{:?}", count)
}
