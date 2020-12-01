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

    let product = tree.iter().find_map(|expense| {
        let counterpart = 2020 - expense;
        if tree.contains(&counterpart) {
            Some(expense * counterpart)
        } else {
            None
        }
    });

    println!("{}", product.unwrap())
}
