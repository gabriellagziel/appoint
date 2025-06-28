---
name: CI Network Access Issue
about: Report blocked network access in CI for pub.dev, storage.googleapis.com, firebase-public.firebaseio.com, metadata.google.internal, raw.githubusercontent.com or 169.254.169.254
title: "[CI] Network Access Blocked for {{host}}"
labels: ci
---

**Host:** `{{host}}`
**Error:** Describe the network allowlist error seen in CI logs.
**Environment:** (e.g., GitHub Enterprise or self-hosted runner)
**Steps to reproduce:**
1. Trigger CI job
2. Observe failure on `curl` pre-flight check
