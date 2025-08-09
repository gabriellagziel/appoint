# 🚀 Feature PR: [Brief Description]

## 📋 Checklist

### ✅ Pre-submission
- [ ] **Tests Added**: New functionality has corresponding tests
- [ ] **Coverage Check**: `dart run tool/check_coverage.dart` passes
- [ ] **Copy Scan**: `scripts/scan_copy.sh` finds no WhatsApp-only references
- [ ] **Linting**: `flutter analyze` passes
- [ ] **Formatting**: Code follows project style guidelines

### 🧪 Test Coverage
- [ ] **Unit Tests**: Controllers and services have unit tests
- [ ] **Widget Tests**: New widgets/screens have widget tests
- [ ] **Integration Tests**: Critical user flows have E2E tests
- [ ] **Golden Tests**: UI changes include golden test updates

### 🌐 Web Compatibility
- [ ] **No dart:html**: Direct `dart:html` usage avoided in unit tests
- [ ] **Conditional Imports**: Web APIs use conditional imports
- [ ] **Fallbacks**: Graceful degradation for unsupported features

### 📱 User Experience
- [ ] **Universal Copy**: No platform-specific language (WhatsApp, etc.)
- [ ] **Accessibility**: Screen readers and keyboard navigation supported
- [ ] **Responsive**: Works on mobile, tablet, and desktop

## 🔍 Changes Made

### ✨ New Features
- [Feature 1]
- [Feature 2]

### 🐛 Bug Fixes
- [Bug 1]
- [Bug 2]

### 🔧 Technical Improvements
- [Improvement 1]
- [Improvement 2]

## 🧪 Testing

### Unit Tests
```bash
flutter test test/features/
flutter test test/services/
```

### Widget Tests
```bash
flutter test test/widgets/
```

### Integration Tests
```bash
flutter test -d chrome integration_test/
```

### Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

**Coverage Summary:**
- Global Coverage: [X]% (target: ≥70%)
- Changed Files Coverage: [X]% (target: ≥85%)

## 📊 Quality Gates

### ✅ Coverage Thresholds
- [ ] Global coverage ≥ 70%
- [ ] Changed files coverage ≥ 85%
- [ ] No new files with < 85% coverage

### ✅ Copy Consistency
- [ ] No WhatsApp-only references found
- [ ] Universal language used throughout
- [ ] Platform-agnostic sharing implemented

### ✅ Test Quality
- [ ] All tests pass locally
- [ ] Integration tests pass on Chrome
- [ ] Golden tests updated if UI changed

## 🚀 Deployment Checklist

### Pre-deploy Smoke Tests
- [ ] `/join?token=fake&src=telegram` → guest view renders
- [ ] Meeting Details: Share and Navigate work correctly
- [ ] Home: Today merges reminders+meetings correctly
- [ ] Create Meeting: virtual skips location, playtime requires it
- [ ] Ad-Gate: Free users see watch requirement

### Post-deploy Verification
- [ ] Feature works in production
- [ ] No console errors in browser
- [ ] Performance impact minimal
- [ ] Analytics events firing correctly

## 📝 Additional Notes

### Breaking Changes
- [ ] None
- [ ] Documented in CHANGELOG.md

### Dependencies
- [ ] No new dependencies added
- [ ] Existing dependencies updated safely

### Security
- [ ] No sensitive data exposed
- [ ] Input validation implemented
- [ ] Error messages don't leak information

---

## 🎯 Review Focus Areas

Please pay special attention to:
1. **Test coverage** - Are all new code paths tested?
2. **Web compatibility** - Does it work in Flutter Web?
3. **User experience** - Is the flow intuitive?
4. **Performance** - Any performance regressions?
5. **Accessibility** - Screen reader friendly?

## 📋 Reviewer Checklist

### Code Quality
- [ ] Code follows project patterns
- [ ] Error handling is robust
- [ ] No hardcoded values
- [ ] Proper logging/analytics

### Testing
- [ ] Tests are meaningful and not just for coverage
- [ ] Edge cases are covered
- [ ] Integration tests verify real user flows
- [ ] Golden tests capture visual regressions

### Security & Privacy
- [ ] No sensitive data in logs
- [ ] Input validation prevents injection
- [ ] Error messages are user-friendly
- [ ] Analytics events don't leak PII

---

**Ready for Review** ✅

<!-- 
Template variables:
- Replace [Brief Description] with actual feature name
- Fill in coverage percentages from `dart run tool/check_coverage.dart`
- Update feature/bug lists with actual changes
- Add any specific testing instructions
-->
