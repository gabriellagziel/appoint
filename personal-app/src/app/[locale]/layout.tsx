import "react-big-calendar/lib/addons/dragAndDrop/styles.css";
import "react-big-calendar/lib/css/react-big-calendar.css";

import dynamic from "next/dynamic";
const AuthHydrator = dynamic(() => import("@/components/auth/AuthHydrator"), { ssr: false });

export default function LocaleLayout({
    children, params: { locale },
}: { children: React.ReactNode; params: { locale: string } }) {
    return (
        <html lang={locale} suppressHydrationWarning>
            <body>
                <AuthHydrator />
                {children}
            </body>
        </html>
    );
}
