#!/bin/bash
set -e

echo "🔧 Creating Minimal Working Build"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Step 1: Create a minimal main.dart that works
print_info "Creating minimal working main.dart..."

cat > lib/main_minimal.dart << 'EOF'
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App-Oint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App-Oint'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'App-Oint',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your appointment management solution',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '🚀 Coming Soon!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We\'re working hard to bring you the best experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

print_status "Created minimal main.dart"

# Step 2: Update pubspec.yaml to remove problematic dependencies
print_info "Creating minimal pubspec.yaml..."

cat > pubspec_minimal.yaml << 'EOF'
name: appoint
description: "Appointment management application"
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
EOF

print_status "Created minimal pubspec.yaml"

# Step 3: Backup original files
print_info "Backing up original files..."
cp lib/main.dart lib/main.dart.backup
cp pubspec.yaml pubspec.yaml.backup

# Step 4: Replace with minimal versions
print_info "Replacing with minimal versions..."
cp lib/main_minimal.dart lib/main.dart
cp pubspec_minimal.yaml pubspec.yaml

# Step 5: Clean and get dependencies
print_info "Cleaning and getting dependencies..."
flutter clean
flutter pub get

# Step 6: Build the minimal version
print_info "Building minimal web app..."
flutter build web --release

# Step 7: Test the build
print_info "Testing the build..."
if [ -f "build/web/index.html" ]; then
    print_status "✅ Build successful!"
    print_info "Your minimal app is ready at: build/web/"
    
    # Create a simple deployment script
    cat > deploy_minimal.sh << 'EOF'
#!/bin/bash
echo "🚀 Deploying minimal App-Oint to Firebase..."

# Install Firebase CLI if not available
if ! command -v firebase &> /dev/null; then
    echo "Installing Firebase CLI..."
    npm install -g firebase-tools
fi

# Deploy to Firebase
firebase deploy --only hosting

echo "✅ Deployment completed!"
echo "🌐 Your app should be available at: https://app-oint-core.firebaseapp.com"
EOF
    
    chmod +x deploy_minimal.sh
    print_status "Created deploy_minimal.sh script"
    
else
    print_error "❌ Build failed!"
    exit 1
fi

print_status "🎉 Minimal working build created successfully!"
print_info "You can now deploy this minimal version while fixing the full app."