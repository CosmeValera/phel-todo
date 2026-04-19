# Phel DX Feedback

Notes from building a CLI todo app with Phel v0.33.0, from the perspective of an AI-assisted developer (Claude + human).

## What went well

- **`phel init` is great**: One command sets up the project structure, config, example code, and tests. Very smooth.
- **CLI skeleton**: The `cli-skeleton` option via `composer create-project` is a nice touch for quick starts.
- **Tests work out of the box**: `phel test` just works. The test framework (`deftest`, `is`) feels natural.
- **JSON module**: `json/encode` and `json/decode` worked seamlessly with Phel data structures.
- **Immutable data + functional idioms**: `map`, `filter`, `reduce`, `assoc`, `vec` all work as expected from a Clojure-like language. Writing pure functions for data transformations was pleasant.
- **PHP interop**: Being able to call `php/file_exists`, `php/intval`, `php/implode`, `php/array_slice` etc. directly is powerful.
- **Error messages**: The compiler error for `to-list` (which doesn't exist) was clear — it showed the exact line, column, and even suggested `list` as an alternative. Very helpful.

## Pain points / suggestions

### 1. `$argv` access is confusing
- `php/$argv` does NOT work inside `phel run` (it's `null` in the compiled temp file).
- Had to discover that `(php/aget php/$GLOBALS "argv")` works instead.
- The offset is also non-obvious: you need to skip 3 elements (`vendor/bin/phel`, `run`, `src/.../main.phel`) to get to user args.
- **Suggestion**: Provide a built-in function like `(command-line-args)` that returns only the user's arguments (after the script path), abstracting away the runtime details.

### 2. PHP 8.4 requirement not documented on "Getting Started"
- The docs say "PHP 8.3+", but composer installs a version that requires PHP 8.4+.
- This caused a confusing `platform_check.php` error until I switched Docker images.
- **Suggestion**: Update the docs to say PHP 8.4+, or pin composer platform requirements.

### 3. Discoverability of available functions
- It's hard to know what functions exist. For example, I tried `to-list` (doesn't exist) before finding `vec` works for converting PHP arrays to Phel vectors.
- The API reference page redirects, making it harder to browse.
- **Suggestion**: A searchable API reference or better-organized cheatsheet would help a lot. Maybe group by "conversions", "collections", "I/O", etc.

### 4. `for` expression semantics
- `for` in Phel is a list comprehension (like Clojure's `for`), not a side-effecting loop. Used `(for [t :in todos] (print-todo t))` and it worked because `println` has side effects, but this is semantically misleading.
- **Suggestion**: Documentation could emphasize `doseq` for side-effecting iteration vs `for` for building sequences.

### 5. Slow startup / compilation time
- Each `phel run` invocation takes a noticeable amount of time (~10-35s) for compilation. During iterative development this adds up.
- Tests took ~12s for 14 simple assertions (though this includes compilation).
- **Suggestion**: Caching compiled code between runs (if not already) would significantly improve the dev loop. A `phel watch` or incremental compilation mode would be great.

### 6. No built-in way to handle CLI args idiomatically
- Had to manually parse `$GLOBALS["argv"]`, cast to int with `php/intval`, join strings with `php/implode`.
- **Suggestion**: A small `cli` module with arg parsing helpers would make CLI apps much more ergonomic. Even just `(cli/args)` returning a Phel vector of strings after the script name.

## Overall impression

Phel is fun to write. The Clojure-inspired syntax with PHP interop is a unique and compelling combination. The main friction points are around tooling ergonomics (arg handling, startup time, API discoverability) rather than the language itself. For a v0.33 release, the core language feels solid.
