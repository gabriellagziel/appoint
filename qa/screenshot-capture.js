import { chromium } from 'playwright';

async function captureScreenshots() {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  // Set viewport size
  await page.setViewportSize({ width: 1280, height: 720 });
  
  const services = [
    {
      name: 'marketing',
      url: 'https://app-oint-marketing-kxhy9.ondigitalocean.app/',
      description: 'Marketing Landing Page'
    },
    {
      name: 'business',
      url: 'https://app-oint-business-asit5.ondigitalocean.app/',
      description: 'Business Studio Application'
    },
    {
      name: 'enterprise',
      url: 'https://app-oint-enterprise-kpxyy.ondigitalocean.app/',
      description: 'Enterprise Portal'
    },
    {
      name: 'personal',
      url: 'https://appoint-app-ue5z4.ondigitalocean.app/',
      description: 'Personal Flutter PWA'
    }
  ];

  console.log('🎯 Starting screenshot capture for App-Oint services...\n');

  for (const service of services) {
    try {
      console.log(`📸 Capturing ${service.name} (${service.description})...`);
      
      // Navigate to the service
      await page.goto(service.url, { waitUntil: 'networkidle', timeout: 30000 });
      
      // Wait a bit for any dynamic content to load
      await page.waitForTimeout(2000);
      
      // Take screenshot
      await page.screenshot({ 
        path: `screenshots/${service.name}.png`,
        fullPage: true 
      });
      
      console.log(`✅ ${service.name}.png saved successfully`);
      
    } catch (error) {
      console.error(`❌ Failed to capture ${service.name}: ${error.message}`);
    }
  }

  // Test the unified platform
  try {
    console.log('\n📸 Capturing unified platform...');
    await page.goto('https://app-oint-platform-3g3k2.ondigitalocean.app/', { 
      waitUntil: 'networkidle', 
      timeout: 30000 
    });
    await page.waitForTimeout(2000);
    await page.screenshot({ 
      path: 'screenshots/unified-platform.png',
      fullPage: true 
    });
    console.log('✅ unified-platform.png saved successfully');
  } catch (error) {
    console.error(`❌ Failed to capture unified platform: ${error.message}`);
  }

  await browser.close();
  console.log('\n🎉 Screenshot capture completed!');
}

captureScreenshots().catch(console.error);
