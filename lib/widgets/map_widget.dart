import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? address;
  final double height;
  final double width;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.address,
    this.height = 300,
    this.width = double.infinity,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadHtmlString(_generateMapHtml());
  }

  String _generateMapHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    body { 
      margin: 0; 
      padding: 0;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }
    #map { 
      height: 100vh; 
      width: 100vw; 
    }
    .loading {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: #666;
      font-size: 14px;
    }
  </style>
</head>
<body>
  <div id="map"></div>
  <div class="loading" id="loading">Loading map...</div>

  <script>
    const lat = ${widget.latitude};
    const lng = ${widget.longitude};
    const address = "${widget.address ?? 'Meeting location'}";

    const map = L.map('map').setView([lat, lng], 15);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    const marker = L.marker([lat, lng]).addTo(map);
    marker.bindPopup(address).openPopup();

    // Hide loading indicator
    document.getElementById('loading').style.display = 'none';
  </script>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              Container(
                color: Colors.white,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading map...',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
