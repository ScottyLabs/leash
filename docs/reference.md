# Policy reference

| Item | Purpose |
| -- | -- |
| `Policy` | Trait you implement once per atomic check. |
| `Authorized<P, S>` | Witness extractor; constructible only via the trait impl. |
| `any!` / `all!` | Compose one or more policy types with OR / AND. |
| `Either` | Identifies the successful branch of `any!`. |
| `policy!` | Sum-type policy from a list of variants. |

There is no application-domain code in this crate (no `User`, `Hackathon`, or `Election`). Consumers bring their own state and entity types.

## Combining policies

Use `any!` when one policy may pass, or `all!` when every policy must pass:

```rust
type Access = leash::any!(IsAdmin, IsMember, IsJudge);
type Required = leash::all!(IsMember, HasAcceptedTerms, IsEligible);
```

These are type macros for handler signatures such as `Authorized<Access, AppState>`. They accept at least one policy, optional trailing commas, and nested combinations. A single policy stays unchanged. Policies must share an error type.

`any!(A, B, C)` returns `Either<A::Output, Either<B::Output, C::Output>>`, while `all!(A, B, C)` returns `(A::Output, (B::Output, C::Output))`. The binary types used by macro expansion are hidden implementation details.

### `any!` or `policy!`?

Both try policies in order and stop at the first success. They differ in what the handler receives:

| Declaration | Successful output |
| -- | -- |
| `type Access = any!(IsAdmin, IsOwner);` | `Either::Left(admin)` or `Either::Right(owner)` |
| `policy!` with `Admin = IsAdmin, Owner = IsOwner` | `Access::Admin(admin)` or `Access::Owner(owner)` |

Use `any!` for simple alternatives. Use `policy!` when the handler matches on the successful branch and names would be clearer than nested `Left` and `Right`.

Checks run left to right. `any!` stops at the first success and returns the last error if all fail; `all!` stops at the first error. `any!` tries the next policy after every error, including infrastructure failures. Use an explicit check if those failures must stop evaluation. Checks share request parts, so avoid side effects that a later branch could observe.

## Project-local alias

`Authorized<P, S>` defaults `S` to `()` so stateless examples read nicely. Stateful consumers should define a one-line alias next to their `AppState`:

```rust
pub type Auth<P> = leash::Authorized<P, AppState>;
```

Handler signatures then read `Auth<SettingsAccess>` instead of `Authorized<SettingsAccess, AppState>`.
