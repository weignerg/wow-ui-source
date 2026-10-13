# Rule: Code Quality & Testing

- **Two-Stage TDD Pipeline**: Stage 1 unit tests, Stage 2 integration/container checks, via `tools/tdd_pipeline.py` (or the `tdd-pipeline` skill).
- **Traceback Parsing**: Convert compiler errors and test tracebacks directly into patch diffs; no conversational filler.
- **Mock Illusion Hunting**: Tests must verify real behavior, contracts, and boundary conditions. Avoid trivially passing mocks that mask failures.
- **Zero Regression**: All existing tests must pass before declaring work complete.
- Preserve existing comments and docstrings unrelated to your change.
