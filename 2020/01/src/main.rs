use std::collections::BTreeSet;
use std::io;
use std::io::prelude::*;

fn decompose(tree: &BTreeSet<i32>, start: i32, level: i8) -> Option<i32> {
    return tree.iter().find_map(|expense| {
        let counterpart = start - expense;
        if level == 0 {
            tree.get(&counterpart).map(|i| i.to_owned())
        } else {
            decompose(tree, counterpart, level - 1)
        }
        .map(|i| expense * i)
    });
}

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

    let product_p1 = decompose(&tree, 2020, 0);
    println!("{}", product_p1.unwrap());

    let product_p2 = decompose(&tree, 2020, 1);
    println!("{}", product_p2.unwrap())
}
