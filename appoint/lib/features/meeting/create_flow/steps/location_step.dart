import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../services/geocoding_service.dart';
import '../providers.dart';

class LocationStep extends ConsumerStatefulWidget {
  const LocationStep({super.key});
  @override
  ConsumerState<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends ConsumerState<LocationStep> {
  late final TextEditingController _addrCtrl;
  String _query = '';

  @override
  void initState() {
    super.initState();
    final state = ref.read(REDACTED_TOKEN);
    _addrCtrl = TextEditingController(text: state.locationAddress ?? '');
    _query = _addrCtrl.text;
  }

  @override
  void dispose() {
    _addrCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(REDACTED_TOKEN);
    final ctrl = ref.read(REDACTED_TOKEN.notifier);
    final hasCoords = (state.lat != null && state.lng != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _addrCtrl,
          decoration: const InputDecoration(
            labelText: 'Search Address / Place',
            hintText: 'Type a place name or address',
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 6),
        FutureBuilder<List<GeocodingResult>>(
          future: GeocodingService.fetchPredictions(_query),
          builder: (context, snapshot) {
            final preds = snapshot.data ?? const [];
            if (_query.isEmpty || preds.isEmpty) return const SizedBox.shrink();
            return Card(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: preds.length,
                itemBuilder: (ctx, i) {
                  final p = preds[i];
                  return ListTile(
                    dense: true,
                    title: Text(
                      p.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      _addrCtrl.text = p.displayName;
                      setState(() => _query = p.displayName);
                      ctrl.setLocation(
                        address: p.displayName,
                        lat: p.lat,
                        lng: p.lng,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => ctrl.setLocation(address: _addrCtrl.text),
              child: const Text('Save address'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () async {
                final res = await GeocodingService.geocode(_addrCtrl.text);
                if (res == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Could not find this place.')),
                    );
                  }
                  return;
                }
                ctrl.setLocation(
                    address: res.displayName, lat: res.lat, lng: res.lng);
              },
              child: const Text('Preview on map'),
            ),
          ],
        ),
        if (hasCoords) const SizedBox(height: 12),
        if (hasCoords)
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(state.lat!, state.lng!),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'app-oint.personal',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                      point: LatLng(state.lat!, state.lng!),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on,
                          color: Colors.red, size: 32),
                    ),
                  ]),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
