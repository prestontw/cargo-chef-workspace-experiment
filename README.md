Trying to see if directory structures with different folders besides `src` work with cargo chef

## To build
```
docker build -t workspace-experiment .
```

### Will this work?
No! This will raise the error message:
```
 => ERROR [builder 2/6] RUN cargo chef cook --release --recipe-path recipe.json                                                                                                                        1.2s
------
 > [builder 2/6] RUN cargo chef cook --release --recipe-path recipe.json:
#15 1.136 error: failed to load manifest for workspace member `/app/ci`
#15 1.136
#15 1.136 Caused by:
#15 1.136   failed to read `/app/ci/Cargo.toml`
#15 1.136
#15 1.136 Caused by:
#15 1.137   No such file or directory (os error 2)
#15 1.141 thread 'main' panicked at 'Exited with status code: 101', /usr/local/cargo/registry/src/github.com-1ecc6299db9ec823/cargo-chef-0.1.31/src/recipe.rs:145:27
#15 1.141 note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
------
```
To fix this, uncomment the perl lines in the two Docker steps.
