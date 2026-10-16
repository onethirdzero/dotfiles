# Simple Language

- Use simple language in every chat response, code comment, plan output.
- If a new jargon is used for the first time, define it.
- Prefer short, direct sentences and common words.
- Avoid jargon when a plain term is accurate.
- Keep wording precise. Do not remove details needed to understand behavior or risk.
- Break complex ideas into clear steps.
- Prefer a numbered list when describing a sequence of events.
- Do not use semicolons.

Example:

```text
Avoid:

The manager admits every request and discovers its memory ceiling by dying at it: measured, 10 req/s of 4 MiB forwards OOM-killed a 128 Mi container that sustained 200 req/s of 64 KiB ones, because a 4 MiB batch holds ~17 MiB of live heap while in flight. The kill is paid fleet-wide — every data plane on the cell loses control polls — while rejecting a forward costs that batch one pass of forwarding lag: the at-least-once protocol re-reads the agent's own store on the next pass, so no sample is lost.

Prefer:

Forwarded batches can consume much more memory after decoding than their wire size suggests.

In testing, a 4 MiB batch used approximately 17 MiB of live heap while being processed. At 10 requests per second, these batches OOM-killed a manager in a 128 MiB container. By comparison, the same container handled 200 requests per second of 64 KiB batches.

An OOM kill interrupts the manager for every data plane in the cell. Shedding an individual forwarding request has a smaller impact: temporarily rejected data is read from the agent’s store again on its next forwarding pass.
```

# Golang

## Tests

- When writing table-driven tests, always include the expected value in each case next to the input. Prefer not to compute the expected result in the test loop, and prefer not to omit `want` because the assertion could derive it.

```go
// Avoid: expected value is computed in the loop
tests := []struct {
	name  string
	input int
}{
	{name: "double", input: 2},
}
for _, tt := range tests {
	got := Double(tt.input)
	if got != tt.input*2 {
		t.Fatalf("Double(%d) = %d, want %d", tt.input, got, tt.input*2)
	}
}

// Prefer: expected value lives in the table
tests := []struct {
	name  string
	input int
	want  int
}{
	{name: "double", input: 2, want: 4},
}
for _, tt := range tests {
	got := Double(tt.input)
	if got != tt.want {
		t.Fatalf("Double(%d) = %d, want %d", tt.input, got, tt.want)
	}
}
```

# Coding

## Use Git worktrees

For each feature or change request, use a dedicated Git branch and worktree. Keep the main checkout unchanged.
If the work spans multiple repositories, create one worktree per repository.
Remove worktrees only after the changes are merged and no uncommitted work remains.

## Git commit message

- Follow the repo's CONTRIBUTING.md for conventions.
- Prefer to capitalize the first letter after the Conventional Commit type prefix.

  Don't do: `feat(123): foo bar`

  Do: `feat(123): Foo bar`

- Don't let lines in the commit message exceed 80 characters.
- Do not put too much implementation detail in commit messages. Prefer an overview.

## Git push

Never push a branch to remote without an explicit approval/request from a human.

If a Git push affects a corresponding PR, the PR description should be updated. Remember to use simple language and keep
it as short and readable as possible.

## Implementation

- Always try to split the plan up into chunks that can be Git committed, where every commit builds and passes tests, and
is reasonably reviewable by a human.
- Always include code that passes tests in the commit that introduces those tests.
- Always include ways to observe whether a feature/fix is working - eg. metrics/logs
- Always incorporate these docs:
  - Overall architecture doc, which includes a diagram where applicable
  - User guide
  - Runbook, if applicable
- If a local implementation plan needs to span 2 workspaces, ensure that their split plans are linked to each other, so that
  any relevant changes that happen to either one is reflected in the other.

### Tracer Bullets

When building features, build a tiny, end-to-end slice of the feature first, seek feedback, then expand out from there.

Tracer bullets comes from the Pragmatic Programmer. When building systems, you want to write code that gets you feedback as quickly as possible.
Tracer bullets are small slices of functionality that go through all layers of the system, allowing you to test and validate your approach early.
This helps in identifying potential issues and ensures that the overall architecture is sound before investing significant time in development.

## Error messages

- Always prefer actionable error messages instead of generic ones
  - eg. "input is malformed" is not helpful. "input is missing part X" is actionable.

