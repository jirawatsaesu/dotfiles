---
name: commit
description: Create well-formatted git commits following conventional commit standards.
---

Create well-formatted git commits following conventional commit standards.

## Usage

```
/eng:commit
```

## Best Practices

- **Verify before committing**: Ensure code is linted, builds correctly, and documentation is updated
- **Atomic commits**: Each commit should contain related changes that serve a single purpose
- **Conventional commit format**: Use `<type>(<scope>): <description>` — keep the description under 72 characters
- **Present tense, imperative mood**: Write commit messages as commands (e.g., "add feature" not "added feature")
- **Body when needed**: Add a body only when the why isn't obvious from the description

## Commit Format

```
<type>(<optional scope>): <description>

[optional body]
```

| Type | Description |
|------|-------------|
| feat | New feature |
| fix | Bug fix |
| docs | Documentation changes |
| style | Code style changes |
| refactor | Code refactoring |
| perf | Performance improvements |
| test | Adding or modifying tests |
| chore | Maintenance tasks |

## Atomic Commits

Each commit must represent one logical change. Before generating a message, check the diff against these criteria:

1. **Different concerns** — changes to unrelated parts of the codebase
2. **Mixed types** — combining a feature, a fix, a refactor, etc. in one diff
3. **File patterns** — source code changes bundled with docs, config, or tests that belong to a different story
4. **Logical grouping** — changes that would be easier to review or revert independently

## Behavior

1. Run `git status --short` — if nothing is staged, run `git add -A` first, then analyze staged changes with `git diff --staged`
2. Check the diff against the Atomic Commits criteria and note any concerns
3. Generate a conventional commit message
4. Create the commit with proper formatting

## Example Output

```
feat(auth): add password reset functionality

- Add forgot password form
- Implement email verification flow
- Add password reset endpoint
```
