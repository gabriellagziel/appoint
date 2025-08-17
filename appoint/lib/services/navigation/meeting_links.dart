import 'package:url_launcher/url_launcher.dart';

Future<void> openVirtualUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}

/// פותח Deep Link כללי למפות (iOS/Android/Web):
Future<void> openMap(
    {required double lat, required double lng, String? label}) async {
  // Default: Frrm Maps (our OSM-based experience)
  final url = Uri.parse(
      'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=16/$lat/$lng');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    await launchUrl(url);
  }
}

Uri buildFrrmMapUrl({required double lat, required double lng, String? label}) {
  return Uri.parse(
      'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=16/$lat/$lng');
}

Uri buildGoogleMapUrl(
    {required double lat, required double lng, String? label}) {
  // Google Maps web link; label is optional
  final q = label != null && label.isNotEmpty
      ? Uri.encodeComponent(label)
      : '$lat,$lng';
  return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$q&query_place_id=');
}

Future<void> openMapFrrm(
    {required double lat, required double lng, String? label}) async {
  final url = buildFrrmMapUrl(lat: lat, lng: lng, label: label);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    await launchUrl(url);
  }
}

Future<void> openMapGoogle(
    {required double lat, required double lng, String? label}) async {
  final url = buildGoogleMapUrl(lat: lat, lng: lng, label: label);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    await launchUrl(url);
  }
}
