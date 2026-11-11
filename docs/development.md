# Development

Install Lix using the [ScottyLabs development guide](https://docs.kennel.scottylabs.org/guides/local-development/),
then enter the repository's shell:

```bash
collar dev shell
```

The flake imports Kennel's shared Rust tooling and provides Zensical for docs.
Leash needs no application secrets, database, or other running services.

## Tests and checks

From the repository root:

```bash
collar dev run -- cargo test --locked
collar dev run -- cargo clippy --locked --all-targets -- -D warnings
collar check --all
```

The [integration tests](https://git.cmu.dev/ScottyLabs/leash/src/branch/main/tests/integration.rs)
exercise real Axum requests, rejection responses, policy outputs, and composition
order. Generate the Rust API documentation with:

```bash
collar dev run -- cargo doc --locked --no-deps
```

## Documentation

The `docs/` directory is published through the governance `docs` feature. The
Zensical site uses the same pages for local previews and Kennel hosting at
[docs.leash.scottylabs.org](https://docs.leash.scottylabs.org).

```bash
collar dev run -- docs
collar dev run -- zensical build --strict
nix build .#docs --no-link
```

This setup follows [Collar](https://git.cmu.dev/ScottyLabs/collar)'s root-level
`zensical.toml`, `docs/`, and shared CI workflow, and
[Terrier](https://git.cmu.dev/ScottyLabs/terrier)'s Kennel documentation-site declaration.
Feature ownership is declared in [governance](https://git.cmu.dev/ScottyLabs/governance/src/branch/main/data/teams/terrier.yaml).
