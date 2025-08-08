import 'package:url_launcher/url_launcher.dart';

Future<void> openVirtualUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}

/// פותח Deep Link כללי למפות (iOS/Android/Web):
Future<void> openMap({required double lat, required double lng, String? label}) async {
  final query = label == null ? '$lat,$lng' : Uri.encodeComponent('$label@$lat,$lng');
  // geo: לא תמיד נתמך בווב; ננסה universal map URL (OpenStreetMap)
  final url = Uri.parse('https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=16/$lat/$lng');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    await launchUrl(url);
  }
}
