FROM rust:1.70 as builder
WORKDIR /usr/src/oracle-core
COPY . .
RUN cargo install --path core

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/oracle-core /usr/local/bin/oracle-core
EXPOSE 9010 9099
CMD ["oracle-core", "--oracle-config-file", "/config/oracle_config.yaml", "--pool-config-file", "/config/pool_config.yaml", "-d", "/data", "run", "--enable-rest-api"]
