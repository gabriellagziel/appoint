import { LOCALES } from '../i18n';

export default function sitemap() {
    const baseUrl = 'https://personal.app-oint.com';

    const routes = [
        {
            url: baseUrl,
            lastModified: new Date(),
            changeFrequency: 'daily',
            priority: 1,
        },
    ];

    // Add locale-specific routes
    LOCALES.forEach(locale => {
        routes.push(
            {
                url: `${baseUrl}/${locale}`,
                lastModified: new Date(),
                changeFrequency: 'daily',
                priority: 0.9,
            },
            {
                url: `${baseUrl}/${locale}/create/meeting`,
                lastModified: new Date(),
                changeFrequency: 'weekly',
                priority: 0.8,
            },
            {
                url: `${baseUrl}/${locale}/meetings`,
                lastModified: new Date(),
                changeFrequency: 'daily',
                priority: 0.8,
            },
            {
                url: `${baseUrl}/${locale}/home`,
                lastModified: new Date(),
                changeFrequency: 'weekly',
                priority: 0.7,
            },
            {
                url: `${baseUrl}/${locale}/reminders`,
                lastModified: new Date(),
                changeFrequency: 'weekly',
                priority: 0.6,
            },
            {
                url: `${baseUrl}/${locale}/groups`,
                lastModified: new Date(),
                changeFrequency: 'weekly',
                priority: 0.6,
            },
            {
                url: `${baseUrl}/${locale}/family`,
                lastModified: new Date(),
                changeFrequency: 'weekly',
                priority: 0.6,
            },
            {
                url: `${baseUrl}/${locale}/settings`,
                lastModified: new Date(),
                changeFrequency: 'monthly',
                priority: 0.5,
            },
            {
                url: `${baseUrl}/${locale}/playtime`,
                lastModified: new Date(),
                changeFrequency: 'weekly',
                priority: 0.6,
            }
        );
    });

    return routes;
}

