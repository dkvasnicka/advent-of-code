#![feature(iterator_fold_self)]
#![feature(test)]

extern crate test;

#[derive(Debug)]
struct Slope {
    right: usize,
    down: usize,
    offset: usize,
}

#[cfg(test)]
mod tests {
    use super::*;
    use packed_simd::*;
    use std::io;
    use std::io::prelude::*;
    use std::ops::Add;
    use test::Bencher;

    #[bench]
    fn benchmark(b: &mut Bencher) {
        let stdin = io::stdin();
        let input: Vec<String> = stdin
            .lock()
            .lines()
            .skip(1)
            .map(|line| line.unwrap())
            .collect();

        b.iter(|| {
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

            let sums = input
                .iter()
                .enumerate()
                .scan(slopes, |ss, (idx, l)| {
                    let increments: Vec<u32> = ss
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

                    Some(u32x4::from_slice_aligned(increments.as_slice()))
                })
                .fold_first(u32x4::add)
                .unwrap();

            // Constant obtained by running part1.rs
            let result = sums.wrapping_product() as u64 * 228;

            assert!(result == 6818112000);
        });
    }
}

fn main() {}
