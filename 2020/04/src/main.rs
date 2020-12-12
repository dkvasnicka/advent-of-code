use itertools::Itertools;
use lazy_static::*;
use regex::Regex;
use std::io::*;
use std::{collections::HashMap, iter::FromIterator};
use validator::Validate;

lazy_static! {
    static ref HGT_PATTERN: Regex =
        Regex::new(r"^(1[5-8][0-9]|19[0-3])cm|(59|6[0-9]|7[0-6])in$").unwrap();
    static ref HCL_PATTERN: Regex = Regex::new(r"^#[0-9a-f]{6}$").unwrap();
    static ref ECL_PATTERN: Regex = Regex::new(r"^amb|blu|brn|gry|grn|hzl|oth$").unwrap();
    static ref PID_PATTERN: Regex = Regex::new(r"^\d{9}$").unwrap();
}

#[derive(Debug, Validate)]
struct Password {
    #[validate(range(min = 1920, max = 2002))]
    byr: u16,
    #[validate(range(min = 2010, max = 2020))]
    iyr: u16,
    #[validate(range(min = 2020, max = 2030))]
    eyr: u16,
    #[validate(regex = "HGT_PATTERN")]
    hgt: String,
    #[validate(regex = "HCL_PATTERN")]
    hcl: String,
    #[validate(regex = "ECL_PATTERN")]
    ecl: String,
    #[validate(regex = "PID_PATTERN")]
    pid: String,
}

impl FromIterator<(String, String)> for Password {
    fn from_iter<T: IntoIterator<Item = (String, String)>>(iter: T) -> Self {
        let ref __ = "".to_owned();
        let data = iter.into_iter().collect::<HashMap<String, String>>();

        Password {
            byr: data.get("byr").unwrap_or(__).parse().unwrap_or(0),
            iyr: data.get("iyr").unwrap_or(__).parse().unwrap_or(0),
            eyr: data.get("eyr").unwrap_or(__).parse().unwrap_or(0),
            hgt: data.get("hgt").unwrap_or(__).to_owned(),
            hcl: data.get("hcl").unwrap_or(__).to_owned(),
            ecl: data.get("ecl").unwrap_or(__).to_owned(),
            pid: data.get("pid").unwrap_or(__).to_owned(),
        }
    }
}

fn main() {
    let stdin = stdin();
    let passports = stdin
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .group_by(|l| l.trim().is_empty());

    let result = &passports
        .into_iter()
        .step_by(2)
        .map(|(_k, g)| {
            g.map(|s| s.split_whitespace().map(str::to_owned).collect_vec())
                .flatten()
                .map(|f| f.split(':').map(str::to_owned).collect_tuple().unwrap())
                .collect::<Password>()
        })
        .filter_map(|pwd| pwd.validate().map(|_| pwd).ok())
        .count();

    println!("{:?}", result)
}
