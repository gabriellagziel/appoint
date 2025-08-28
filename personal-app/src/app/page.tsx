import Link from 'next/link';

export default function Home() {
    const defaultLocale = 'en';
    return (
        <main>
            <h1>App-Oint Personal</h1>
            <p>Choose your language:</p>
            <ul>
                {['en','he','it'].map(l => (
                    <li key={l}><Link href={`/${l}`}>{l}</Link></li>
                ))}
            </ul>
            <p>Default: <Link href={`/${defaultLocale}`}>Continue</Link></p>
        </main>
    );
}
