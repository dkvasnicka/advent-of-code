use std::collections::BTreeSet;
use std::io;
use std::io::prelude::*;

fn main() {
    let stdin = io::stdin();
    let nums = stdin
        .lock()
        .lines()
        .map(|line| line.unwrap().trim().parse::<i32>().unwrap());

    let mut tree = BTreeSet::new();

    for n in nums {
        tree.insert(n);
    }

    for expense in &tree {
        let counterpart = 2020 - expense;
        if tree.contains(&counterpart) {
            println!("{}", expense * counterpart);
            break;
        }
    }
}
