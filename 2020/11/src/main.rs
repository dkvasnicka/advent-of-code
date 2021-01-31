#![feature(iterator_fold_self)]
use itertools::Itertools;
use ndarray::Zip;
use ndarray::{s, Array};
use std::io::*;

const TEST_PLAN_SIZE: (usize, usize) = (10, 10);

#[derive(Debug, PartialEq)]
enum Cell {
    Empty,
    Occupied,
    Floor,
}

fn main() {
    let stdin = stdin();
    let game_data = stdin
        .lock()
        .bytes()
        .filter_map(|c| match c.unwrap() {
            b'.' => Some(Cell::Floor),
            b'L' => Some(Cell::Empty),
            _ => None,
        })
        .collect_vec();

    let ary = Array::from_shape_vec(TEST_PLAN_SIZE, game_data).unwrap();

    let b = Zip::indexed(&ary).apply_collect(|(x, y), e| {
        let occupied_around = (-1..=1)
            .cartesian_product(-1..=1)
            .filter(|(dx, dy)| !(*dx == 0 && *dy == 0))
            .map(|(dx, dy)| (x as i16 + dx, y as i16 + dy))
            .filter(|(sx, sy)| match ary.get((*sx as usize, *sy as usize)) {
                None => false,
                Some(cell) => *cell == Cell::Occupied,
            })
            .count();

        match e {
            Cell::Empty => match occupied_around {
                0 => Cell::Occupied,
                _ => Cell::Empty,
            },
            Cell::Occupied => match occupied_around {
                x if x >= 4 => Cell::Empty,
                _ => Cell::Occupied,
            },
            _ => Cell::Floor,
        }
    });
    println!("{:?}", b);
}
