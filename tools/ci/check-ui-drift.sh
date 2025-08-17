#!/usr/bin/env bash
set -e
if git ls-files | grep -E 'components/(ui|shared)/' >/dev/null; then
  echo "UI drift detected: move components into @app-oint/design-system" >&2
  exit 1
fi

#!/usr/bin/env bash
set -euo pipefail

if git ls-files | grep -E "(components/ui/|components/shared/)" | grep -v "packages/design-system" ; then
  echo "❌ Found local UI components. Use @app-oint/design-system."
  exit 1
else
  echo "✅ No local UI component drift detected."
fi

