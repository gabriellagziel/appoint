import 'package:flutter/material.dart';
import '../meeting_flow/personal_mobile_flow.dart';
import '../personal/ui/home_landing_screen.dart';
import '../../config/preview_flags.dart' as pf;

class HomeEntryDecider extends StatelessWidget {
  const HomeEntryDecider({super.key});

  bool _isNarrow(BuildContext c) => MediaQuery.of(c).size.width < 700;

  @override
  Widget build(BuildContext context) {
    print(
        '[[DECIDER FILE PATH]] appoint/lib/features/home/home_entry_decider.dart loaded');
    final width = MediaQuery.of(context).size.width.toStringAsFixed(0);
    final mobile =
        pf.forceMobileFlow || pf.queryPreviewMobile || _isNarrow(context);
    print(
        '[[DECIDER]] width=$width flags:(force=${pf.forceMobileFlow}, preview=${pf.queryPreviewMobile}) -> mobile=$mobile');

    if (mobile) {
      print('[[DECIDER]] -> BUILD PersonalMobileFlow');
      return const PersonalMobileFlow();
    }

    print('[[DECIDER]] -> BUILD DesktopDashboard');
    return const HomeLandingScreen();
  }
}
