# Phel Todo CLI

A simple command-line task manager built with [Phel](https://phel-lang.org/) — a functional programming language that compiles to PHP.

## Requirements

- PHP 8.4+ and Composer, or
- Docker (via WSL on Windows)

## Setup

```bash
composer install
```

## Usage

```bash
vendor/bin/phel run src/phel/main.phel help              # Show help
vendor/bin/phel run src/phel/main.phel add Buy groceries  # Add a todo
vendor/bin/phel run src/phel/main.phel list               # List all todos
vendor/bin/phel run src/phel/main.phel done 1             # Toggle done/undone
vendor/bin/phel run src/phel/main.phel remove 1           # Remove a todo
vendor/bin/phel run src/phel/main.phel clear              # Remove completed todos
```

## Tests

```bash
vendor/bin/phel test
```

## DX Feedback

This app was built as an exercise to evaluate the Phel developer experience. See [FEEDBACK.md](FEEDBACK.md) for notes.
