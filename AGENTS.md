# Repository guide

Leash is a domain-free Rust library for typed authorization in Axum. Keep
application identities, database models, and resource-specific policies in
consuming applications.

- `src/policy.rs`: `Policy` and the `Authorized` extractor.
- `src/combinators.rs` and `src/macros.rs`: policy composition and public macros.
- `tests/integration.rs`: Axum request tests and composition examples.
- `docs/` and `zensical.toml`: documentation published through the ScottyLabs docs feature.
- `flake.nix`: shared Rust tooling, documentation preview, and Kennel site.

Use the Collar skill for ScottyLabs workflows. Run commands with
`collar dev run -- <command>` or enter `collar dev shell`. Validate changes with
`cargo test --locked`, `cargo clippy --locked --all-targets -- -D warnings`, and
`collar check --all`. For docs changes, run `zensical build --strict`; for the
packaged site, run `nix build .#docs --no-link`.

Keep changes focused. Preserve policy ordering, rejection behavior, macro hygiene,
and the public API. Cover behavior changes with request-level tests. Keep the
README short and maintain user guidance in `docs/`. Use concise ASCII prose and
descriptive links. Do not add AI attribution or co-author trailers.

Governance owns repository provisioning and features. Do not publish, push, or
change live infrastructure unless requested.
