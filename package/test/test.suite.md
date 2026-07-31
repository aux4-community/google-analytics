# google-analytics test suite

Run the CI-safe group with `aux4 test run --group core` from this directory. The
`integration` group needs a real Google login and is skipped unless requested.

## core

- google__analytics__report.test.md
- google__analytics__realtime.test.md
- google__analytics__metadata.test.md
- google__analytics__injection.test.md

## integration (optional)

- google__analytics.test.md
