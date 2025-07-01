---
name: Integrate Cached Network Images
about: Add cached_network_image for offline-capable image caching
title: "Add cached_network_image for offline-capable image caching"
labels: ["performance", "flutter", "enhancement"]
assignees: []
---

## Description
There are several `NetworkImage` and `Image.network` usages with no caching. Integrating `cached_network_image` will speed up load times and improve offline UX.

## Current Issues
- Multiple `NetworkImage` and `Image.network` usages without caching
- Slow image loading on repeated visits
- No offline image support
- Poor user experience with slow loading times

## Acceptance Criteria
- [ ] `pubspec.yaml` lists `cached_network_image: ^3.3.0`
- [ ] Replace at least 5 instances of `NetworkImage` with `CachedNetworkImageProvider`
- [ ] Provide fallback/error handling in case images fail to load
- [ ] Document usage in a new "Performance" section of README
- [ ] Test offline functionality works correctly

## Files to Update
- [ ] `pubspec.yaml` - add dependency
- [ ] `README.md` - add Performance section
- [ ] Replace `NetworkImage` usages in:
  - [ ] `lib/features/` directories
  - [ ] `lib/widgets/` directories
  - [ ] Any profile or avatar images

## Implementation Steps
1. Add `cached_network_image: ^3.3.0` to `pubspec.yaml`
2. Run `flutter pub get`
3. Identify files using `NetworkImage` or `Image.network`
4. Replace with `CachedNetworkImage` or `CachedNetworkImageProvider`
5. Add proper error handling and loading placeholders
6. Test offline functionality
7. Update README with performance documentation

## Example Usage
```dart
// Before
Image.network(imageUrl)

// After
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## Definition of Done
- [ ] `cached_network_image` dependency is added
- [ ] At least 5 image usages are updated
- [ ] Error handling is implemented
- [ ] Offline functionality works
- [ ] Performance documentation is added to README 