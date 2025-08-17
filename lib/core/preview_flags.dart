import 'package:flutter/foundation.dart' show kIsWeb;

class PreviewFlags {
  final bool forceMobileFlow;
  final bool forceFlowAlways;
  final bool previewMobile;
  final bool skipSetup;

  const PreviewFlags({
    required this.forceMobileFlow,
    required this.forceFlowAlways,
    required this.previewMobile,
    required this.skipSetup,
  });

  static const _forceMobileFlowEnv =
      bool.fromEnvironment('FORCE_MOBILE_FLOW', defaultValue: false);
  static const _forceFlowAlwaysEnv =
      bool.fromEnvironment('FORCE_FLOW_ALWAYS', defaultValue: false);

  static PreviewFlags fromEnvironmentAndUrl() {
    final Uri uri = kIsWeb ? Uri.base : Uri();
    final q = uri.queryParameters;
    return PreviewFlags(
      forceMobileFlow: _forceMobileFlowEnv || q['forceMobileFlow'] == '1',
      forceFlowAlways: _forceFlowAlwaysEnv || q['forceFlowAlways'] == '1',
      previewMobile: (q['preview'] ?? '') == 'mobile',
      skipSetup: q['skipSetup'] == '1',
    );
  }

  @override
  String toString() => 'PreviewFlags('
      'forceMobileFlow=$forceMobileFlow, '
      'forceFlowAlways=$forceFlowAlways, '
      'previewMobile=$previewMobile, '
      'skipSetup=$skipSetup)';
}
