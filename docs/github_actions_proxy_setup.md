# GitHub Actions Proxy & Mirror Setup

Use these environment variables to bypass `storage.googleapis.com` restrictions when running CI pipelines.

## YAML
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    env:
      PUB_HOSTED_URL: https://pub.flutter-io.cn
      FLUTTER_STORAGE_BASE_URL: https://storage.flutter-io.cn
      http_proxy: http://proxy.example.com:3128
      https_proxy: http://proxy.example.com:3128
    steps:
      - uses: actions/checkout@v4
      - name: Install dependencies
        run: flutter pub get
```

## Shell
```bash
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export http_proxy="http://proxy.example.com:3128"
export https_proxy="$http_proxy"
```
