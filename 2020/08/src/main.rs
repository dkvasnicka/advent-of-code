#![feature(iterator_fold_self)]
use itertools::Itertools;
use std::{collections::HashSet, io::*};

#[derive(Debug)]
enum Instr {
    Acc(i16),
    Jmp(i16),
    Nop,
}

impl From<&String> for Instr {
    fn from(line: &String) -> Self {
        let parsed = line.split_whitespace().collect_vec();
        let arg = parsed[1].trim().parse().unwrap();

        match parsed[0] {
            "acc" => Instr::Acc(arg),
            "jmp" => Instr::Jmp(arg),
            "nop" => Instr::Nop,
            _ => panic!(),
        }
    }
}

fn main() {
    let stdin = stdin();
    let tape = stdin
        .lock()
        .lines()
        .map(|l| Instr::from(&l.unwrap()))
        .collect_vec();

    let mut accumulator = 0;
    let mut visited: HashSet<i16> = HashSet::new();
    let mut next: i16 = 0;

    while !visited.contains(&next) {
        visited.insert(next);
        match tape[next as usize] {
            Instr::Nop => {
                next = next + 1;
            }
            Instr::Acc(arg) => {
                accumulator = accumulator + arg;
                next = next + 1;
            }
            Instr::Jmp(arg) => {
                next = next + arg;
            }
        }
    }

    println!("{:?}", accumulator)
}
