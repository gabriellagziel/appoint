# App-Oint Personal

אפליקציה לניהול פגישות אישיות וזיכרונות, בנויה עם Next.js ו-TypeScript.

## ✨ תכונות

- 🏠 **דף בית** - סקירה מהירה של היום עם פעולות מהירות
- 📅 **יומן** - תצוגת רשימה וחודש לאירועים
- ➕ **יצירת פגישות** - Wizard של 4 צעדים עם יצירת הזמנות
- ⏰ **יצירת זיכרונות** - הוספת תזכורות עם קטגוריות ועדיפויות
- 👥 **קבוצות** - ניהול קבוצות עבודה וחברים
- 👨‍👩‍👧 **משפחה** - ניהול חברי משפחה וקשר
- 🎮 **זמן משחק** - ניהול משחקים ופעילויות
- ⚙️ **הגדרות** - התאמה אישית של האפליקציה
- 📱 **PWA** - התקנה כאפליקציה ניידת

## 🚀 התקנה והפעלה

### דרישות מקדימות

- Node.js 18+ 
- npm או yarn

### התקנה

```bash
# התקן תלויות
npm install

# הפעל בפתח
npm run dev

# בנייה לייצור
npm run build

# הפעלה מייצור
npm start
```

### משתני סביבה

צור קובץ `.env.local` עם:

```env
NEXT_PUBLIC_BASE_URL=https://personal.app-oint.com
```

## 🏗️ ארכיטקטורה

### מבנה תיקיות

```
src/
├── app/                    # Next.js App Router
│   ├── api/               # API endpoints
│   │   ├── meetings/      # יצירת פגישות
│   │   └── booking/       # הזמנות וסלוטים
│   ├── create/            # יצירת תוכן
│   │   ├── meeting/       # Wizard פגישות
│   │   └── reminder/      # יצירת זיכרונות
│   ├── m/                 # עמודי הזמנה
│   ├── agenda/            # יומן
│   ├── groups/            # קבוצות
│   ├── family/            # משפחה
│   ├── playtime/          # זמן משחק
│   └── settings/          # הגדרות
├── components/             # קומפוננטות משותפות
└── types/                  # הגדרות TypeScript
```

### טכנולוגיות

- **Frontend**: Next.js 14, React 18, TypeScript
- **Styling**: Tailwind CSS
- **PWA**: Manifest, Service Worker
- **Deployment**: Vercel

## 📱 PWA

האפליקציה תומכת ב-PWA עם:

- Manifest מלא עם אייקונים
- Service Worker (להמשך)
- התקנה כאפליקציה ניידת
- קיצורי דרך מהירים

## 🔒 אבטחה

- Headers אבטחה ב-`vercel.json`
- Content Security Policy
- HTTPS בלבד
- Rate limiting (להמשך)

## 🚀 דיפלוי

### Vercel (מומלץ)

```bash
# התקן Vercel CLI
npm i -g vercel

# דפלוי
vercel --prod
```

### הגדרת דומיין

1. צור פרויקט חדש ב-Vercel
2. חבר את הדומיין `personal.app-oint.com`
3. הגדר DNS: `CNAME personal -> cname.vercel-dns.com`

## 🧪 בדיקות

```bash
# בדיקת TypeScript
npm run type-check

# בדיקת ESLint
npm run lint

# בנייה לבדיקה
npm run build
```

## 📋 קריטריונים ל-"Done"

- [x] ✅ דף בית עם Quick Actions ו-Upcoming
- [x] ✅ Wizard יצירת פגישות (4 צעדים)
- [x] ✅ עמוד הזמנה עם בחירת סלוטים
- [x] ✅ יומן עם תצוגת רשימה ותאריכים
- [x] ✅ יצירת זיכרונות עם קטגוריות
- [x] ✅ ניהול קבוצות ומשפחה
- [x] ✅ זמן משחק עם משחקים
- [x] ✅ הגדרות עם אפשרויות שונות
- [x] ✅ API endpoints בסיסיים
- [x] ✅ PWA manifest מלא
- [x] ✅ הגדרות אבטחה ב-vercel.json
- [x] ✅ Bottom Navigation
- [x] ✅ RTL ו-עברית
- [x] ✅ Mobile-first design
- [x] ✅ Tailwind CSS styling

## 🔮 תכונות עתידיות

- [ ] 🔐 אימות משתמשים (Google OAuth)
- [ ] 💾 מסד נתונים (Postgres + Prisma)
- [ ] 📧 שליחת הזמנות במייל
- [ ] 📅 ייצוא ICS
- [ ] 🔔 התראות push
- [ ] 💳 תשלומים (Stripe)
- [ ] 📊 אנליטיקה (Sentry)

## 🤝 תרומה

1. Fork את הפרויקט
2. צור branch חדש (`git checkout -b feature/amazing-feature`)
3. Commit את השינויים (`git commit -m 'Add amazing feature'`)
4. Push ל-branch (`git push origin feature/amazing-feature`)
5. פתח Pull Request

## 📄 רישיון

MIT License - ראה קובץ [LICENSE](LICENSE) לפרטים.

## 📞 תמיכה

- 📧 Email: <support@app-oint.com>
- 🌐 Website: <https://app-oint.com>
- 📱 App: App-Oint Personal

---

**App-Oint Personal** - ניהול פגישות אישיות וזיכרונות 🚀
