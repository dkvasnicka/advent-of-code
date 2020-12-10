Advent of Code 2020
=====

Docker setup
---
* `docker build . -t aoc2020`
* `docker run -it -v $PWD:/aoc aoc2020`

Rust dev
---
```
reflex -g 'src/*.rs' -d none -- sh -c "echo \"---------------\" && cargo r < `basename $PWD`.txt"
```

Use `cargo bench` for challenges that are implemented as benchmarks.
