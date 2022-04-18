Trying to see if directory structures with different folders besides `src` work with cargo chef

## To build
```
docker build -t workspace-experiment .
```

## Will this work?
No! This will raise the error message:
```
 => ERROR [builder 2/4] RUN cargo chef cook --release --recipe-path recipe.json                                                                                                                        1.1s
------
 > [builder 2/4] RUN cargo chef cook --release --recipe-path recipe.json:
#0 1.116 error: failed to load manifest for workspace member `/app/ci`
#0 1.116
#0 1.116 Caused by:
#0 1.116   failed to read `/app/ci/Cargo.toml`
#0 1.116
#0 1.116 Caused by:
#0 1.116   No such file or directory (os error 2)
#0 1.121 thread 'main' panicked at 'Exited with status code: 101', /usr/local/cargo/registry/src/github.com-1ecc6299db9ec823/cargo-chef-0.1.31/src/recipe.rs:145:27
#0 1.121 note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
------
```
To fix this, uncomment the perl line in the Docker `planner` step.
