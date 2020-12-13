use itertools::FoldWhile::{Continue, Done};
use itertools::Itertools;
use std::io::*;

fn main() {
    let stdin = stdin();
    let result = stdin
        .lock()
        .lines()
        .map(|seat_id| {
            seat_id
                .unwrap()
                .chars()
                .map(|c| match c {
                    'F' | 'L' => '0',
                    'B' | 'R' => '1',
                    _ => panic!(),
                })
                .collect::<String>()
        })
        .map(|seat_id| {
            let (row, column) = seat_id.split_at(7);
            u16::from_str_radix(&row, 2).unwrap() * 8 + u16::from_str_radix(&column, 2).unwrap()
        })
        .sorted()
        .fold_while(0, |acc, seat| {
            if seat - acc == 2 {
                Done(acc + 1)
            } else {
                Continue(seat)
            }
        });

    println!("{:?}", result.into_inner())
}
