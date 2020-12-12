use std::io::*;

fn main() {
    let stdin = stdin();
    let result = stdin
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .map(|seat_id| {
            let (row, column) = seat_id.split_at(7);
            (
                row.chars()
                    .map(|c| match c {
                        'F' => '0',
                        'B' => '1',
                        _ => panic!(),
                    })
                    .collect::<String>(),
                column
                    .chars()
                    .map(|c| match c {
                        'L' => '0',
                        'R' => '1',
                        _ => panic!(),
                    })
                    .collect::<String>(),
            )
        })
        .map(|(row, column)| {
            u16::from_str_radix(&row, 2).unwrap() * 8 + u16::from_str_radix(&column, 2).unwrap()
        })
        .max()
        .unwrap();

    println!("{:?}", result)
}
