FROM rust:1.59.0 AS chef
RUN cargo install --git https://github.com/prestontw/cargo-chef.git --branch ptw/add-prepare-member-flag --rev 2b89e7e9edae486b70fa92e6ab04eaed4eba9a9a
WORKDIR app

FROM chef AS planner
COPY ./backend ./backend
COPY ./util ./util
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock
# RUN perl -0777 -i -pe 's/members = \[[^\]]+\]/members = ["backend"]/igs' Cargo.toml
RUN cargo chef prepare --recipe-path recipe.json --bin backend

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
# Build dependencies - this is the caching Docker layer!
RUN cargo chef cook --release --recipe-path recipe.json --bin backend
# Build application
COPY ./backend ./backend
COPY ./util ./util
RUN cargo build --release --bin backend

# We do not need the Rust toolchain to run the binary!
FROM debian:buster-slim AS runtime
WORKDIR app
COPY --from=builder /app/target/release/backend /usr/local/bin
ENTRYPOINT ["/usr/local/bin/backend"]
