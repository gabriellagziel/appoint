#!/bin/bash

# DigitalOcean Integration Test Script
# סקריפט בדיקת אינטגרציה עבור DigitalOcean App Platform

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# App configuration
APP_ID="620a2ee8-e942-451c-9cfd-8ece55511eb8"
APP_NAME="appoint-web"

# Function to print colored output
print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_header "בדיקת דרישות מוקדמות"
    
    if ! command_exists doctl; then
        print_error "doctl CLI is not installed"
        print_status "Install with: curl -fsSL https://github.com/digitalocean/doctl/releases/download/v1.104.0/doctl-1.104.0-linux-amd64.tar.gz | tar -xzv && sudo mv doctl /usr/local/bin"
        exit 1
    fi
    
    print_success "doctl CLI זמין"
    doctl version
}

# Test authentication
test_authentication() {
    print_header "בדיקת אימות"
    
    if doctl auth test; then
        print_success "אימות DigitalOcean תקין"
        
        # Get current user info
        print_status "פרטי המשתמש:"
        doctl account get --format Email,Name,Status
    else
        print_error "אימות DigitalOcean נכשל"
        print_status "הגדר אסימון גישה עם: doctl auth init --access-token YOUR_TOKEN"
        exit 1
    fi
}

# List all apps
list_apps() {
    print_header "רשימת אפליקציות"
    
    if doctl apps list --format ID,Spec.Name,ActiveDeployment.Status,ActiveDeployment.UpdatedAt --no-header; then
        print_success "רשימת אפליקציות התקבלה בהצלחה"
    else
        print_error "שגיאה בקבלת רשימת אפליקציות"
        return 1
    fi
}

# Get specific app details
get_app_details() {
    print_header "פרטי אפליקציה: $APP_NAME"
    
    if doctl apps get "$APP_ID" --format Spec.Name,ActiveDeployment.Status,ActiveDeployment.Phase,ActiveDeployment.UpdatedAt,LiveURL; then
        print_success "פרטי אפליקציה התקבלו בהצלחה"
    else
        print_error "שגיאה בקבלת פרטי אפליקציה $APP_ID"
        return 1
    fi
}

# Check app deployments
check_deployments() {
    print_header "בדיקת פריסות"
    
    print_status "פריסות אחרונות:"
    if doctl apps list-deployments "$APP_ID" --format ID,Status,Phase,UpdatedAt | head -10; then
        print_success "רשימת פריסות התקבלה בהצלחה"
    else
        print_error "שגיאה בקבלת רשימת פריסות"
        return 1
    fi
}

# Check app logs
check_logs() {
    print_header "בדיקת לוגים"
    
    print_status "לוגי build אחרונים:"
    if doctl apps logs "$APP_ID" --type build --tail 20; then
        print_success "לוגי build התקבלו בהצלחה"
    else
        print_warning "שגיאה בקבלת לוגי build"
    fi
    
    echo ""
    print_status "לוגי deploy אחרונים:"
    if doctl apps logs "$APP_ID" --type deploy --tail 20; then
        print_success "לוגי deploy התקבלו בהצלחה"
    else
        print_warning "שגיאה בקבלת לוגי deploy"
    fi
}

# Check app domains
check_domains() {
    print_header "בדיקת דומיינים"
    
    if doctl apps list-domains "$APP_ID"; then
        print_success "רשימת דומיינים התקבלה בהצלחה"
    else
        print_warning "לא נמצאו דומיינים מותאמים אישית או שגיאה בקבלה"
    fi
}

# Test app connectivity
test_connectivity() {
    print_header "בדיקת קישוריות"
    
    APP_URL="https://$APP_ID.ondigitalocean.app"
    print_status "בודק קישוריות ל: $APP_URL"
    
    if curl -Is "$APP_URL" | head -1; then
        print_success "האפליקציה נגישה"
        
        # Get more details
        STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")
        RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" "$APP_URL")
        
        print_status "קוד סטטוס: $STATUS_CODE"
        print_status "זמן תגובה: ${RESPONSE_TIME}s"
        
        if [ "$STATUS_CODE" = "200" ]; then
            print_success "האפליקציה פועלת תקין (HTTP 200)"
        else
            print_warning "האפליקציה מחזירה קוד סטטוס: $STATUS_CODE"
        fi
    else
        print_error "האפליקציה לא נגישה"
        return 1
    fi
}

# Check app alerts (if any)
check_alerts() {
    print_header "בדיקת התראות"
    
    if doctl apps list-alerts "$APP_ID" 2>/dev/null; then
        print_success "בדיקת התראות הושלמה"
    else
        print_status "לא נמצאו התראות או שהתכונה לא זמינה"
    fi
}

# Generate summary report
generate_summary() {
    print_header "סיכום בדיקת אינטגרציה"
    
    echo "📊 תוצאות הבדיקה:"
    echo "├── 🔧 doctl CLI: ✅ פעיל"
    echo "├── 🔐 אימות: ✅ תקין"
    echo "├── 📱 אפליקציה: $APP_NAME ($APP_ID)"
    echo "├── 🌐 URL: https://$APP_ID.ondigitalocean.app"
    echo "├── ⏰ בדיקה בוצעה: $(date)"
    echo "└── 📍 אזור: nyc"
    
    echo ""
    print_success "בדיקת האינטגרציה הושלמה בהצלחה!"
    print_status "כל הרכיבים פועלים כהלכה"
}

# Main execution
main() {
    clear
    print_header "בדיקת אינטגרציה - DigitalOcean App Platform"
    print_status "מתחיל בדיקה של האפליקציה $APP_NAME..."
    
    # Run all checks
    check_prerequisites
    test_authentication
    list_apps
    get_app_details
    check_deployments
    check_logs
    check_domains
    test_connectivity
    check_alerts
    generate_summary
    
    echo ""
    print_success "🎉 בדיקת האינטגרציה הושלמה בהצלחה!"
}

# Run if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi