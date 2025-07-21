# 🔧 Mergeability Fix Request – Cursor

**Hello Cursor,**

There is a critical issue: many of the recent pull requests (PRs) you created **cannot be merged**. They are showing as **drafts**, **unmergeable**, or **disconnected from the main branch**.

---

## ✅ Required Actions

1. **Diagnose the PR Issues**
   - Check if the PRs are based on old or deleted branches.
   - Verify if the PRs are mistakenly marked as drafts.
   - Identify and fix failing checks (CI, missing dependencies, broken builds, etc.).

2. **Stop Opening New PRs**
   - Do not create any new PRs until the root cause is fully understood and resolved.

3. **Run Mergeability Check**
   - Use GitHub CLI to inspect all open PRs:
     ```bash
     gh pr list --state open --json title,number,mergeable
     ```
   - Any PR where `mergeable` is `false` or `null` is considered broken and must be fixed or closed.

4. **Create One Clean, Mergeable PR**
   - Branch from the latest `main`.
   - Ensure the PR is **ready for review** (not draft).
   - Include all latest fixes and QA improvements.
   - Push only code that passes **all** of the following locally *before* pushing:
     ```bash
     flutter analyze
     flutter test
     npm test        # Cloud Functions
     # All end-to-end tests executed successfully in the DigitalOcean environment
     ```

---

## 🧩 PR Must Include

- Full QA audit fixes (localization, Stripe flows, Cloud Functions, UI validation).
- Working CI/CD (including `flutter analyze` and artifact uploads).
- All translated and validated screens.
- Re-review of all previously “fixed” files to verify correctness.

---

Please confirm once ready and provide the number of the new mergeable PR.

---