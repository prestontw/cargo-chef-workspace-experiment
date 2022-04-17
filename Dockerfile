FROM lukemathwalker/cargo-chef:latest-rust-1.56.0 AS chef
WORKDIR app

FROM chef AS planner
COPY ./backend ./backend
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock
RUN perl -0777 -i -pe 's/members = \[[^\]]+\]/members = ["backend"]/igs' Cargo.toml
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
# Build dependencies - this is the caching Docker layer!
RUN cargo chef cook --release --recipe-path recipe.json
# Build application
COPY ./backend ./backend
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock
RUN perl -0777 -i -e 's/members = \[[^\]]+\]/members = ["backend"]/igs' Cargo.toml
RUN cargo build --release --bin backend

# We do not need the Rust toolchain to run the binary!
FROM debian:buster-slim AS runtime
WORKDIR app
COPY --from=builder /app/target/release/backend /usr/local/bin
ENTRYPOINT ["/usr/local/bin/backend"]
