import ClientHome from '@/components/personal/ClientHome';
import { normalizeLocale } from '../../../i18n';

export default function HomePage({ params }: { params: { locale: string } }) {
    const loc = normalizeLocale(params.locale);
    return (
        <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8 space-y-5">
            <div className="space-y-1">
                <h1 className="text-2xl font-semibold">Hi Gabriel 👋</h1>
                <p className="opacity-70">What would you like to do today?</p>
            </div>
            <ClientHome />
        </main>
    );
}

