import 'package:flutter/foundation.dart';

// Build-time flags (dart-define)
const bool forceMobileFlow = bool.fromEnvironment(
  'FORCE_MOBILE_FLOW',
  defaultValue: false,
);

const bool _flagDisableFirebase = bool.fromEnvironment(
  'DISABLE_FIREBASE',
  defaultValue: false,
);

// Optional: skip setup in preview/dev
const bool previewSkipSetup = bool.fromEnvironment(
  'PREVIEW_SKIP_SETUP',
  defaultValue: false,
);

// Query-time toggles (read at runtime)
bool get queryPreviewMobile => Uri.base.queryParameters['preview'] == 'mobile';
bool get _queryDisableFirebase => Uri.base.queryParameters['firebase'] == 'off';
bool get querySkipSetup => Uri.base.queryParameters['skipSetup'] == '1';

// Public API consumed by app
bool get disableFirebase => _flagDisableFirebase || _queryDisableFirebase;

bool isMobilePlatform() =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;
