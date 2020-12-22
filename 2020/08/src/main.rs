#![feature(iterator_fold_self)]
use itertools::Itertools;
use std::result::Result;
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

struct Console {
    accumulator: i16,
    visited: HashSet<i16>,
    next: i16,
    tape: Vec<Instr>,
}

impl Console {
    pub fn new(tape: Vec<Instr>) -> Self {
        Console {
            accumulator: 0,
            visited: HashSet::new(),
            next: 0,
            tape,
        }
    }

    pub fn run(&mut self) -> Result<i16, i16> {
        while !self.visited.contains(&self.next) {
            self.visited.insert(self.next);
            match self.tape[self.next as usize] {
                Instr::Nop => {
                    self.next = self.next + 1;
                }
                Instr::Acc(arg) => {
                    self.accumulator = self.accumulator + arg;
                    self.next = self.next + 1;
                }
                Instr::Jmp(arg) => {
                    self.next = self.next + arg;
                }
            }
        }

        Err(self.accumulator)
    }
}

fn main() {
    let stdin = stdin();
    let tape = stdin
        .lock()
        .lines()
        .map(|l| Instr::from(&l.unwrap()))
        .collect_vec();

    let mut console = Console::new(tape);
    let result = console.run();

    println!("{:?}", result.expect_err("Console was supposed to loop."))
}
