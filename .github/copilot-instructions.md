# Copilot PR Review Guidelines

* 🚫 **Flag** any `print()` calls in production code.
* ✅ **Ensure** every `Future` is `await`ed or wrapped in `try/catch`.
* 🧱 **Prefer** `const` constructors on stateless widgets.
* 🔒 **Check** that no real `FirebaseFirestore.instance` or `FirebaseAuth.instance` remains in tests.
* 📝 **Comment** if test coverage drops below 80%.

