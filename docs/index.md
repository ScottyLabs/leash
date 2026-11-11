# Leash

Leash is a Rust library for typed authorization in Axum. A handler declares a
policy with `Authorized<P, S>`. Axum runs the policy before the handler and passes
its checked output to the handler, or returns the policy's error response.

Applications supply their own identity, state, resource types, and policy checks.
Leash has no dependency on Terrier or its domain model.

- [Getting started](getting-started.md): implement a policy and protect a route.
- [Policy reference](reference.md): compose checks with `any!`, `all!`, and `policy!`.
- [Development](development.md): run tests, checks, and the documentation preview.

See the [source repository](https://git.cmu.dev/ScottyLabs/leash) and the original
[design RFC](https://git.cmu.dev/ScottyLabs/terrier/src/branch/main/rfcs/0009-leash.md).
