#![feature(iterator_fold_self)]
use packed_simd::*;
use std::io;
use std::io::prelude::*;
use std::ops::Add;

#[derive(Debug)]
struct Slope {
    right: usize,
    down: usize,
    offset: usize,
}

fn main() {
    let slopes = vec![
        Slope {
            right: 1,
            down: 1,
            offset: 0,
        },
        Slope {
            right: 5,
            down: 1,
            offset: 0,
        },
        Slope {
            right: 7,
            down: 1,
            offset: 0,
        },
        Slope {
            right: 1,
            down: 2,
            offset: 0,
        },
    ];

    let stdin = io::stdin();
    let result = stdin
        .lock()
        .lines()
        .skip(1)
        .map(|line| line.unwrap())
        .enumerate()
        .scan(slopes, |ss, (idx, l)| {
            let increments: Vec<u8> = ss
                .iter_mut()
                .map(|slope| {
                    if (idx + 1).rem_euclid(slope.down) == 0 {
                        slope.offset = (slope.offset + slope.right) % l.len();
                        match l.get(slope.offset..slope.offset + 1).unwrap() {
                            "#" => 1,
                            "." => 0,
                            _ => panic!(),
                        }
                    } else {
                        0
                    }
                })
                .collect();

            Some(u8x4::from_slice_aligned(increments.as_slice()))
        })
        .fold_first(u8x4::add)
        .unwrap()
        .wrapping_product();

    println!("{:?}", result as u32 * 228)
}
