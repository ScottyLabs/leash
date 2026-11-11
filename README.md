# Leash

Typed authorization policies and extractors for Rust and Axum. Handlers declare
access requirements with `Authorized<P, S>` and receive the checked policy output.
Applications supply their own state, identities, and resource types.

```bash
cargo add leash --git https://git.cmu.dev/ScottyLabs/leash --branch main
```

- [Getting started](docs/getting-started.md)
- [Policy reference](docs/reference.md)
- [Development and documentation](docs/development.md)
- [Documentation site](https://docs.leash.scottylabs.org)

## Development

```bash
collar dev run -- cargo test --locked
collar check --all
collar dev run -- docs
```

The repository uses the shared ScottyLabs Rust environment and CI from
[Kennel](https://git.cmu.dev/ScottyLabs/kennel), following
[Collar](https://git.cmu.dev/ScottyLabs/collar)'s documentation setup.
