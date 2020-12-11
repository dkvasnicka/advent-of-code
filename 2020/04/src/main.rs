use itertools::Itertools;
use lazy_static::*;
use regex::Regex;
use std::collections::HashMap;
use std::convert::TryFrom;
use std::io::*;
use std::result::Result;
use validator::{Validate, ValidationError, ValidationErrors};

lazy_static! {
    static ref HGT_PATTERN: Regex = Regex::new(r"(\d{2,3})(cm|in)").unwrap();
    static ref HCL_PATTERN: Regex = Regex::new(r"#[0-9a-f]{6}").unwrap();
    static ref ECL_PATTERN: Regex = Regex::new(r"amb|blu|brn|gry|grn|hzl|oth").unwrap();
    static ref PID_PATTERN: Regex = Regex::new(r"\d{9}").unwrap();
}

#[derive(Debug, Validate)]
struct Password {
    #[validate(range(min = 1920, max = 2002))]
    byr: u16,
    #[validate(range(min = 2010, max = 2020))]
    iyr: u16,
    #[validate(range(min = 2020, max = 2030))]
    eyr: u16,
    #[validate(regex = "HGT_PATTERN", custom = "validate_height")]
    hgt: String,
    #[validate(regex = "HCL_PATTERN")]
    hcl: String,
    #[validate(regex = "ECL_PATTERN")]
    ecl: String,
    #[validate(regex = "PID_PATTERN")]
    pid: String,
}

impl TryFrom<HashMap<String, String>> for Password {
    fn try_from(value: HashMap<String, String>) -> Result<Self, Self::Error> {
        let ref __ = "".to_owned();

        let pwd = Password {
            byr: value.get("byr").unwrap_or(__).parse().unwrap_or(0),
            iyr: value.get("iyr").unwrap_or(__).parse().unwrap_or(0),
            eyr: value.get("eyr").unwrap_or(__).parse().unwrap_or(0),
            hgt: value.get("hgt").unwrap_or(__).to_owned(),
            hcl: value.get("hcl").unwrap_or(__).to_owned(),
            ecl: value.get("ecl").unwrap_or(__).to_owned(),
            pid: value.get("pid").unwrap_or(__).to_owned(),
        };

        pwd.validate().map(|_| pwd)
    }

    type Error = ValidationErrors;
}

fn prefix_to_u16(s: &str, len: usize) -> u16 {
    s.get(..len).unwrap_or(&"0").parse::<u16>().unwrap_or(0)
}

fn validate_height(hgt: &str) -> Result<(), ValidationError> {
    if hgt.ends_with("cm") {
        if (150..=193).contains(&prefix_to_u16(hgt, 3)) {
            return Ok(());
        }
    } else {
        if (59..=76).contains(&prefix_to_u16(hgt, 2)) {
            return Ok(());
        }
    };

    Err(ValidationError::new(""))
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
                .collect::<HashMap<String, String>>()
        })
        .filter_map(|field_map| Password::try_from(field_map).ok())
        .map(|pwd| {
            println!("{:?}", pwd);
            pwd
        })
        .count();

    println!("{:?}", result)
}
