#![feature(iterator_fold_self)]
use im::{OrdSet, Vector};
use itertools::Itertools;
use std::io::*;
use std::result::Result;

#[derive(Debug, Clone)]
enum Instr {
    Acc(i16),
    Jmp(i16),
    Nop(i16),
}

impl From<&String> for Instr {
    fn from(line: &String) -> Self {
        let parsed = line.split_whitespace().collect_vec();
        let arg = parsed[1].trim().parse().unwrap();

        match parsed[0] {
            "acc" => Instr::Acc(arg),
            "jmp" => Instr::Jmp(arg),
            "nop" => Instr::Nop(arg),
            _ => panic!(),
        }
    }
}

impl Instr {
    fn flip(&self) -> Self {
        match self {
            Self::Nop(arg) => Self::Jmp(*arg),
            Self::Jmp(arg) => Self::Nop(*arg),
            Self::Acc(_) => self.clone(),
        }
    }
}

#[derive(Debug, Clone)]
struct Console {
    accumulator: i16,
    visited: OrdSet<i16>,
    next: i16,
    tape: Vector<Instr>,
}

impl Console {
    pub fn new(tape: Vector<Instr>) -> Self {
        Console {
            accumulator: 0,
            visited: OrdSet::new(),
            next: 0,
            tape,
        }
    }

    pub fn mutations(&self) -> Mutations {
        Mutations {
            original_tape: &self.tape,
            last_index: -1,
        }
    }

    pub fn run(&mut self) -> Result<i16, i16> {
        while self.next < self.tape.len() as i16 {
            self.visited.insert(self.next);
            match self.tape[self.next as usize] {
                Instr::Nop(_) => {
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

            if self.visited.contains(&self.next) {
                return Err(self.accumulator);
            }
        }

        Ok(self.accumulator)
    }
}

struct Mutations<'a> {
    original_tape: &'a Vector<Instr>,
    last_index: i16,
}

impl<'a> Iterator for Mutations<'a> {
    type Item = Console;

    fn next(&mut self) -> Option<Self::Item> {
        let mut idx = (self.last_index + 1) as usize;
        let candidate = loop {
            match &self.original_tape[idx] {
                Instr::Acc(_) => (),
                c @ _ => {
                    self.last_index = idx as i16;
                    break c;
                }
            }
            idx += 1;
        };

        let new_tape = self
            .original_tape
            .update(self.last_index as usize, candidate.flip());

        Some(Console::new(new_tape))
    }
}

fn main() {
    let stdin = stdin();
    let tape = stdin
        .lock()
        .lines()
        .map(|l| Instr::from(&l.unwrap()))
        .collect::<Vector<Instr>>();

    // Part 1
    let mut console = Console::new(tape.clone());
    let result = console.run();

    println!("{:?}", result.expect_err("Console was supposed to loop."));

    // Part 2
    let initial_console = Console::new(tape);
    let result2 = initial_console
        .mutations()
        .find_map(|mut c| c.run().ok())
        .unwrap();

    println!("{:?}", result2);
}
