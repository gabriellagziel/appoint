#!/bin/bash
echo "🧹 COMPREHENSIVE CODEBASE CLEANUP STARTING..."
BACKUP_DIR="cleanup_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "📁 Creating backup in: $BACKUP_DIR"
echo "🗑️  Removing temporary files..."
find . -name "*.tmp" -type f -exec mv {} "$BACKUP_DIR/" \;
find . -name "*.backup" -type f -exec mv {} "$BACKUP_DIR/" \;
find . -name "*.old" -type f -exec mv {} "$BACKUP_DIR/" \;
find . -name "*~" -type f -exec mv {} "$BACKUP_DIR/" \;
echo "🗑️  Removing deployment result files..."
find . -name "deployment_results_*.json" -type f -exec mv {} "$BACKUP_DIR/" \;
echo "🗑️  Removing large impact analysis files..."
find . -name "*_impact.txt" -type f -exec mv {} "$BACKUP_DIR/" \;
find . -name "*_checkpoint.txt" -type f -exec mv {} "$BACKUP_DIR/" \;
find . -name "*_perfection.txt" -type f -exec mv {} "$BACKUP_DIR/" \;
echo "🗑️  Removing duplicate node_modules..."
find . -path "./node_modules" -prune -o -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
echo "🗑️  Removing large archive files..."
find . -name "*.tar.gz" -type f -exec mv {} "$BACKUP_DIR/" \;
echo "🗑️  Removing test result files..."
find . -name "test_results_*.json" -type f -exec mv {} "$BACKUP_DIR/" \;
find . -name "test_*.log" -type f -exec mv {} "$BACKUP_DIR/" \;
echo "🗑️  Removing build log files..."
find . -name "*_build_*.txt" -type f -exec mv {} "$BACKUP_DIR/" \;
find . -name "*_analysis_*.txt" -type f -exec mv {} "$BACKUP_DIR/" \;
echo "🗑️  Removing undefined method files..."
find . -name "*_undefined.txt" -type f -exec mv {} "$BACKUP_DIR/" \;
echo "🗑️  Removing corrupted files..."
find . -name "corrupted_files.txt" -type f -exec mv {} "$BACKUP_DIR/" \;
echo "📁 Creating organized directory structure..."
mkdir -p {config,scripts,backups,docs,deployments}
echo "📁 Moving configuration files..."
find . -maxdepth 1 -name "*.yaml" -o -name "*.yml" -o -name "*.json" | grep -v "package.json" | grep -v "pubspec.yaml" | xargs -I {} mv {} config/ 2>/dev/null || true
echo "📁 Moving script files..."
find . -maxdepth 1 -name "*.sh" -o -name "*.py" -o -name "*.js" | xargs -I {} mv {} scripts/ 2>/dev/null || true
echo "📁 Moving documentation files..."
find . -maxdepth 1 -name "*.md" | xargs -I {} mv {} docs/ 2>/dev/null || true
echo "🗑️  Removing empty directories..."
find . -type d -empty -delete 2>/dev/null || true
echo "📊 Generating cleanup report..."
{
    echo "COMPREHENSIVE CODEBASE CLEANUP REPORT"
    echo "====================================="
    echo "Date: $(date)"
    echo "Backup directory: $BACKUP_DIR"
    echo ""
    echo "Files moved to backup:"
    ls -la "$BACKUP_DIR/" | wc -l
    echo ""
    echo "Remaining files by type:"
    echo "Dart files: $(find . -name "*.dart" | wc -l)"
    echo "JavaScript files: $(find . -name "*.js" | wc -l)"
    echo "TypeScript files: $(find . -name "*.ts" | wc -l)"
    echo "HTML files: $(find . -name "*.html" | wc -l)"
    echo "CSS files: $(find . -name "*.css" | wc -l)"
    echo "Python files: $(find . -name "*.py" | wc -l)"
} > "cleanup_report_$(date +%Y%m%d_%H%M%S).txt"
echo "✅ CLEANUP COMPLETE!"
echo "📊 Report saved to: cleanup_report_$(date +%Y%m%d_%H%M%S).txt"
echo "🗂️  Backup saved to: $BACKUP_DIR"
echo "📁 Moving documentation files..."
find . -maxdepth 1 -name "*.md" | xargs -I {} mv {} docs/ 2>/dev/null || true
echo "🗑️  Removing empty directories..."
find . -type d -empty -delete 2>/dev/null || true
echo "📊 Generating cleanup report..."
{
    echo "COMPREHENSIVE CODEBASE CLEANUP REPORT"
    echo "====================================="
    echo "Date: $(date)"
    echo "Backup directory: $BACKUP_DIR"
    echo ""
    echo "Files moved to backup:"
    ls -la "$BACKUP_DIR/" | wc -l
    echo ""
    echo "Remaining files by type:"
    echo "Dart files: $(find . -name "*.dart" | wc -l)"
    echo "JavaScript files: $(find . -name "*.js" | wc -l)"
    echo "TypeScript files: $(find . -name "*.ts" | wc -l)"
    echo "HTML files: $(find . -name "*.html" | wc -l)"
    echo "CSS files: $(find . -name "*.css" | wc -l)"
    echo "Python files: $(find . -name "*.py" | wc -l)"
} > "cleanup_report_$(date +%Y%m%d_%H%M%S).txt"
echo "✅ CLEANUP COMPLETE!"
echo "📊 Report saved to: cleanup_report_$(date +%Y%m%d_%H%M%S).txt"
echo "🗂️  Backup saved to: $BACKUP_DIR"
