# Assessment Notes

## Why AsyncNotifierProvider instead of FutureProvider?
`AsyncNotifierProvider` gives us full control over the provider lifecycle, state emission, and explicit methods like `refresh()`. Unlike `FutureProvider`, which is purely declarative and recreates the future on dependency changes, `AsyncNotifier` allows imperative state management, enabling the cache-first pattern, background unawaited updates, and manual refresh triggers without rebuilding the entire widget tree.

## What does the cache-first strategy prevent?
It prevents the user from seeing a blank loading screen on every app launch or navigation. By immediately emitting cached data, the UI feels instant and responsive, while the background refresh silently updates the content. This eliminates perceived latency and reduces unnecessary Firestore reads when offline or on slow connections.