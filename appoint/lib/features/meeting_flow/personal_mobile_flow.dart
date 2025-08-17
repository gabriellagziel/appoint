import 'package:flutter/material.dart';
import '../../config/preview_flags.dart' as pf;
import '../meeting_creation/meeting_flow_entry.dart';

class PersonalMobileFlow extends StatelessWidget {
  const PersonalMobileFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      MeetingFlowEntry(
        hideLegacyBanner: true,
        skipSetup: pf.querySkipSetup || pf.previewSkipSetup,
      ),
      const Positioned(
        top: 8,
        right: 8,
        child: ColoredBox(
          color: Color(0x99000000),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              'PERSONAL_MOBILE_FLOW',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ),
    ]);
  }
}
