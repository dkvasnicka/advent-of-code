Advent of Code 2021
=====

Docker setup
---
* `docker build . -t aoc2021`
* `docker run -it -v $PWD:/aoc aoc2021`

Rust dev
---
```
reflex -g 'src/*.rs' -d none -- sh -c "echo \"---------------\" && cargo r < `basename $PWD`.txt"
```

Use `cargo bench` for challenges that are implemented as benchmarks.

Racket dev
---

Use 2018 Reflex config file: `reflex -c ../../2018/.reflex`
