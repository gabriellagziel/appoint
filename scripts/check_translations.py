#!/usr/bin/env python3
"""
Translation Completeness Checker for Flutter ARB Files

Scans lib/l10n/*.arb files and reports:
- Missing keys
- Extra keys  
- Untranslated values (identical to English)
- Placeholder mismatches
- Overall completeness percentage
"""

import json
import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Set, Tuple
import argparse

class TranslationChecker:
    def __init__(self, l10n_dir: str = "lib/l10n"):
        self.l10n_dir = Path(l10n_dir)
        self.source_locale = "en"
        self.source_file = self.l10n_dir / f"app_{self.source_locale}.arb"
        self.source_keys = {}
        self.source_values = {}
        
    def load_arb_file(self, file_path: Path) -> Tuple[Dict, Dict]:
        """Load ARB file and return keys and values separately."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # Separate keys and metadata
            keys = {}
            metadata = {}
            
            for key, value in data.items():
                if key.startswith('@'):
                    metadata[key] = value
                else:
                    keys[key] = value
            
            return keys, metadata
        except Exception as e:
            print(f"Error loading {file_path}: {e}")
            return {}, {}
    
    def extract_placeholders(self, text: str) -> Set[str]:
        """Extract placeholder names from text (e.g., {userName}, {count})."""
        if not isinstance(text, str):
            return set()
        return set(re.findall(r'\{([^}]+)\}', text))
    
    def check_placeholder_mismatch(self, source_text: str, target_text: str) -> List[str]:
        """Check for placeholder mismatches between source and target."""
        if not isinstance(source_text, str) or not isinstance(target_text, str):
            return []
        
        source_placeholders = self.extract_placeholders(source_text)
        target_placeholders = self.extract_placeholders(target_text)
        
        missing = source_placeholders - target_placeholders
        extra = target_placeholders - source_placeholders
        
        errors = []
        if missing:
            errors.append(f"Missing placeholders: {', '.join(missing)}")
        if extra:
            errors.append(f"Extra placeholders: {', '.join(extra)}")
        
        return errors
    
    def is_untranslated(self, source_value: str, target_value: str) -> bool:
        """Check if target value is identical to source (untranslated)."""
        if not isinstance(source_value, str) or not isinstance(target_value, str):
            return False
        
        # Normalize whitespace and compare
        source_norm = re.sub(r'\s+', ' ', source_value.strip())
        target_norm = re.sub(r'\s+', ' ', target_value.strip())
        
        return source_norm == target_norm
    
    def analyze_locale(self, locale: str) -> Dict:
        """Analyze a single locale file."""
        arb_file = self.l10n_dir / f"app_{locale}.arb"
        
        if not arb_file.exists():
            return {
                'locale': locale,
                'complete': 0.0,
                'missing_keys': list(self.source_keys.keys()),
                'extra_keys': [],
                'untranslated': [],
                'placeholder_errors': [],
                'error': f"File not found: {arb_file}"
            }
        
        target_keys, target_metadata = self.load_arb_file(arb_file)
        
        # Find missing and extra keys
        missing_keys = set(self.source_keys.keys()) - set(target_keys.keys())
        extra_keys = set(target_keys.keys()) - set(self.source_keys.keys())
        
        # Find untranslated values
        untranslated = []
        for key in self.source_keys:
            if key in target_keys:
                if self.is_untranslated(self.source_keys[key], target_keys[key]):
                    untranslated.append(key)
        
        # Check placeholder mismatches
        placeholder_errors = []
        for key in self.source_keys:
            if key in target_keys:
                errors = self.check_placeholder_mismatch(
                    self.source_keys[key], 
                    target_keys[key]
                )
                if errors:
                    placeholder_errors.append(f"{key}: {'; '.join(errors)}")
        
        # Calculate completeness
        total_keys = len(self.source_keys)
        translated_keys = total_keys - len(missing_keys)
        completeness = (translated_keys / total_keys * 100) if total_keys > 0 else 0
        
        return {
            'locale': locale,
            'complete': round(completeness, 1),
            'missing_keys': list(missing_keys),
            'extra_keys': list(extra_keys),
            'untranslated': untranslated,
            'placeholder_errors': placeholder_errors,
            'error': None
        }
    
    def run_analysis(self) -> List[Dict]:
        """Run analysis on all locale files."""
        # Load source file
        if not self.source_file.exists():
            print(f"Error: Source file not found: {self.source_file}")
            sys.exit(1)
        
        self.source_keys, _ = self.load_arb_file(self.source_file)
        print(f"Loaded {len(self.source_keys)} keys from source file")
        
        # Find all locale files
        arb_files = list(self.l10n_dir.glob("app_*.arb"))
        locales = []
        
        for arb_file in arb_files:
            # Extract locale from filename (e.g., app_en.arb -> en)
            locale = arb_file.stem.replace("app_", "")
            if locale != self.source_locale:
                locales.append(locale)
        
        print(f"Found {len(locales)} locale files to analyze")
        
        # Analyze each locale
        results = []
        for locale in sorted(locales):
            print(f"Analyzing {locale}...")
            result = self.analyze_locale(locale)
            results.append(result)
        
        return results
    
    def generate_markdown_report(self, results: List[Dict]) -> str:
        """Generate Markdown report."""
        report = []
        report.append("# Translation Completeness Report")
        report.append("")
        report.append("## Summary Table")
        report.append("")
        report.append("| Locale | % Complete | Missing Keys | Extra Keys | Placeholder Errors |")
        report.append("|--------|------------|--------------|------------|-------------------|")
        
        for result in sorted(results, key=lambda x: x['complete'], reverse=True):
            locale = result['locale']
            complete = result['complete']
            missing_count = len(result['missing_keys'])
            extra_count = len(result['extra_keys'])
            placeholder_count = len(result['placeholder_errors'])
            
            status_icon = "✅" if complete == 100 else "⚠️" if complete >= 80 else "❌"
            
            report.append(f"| {locale} | {status_icon} {complete}% | {missing_count} | {extra_count} | {placeholder_count} |")
        
        report.append("")
        report.append("## Detailed Issues")
        report.append("")
        
        for result in results:
            if result['error']:
                report.append(f"### {result['locale']} - ERROR")
                report.append(f"**Error:** {result['error']}")
                report.append("")
                continue
            
            if result['complete'] == 100 and not result['extra_keys'] and not result['placeholder_errors']:
                continue
            
            report.append(f"### {result['locale']} ({result['complete']}% complete)")
            
            if result['missing_keys']:
                report.append("**Missing Keys:**")
                for key in result['missing_keys'][:10]:  # Show first 10
                    report.append(f"- `{key}`")
                if len(result['missing_keys']) > 10:
                    report.append(f"- ... and {len(result['missing_keys']) - 10} more")
                report.append("")
            
            if result['extra_keys']:
                report.append("**Extra Keys:**")
                for key in result['extra_keys'][:10]:  # Show first 10
                    report.append(f"- `{key}`")
                if len(result['extra_keys']) > 10:
                    report.append(f"- ... and {len(result['extra_keys']) - 10} more")
                report.append("")
            
            if result['untranslated']:
                report.append("**Untranslated Values:**")
                for key in result['untranslated'][:10]:  # Show first 10
                    report.append(f"- `{key}`")
                if len(result['untranslated']) > 10:
                    report.append(f"- ... and {len(result['untranslated']) - 10} more")
                report.append("")
            
            if result['placeholder_errors']:
                report.append("**Placeholder Errors:**")
                for error in result['placeholder_errors'][:10]:  # Show first 10
                    report.append(f"- {error}")
                if len(result['placeholder_errors']) > 10:
                    report.append(f"- ... and {len(result['placeholder_errors']) - 10} more")
                report.append("")
        
        return "\n".join(report)
    
    def check_completeness_threshold(self, results: List[Dict], threshold: float = 100.0) -> bool:
        """Check if all locales meet the completeness threshold."""
        for result in results:
            if result['error']:
                print(f"❌ {result['locale']}: {result['error']}")
                return False
            
            if result['complete'] < threshold:
                print(f"❌ {result['locale']}: {result['complete']}% (below {threshold}%)")
                return False
        
        return True

def main():
    parser = argparse.ArgumentParser(description="Check translation completeness for Flutter ARB files")
    parser.add_argument("--l10n-dir", default="lib/l10n", help="Directory containing ARB files")
    parser.add_argument("--output", help="Output file for markdown report")
    parser.add_argument("--threshold", type=float, default=100.0, help="Minimum completeness threshold (default: 100)")
    parser.add_argument("--fail-on-incomplete", action="store_true", help="Exit with error if any locale is incomplete")
    
    args = parser.parse_args()
    
    checker = TranslationChecker(args.l10n_dir)
    results = checker.run_analysis()
    
    # Generate report
    report = checker.generate_markdown_report(results)
    
    # Output report
    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(report)
        print(f"Report written to {args.output}")
    else:
        print(report)
    
    # Check threshold
    if args.fail_on_incomplete:
        if not checker.check_completeness_threshold(results, args.threshold):
            print(f"\n❌ Some locales are below {args.threshold}% completeness")
            sys.exit(1)
        else:
            print(f"\n✅ All locales meet {args.threshold}% completeness threshold")

if __name__ == "__main__":
    main() 