#!/bin/bash

echo "🔧 תיקון מהיר לבעיית SSL של app-oint.com"
echo "============================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# Step 1: Check current status
echo ""
print_info "בודק מצב נוכחי של הדומיין..."
echo ""

# Test the problematic domain
echo "בדיקת https://app-oint.com..."
if curl -s --connect-timeout 5 "https://app-oint.com" > /dev/null 2>&1; then
    print_status "הדומיין עובד! הבעיה נפתרה."
    exit 0
else
    print_error "הדומיין עדיין לא עובד - נמשיך עם התיקון"
fi

# Test the working domain
echo "בדיקת https://www.app-oint.com..."
if curl -s --connect-timeout 5 "https://www.app-oint.com" > /dev/null 2>&1; then
    print_status "www.app-oint.com עובד בסדר"
else
    print_warning "גם www.app-oint.com לא עובד"
fi

# Step 2: Firebase authentication check
echo ""
print_info "בודק אותנטיקציה Firebase..."

if firebase projects:list > /dev/null 2>&1; then
    print_status "מחובר ל-Firebase!"
    
    # Step 3: List hosting sites
    echo ""
    print_info "רשימת אתרי Hosting:"
    firebase hosting:sites:list
    
    # Step 4: Try to connect the domain
    echo ""
    print_info "מנסה לחבר את הדומיין app-oint.com..."
    print_warning "זה עלול לדרוש אימות ידני ב-Firebase Console"
    
    if firebase hosting:connect app-oint.com --confirm 2>/dev/null; then
        print_status "הדומיין חובר בהצלחה!"
    else
        print_warning "נדרש אימות ידני"
    fi
    
else
    print_error "לא מחובר ל-Firebase"
    echo ""
    print_info "השלבים הבאים:"
    echo "1. התחבר ל-Firebase:"
    echo "   firebase login"
    echo ""
    echo "2. הגדר את הפרויקט:"
    echo "   firebase use app-oint-core"
    echo ""
    echo "3. הרץ את הסקריפט שוב:"
    echo "   ./fix_ssl_now.sh"
fi

# Step 5: Manual instructions
echo ""
echo "📋 שלבים ידניים נדרשים:"
echo "========================"
print_warning "יש לעבור ל-Firebase Console ולהשלים את החיבור:"
echo ""
echo "1. היכנס ל: https://console.firebase.google.com"
echo "2. בחר פרויקט: app-oint-core"
echo "3. Hosting → Add custom domain"
echo "4. הכנס: app-oint.com"
echo "5. עקב אחר הוראות האימות"
echo ""
print_info "אחרי האימות, Firebase ייתן לך רשומות DNS לעדכון"

# Step 6: DNS check
echo ""
print_info "בדיקת DNS נוכחית:"
echo "=================="

for domain in "app-oint.com" "www.app-oint.com"; do
    echo ""
    echo "בודק DNS עבור: $domain"
    if nslookup "$domain" > /dev/null 2>&1; then
        print_status "DNS נמצא עבור $domain"
        nslookup "$domain" | grep "Address:" | tail -n +2
    else
        print_error "אין DNS עבור $domain"
    fi
done

# Step 7: Final status check
echo ""
print_info "בדיקה סופית:"
./check_domain_status.sh

echo ""
print_info "לעזרה נוספת, ראה: ssl_certificate_fix_guide.md"