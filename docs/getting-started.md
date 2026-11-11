# Getting started

Add Leash to an Axum 0.8 application:

```bash
cargo add leash --git https://git.cmu.dev/ScottyLabs/leash --branch main
```

## Protect a route

Implement `Policy<S>` for an atomic access check. Return the data the handler may
use on success, or an error implementing Axum's `IntoResponse` on rejection.

This example reads an identity that trusted authentication middleware has placed
in request extensions. Authentication must validate the identity before attaching
it; Leash handles the authorization check that follows.

```rust
use axum::{
    http::{request::Parts, StatusCode},
    routing::get,
    Router,
};
use leash::{Authorized, Policy};

#[derive(Clone)]
struct CurrentUser {
    name: String,
    is_admin: bool,
}

struct IsAdmin;

impl Policy<()> for IsAdmin {
    type Output = CurrentUser;
    type Error = StatusCode;

    async fn check(parts: &mut Parts, _state: &()) -> Result<CurrentUser, StatusCode> {
        let user = parts.extensions.get::<CurrentUser>()
            .ok_or(StatusCode::UNAUTHORIZED)?;
        if !user.is_admin {
            return Err(StatusCode::FORBIDDEN);
        }
        Ok(user.clone())
    }
}

async fn dashboard(auth: Authorized<IsAdmin>) -> String {
    format!("Welcome, {}", auth.data.name)
}

fn app() -> Router {
    Router::new().route("/admin", get(dashboard))
}
```

Add your authentication middleware to this router. Without a `CurrentUser` in
request extensions, the policy returns `401 Unauthorized`. Authenticated users
without admin access receive `403 Forbidden`. The handler runs only after the
policy succeeds.

## Use application state

For database-backed checks, implement `Policy<AppState>` and use the `state`
argument to load a resource and verify access. Define an application-local alias:

```rust
pub type Auth<P> = leash::Authorized<P, AppState>;
```

A handler can then accept `Auth<CanEditProject>` and read the authorized project
from `auth.data`. Query errors should propagate as application errors rather than
becoming permission denials.

See the [policy reference](reference.md) for composition and error behavior.
