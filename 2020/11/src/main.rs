#![feature(iterator_fold_self)]
#![feature(control_flow_enum)]
use itertools::Itertools;
use ndarray::Array;
use ndarray::{Array2, Zip};
use std::{io::*, iter::successors, ops::ControlFlow};

const TEST_PLAN_SIZE: (usize, usize) = (10, 10);

#[derive(Debug, PartialEq, Clone)]
enum Cell {
    Empty,
    Occupied,
    Floor,
}

trait SeatingPlan {
    fn evolve(self) -> Self;
}

impl SeatingPlan for Array2<Cell> {
    fn evolve(self) -> Self {
        Zip::indexed(&self).apply_collect(|(x, y), e| {
            let occupied_around = (-1..=1)
                .cartesian_product(-1..=1)
                .filter(|(dx, dy)| !(*dx == 0 && *dy == 0))
                .map(|(dx, dy)| (x as i16 + dx, y as i16 + dy))
                .filter(|(sx, sy)| match self.get((*sx as usize, *sy as usize)) {
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
        })
    }
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

    let mut evolution = successors(Some(ary), |a| Some(a.clone().evolve()));
    let stabilized = evolution.try_fold(Array::from_elem(TEST_PLAN_SIZE, Cell::Empty), |acc, e| {
        if acc == e {
            return ControlFlow::Break(e);
        }

        ControlFlow::Continue(e)
    });
    println!(
        "{:?}",
        stabilized
            .break_value()
            .unwrap()
            .iter()
            .filter(|&s| s == &Cell::Occupied)
            .count()
    );
}
