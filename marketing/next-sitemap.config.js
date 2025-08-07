/** @type {import('next-sitemap').IConfig} */
module.exports = {
  siteUrl: process.env.SITE_URL || 'https://app-oint.com',
  generateRobotsTxt: true,
  generateIndexSitemap: false,
  exclude: ['/admin/*', '/404', '/500'],
  
  // Generate sitemaps for all locales
  alternateRefs: [
    {
      href: 'https://app-oint.com',
      hreflang: 'x-default',
    },
    {
      href: 'https://app-oint.com/en',
      hreflang: 'en',
    },
    {
      href: 'https://app-oint.com/es',
      hreflang: 'es',
    },
    {
      href: 'https://app-oint.com/fr',
      hreflang: 'fr',
    },
    {
      href: 'https://app-oint.com/de',
      hreflang: 'de',
    },
    // Add more languages as needed
  ],

  robotsTxtOptions: {
    policies: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/admin/', '/api/', '/_next/'],
      },
    ],
    additionalSitemaps: [
      'https://app-oint.com/sitemap.xml',
    ],
  },

  transform: async (config, path) => {
    return {
      loc: path,
      changefreq: config.changefreq,
      priority: config.priority,
      lastmod: config.autoLastmod ? new Date().toISOString() : undefined,
      alternateRefs: config.alternateRefs ?? [],
    }
  },
}