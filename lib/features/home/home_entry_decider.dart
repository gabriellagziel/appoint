import 'package:flutter/material.dart';
import '../../core/preview_flags.dart';
import '../meeting_flow/meeting_flow.dart';
import '../meeting_flow/widgets/home_dashboard_stub.dart';

class HomeEntryDecider extends StatelessWidget {
  final Widget? desktopFallback;
  const HomeEntryDecider({super.key, this.desktopFallback});

  bool _isNarrow(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  @override
  Widget build(BuildContext context) {
    final flags = PreviewFlags.fromEnvironmentAndUrl();
    final shouldShowMobileFlow = flags.forceFlowAlways ||
        flags.forceMobileFlow ||
        flags.previewMobile ||
        _isNarrow(context);

    final width = MediaQuery.of(context).size.width.toStringAsFixed(0);
    print(
        '[[DECIDER]] width=$width flags=$flags -> mobile=$shouldShowMobileFlow');

    if (shouldShowMobileFlow) {
      return Stack(children: const [
        MeetingFlow(),
        Positioned(
          right: 8,
          top: 8,
          child: ColoredBox(
            color: Color(0x99000000),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Text('HOME_ENTRY_DECIDER',
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 10)),
            ),
          ),
        ),
      ]);
    }
    return Stack(children: [
      desktopFallback ?? const HomeDashboardStub(),
      const Positioned(
        right: 8,
        top: 8,
        child: ColoredBox(
          color: Color(0x99000000),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Text('HOME_ENTRY_DECIDER',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 10)),
          ),
        ),
      ),
    ]);
  }
}
