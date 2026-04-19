# Phel DX Feedback

Notes from building a CLI todo app with Phel `dev-main` (post v0.33.0), from the perspective of an AI-assisted developer (Claude + human).

## New features used in this app

| Feature | Version | Verdict |
|---------|---------|---------|
| `defrecord` + `->Todo` constructor | v0.32 | Works great, clean syntax |
| `defprotocol` + `extend-type` | v0.31 | Smooth, Clojure-like feel |
| `defmulti` / `defmethod` | v0.30 | Perfect for command dispatch |
| Transducers (`into`, `transduce`, `map`, `filter`) | v0.31 | Powerful, works as expected |
| Regex literals `#"..."` + `re-find` | v0.31 | Clean syntax, just works |
| `phel\pprint` | v0.30 | Very useful for debugging |
| `phel\string` (renamed from `phel\str`) | v0.33 | Breaking change is fine, better name |
| `doseq` for side-effecting iteration | v0.31 | Much better than `for` for println loops |

## What went well

- **`defrecord`** is a great addition. `(defrecord Todo [id text done])` + `(->Todo 1 "Buy milk" false)` is clean and readable. The auto-generated `->Todo` positional constructor and `map->Todo` map constructor work perfectly.
- **Protocols feel native.** Defining `Displayable` with `(display [this])` and extending it for `Todo` was straightforward. The dispatch is clean.
- **Multimethods are perfect for CLI dispatch.** `(defmulti run-command (fn [cmd _ _] cmd))` with `(defmethod run-command "add" ...)` eliminated all the `cond` nesting. The `:default` dispatch value for the help fallback is elegant.
- **Transducers work well.** `(into [] (filter pred) coll)` and `(transduce (map f) rf init coll)` are idiomatic and efficient. However, see pain point #1.
- **Regex literals** are convenient. `#"^\d+$"` with `re-find` for input validation — no PHP interop needed.
- **`pprint`** is great for debugging. Seeing `[(mytodo\main\Todo 1 "Buy groceries" false) ...]` with proper formatting is very helpful.
- **`doseq`** is the right tool for side-effecting iteration. Much clearer intent than `for`.
- **Error messages remain excellent.** Still shows exact line/column with suggestions.

## Pain points / suggestions

### 1. `transduce` with `max` doesn't work directly
- `(transduce (map f) max coll)` fails because `max` doesn't support 0-arity (required for transducer init).
- Had to write `(transduce (map f) (fn [a b] (max a b)) 0 coll)` instead.
- **Suggestion**: Either make `max`/`min` support 0-arity (returning `-Inf`/`Inf`) or document this gotcha prominently.

### 2. `$argv` access is still confusing
- Same issue as before: `php/$argv` doesn't work, need `(php/aget php/$GLOBALS "argv")`.
- Need to manually skip 3 elements to get user args.
- **Suggestion**: Built-in `(command-line-args)` that returns just user arguments.

### 3. PHP 8.4 required but docs say 8.3+
- Composer platform check fails with PHP 8.3.
- **Suggestion**: Update docs or pin requirements.

### 4. API discoverability for new features
- Had to read the source code to understand how `defrecord`, `defprotocol`, `extend-type`, `defmulti`, and transducers work in Phel.
- The changelog mentions features but doesn't link to usage docs.
- **Suggestion**: Each new feature in the changelog should have a link to a documentation page or at least a complete example.

### 5. Transducer `into` syntax can be confusing
- `(into [] (map f) coll)` — the transducer goes between target and source. This is Clojure's convention, but it's different from the 2-arity `(into [] coll)`.
- Not a bug, but worth highlighting in docs for non-Clojure users.

### 6. No `map->Record` in test output
- When using `pprint`, records show as `(ns\RecordName field1 field2 ...)` which is the constructor form — good.
- But there's no easy way to pretty-print them as maps, which would be more readable for debugging complex records.

### 7. Compilation speed
- Each `phel run` still takes ~10-35s. With 26 tests, `phel test` takes ~14s.
- For iterative development this is the biggest friction point.
- **Suggestion**: `phel watch` or incremental compilation would transform the dev experience.

## Overall impression

The new features (records, protocols, multimethods, transducers, regex) make Phel feel like a serious functional language, not just "Lisp syntax for PHP". The progression from v0.30 to main has been impressive — each release adds meaningful, well-designed features. The main areas for improvement are documentation of new features and compilation speed.
