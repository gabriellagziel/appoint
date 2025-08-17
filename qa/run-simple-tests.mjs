import { chromium } from "@playwright/test";
import { writeFile, mkdir } from "node:fs/promises";

// Simple test runner that bypasses Playwright config issues
async function runSimpleTests() {
  console.log("🧪 Running Simple E2E Tests...");
  
  await mkdir("qa/output/playwright", { recursive: true });
  
  const browser = await chromium.launch();
  const page = await browser.newPage();
  const results = [];
  
  // Test 1: Marketing app
  try {
    console.log("Testing Marketing app...");
    await page.goto("http://localhost:3000/");
    await page.waitForTimeout(2000);
    
    // Check for key elements
    const hasTitle = await page.getByText(/ultimate time organizer/i).isVisible();
    const hasPersonalLink = await page.getByRole("link", { name: "Personal", exact: true }).isVisible();
    const hasBusinessLink = await page.getByRole("link", { name: "Business", exact: true }).isVisible();
    
    results.push({
      app: "marketing",
      status: hasTitle && hasPersonalLink && hasBusinessLink ? "PASS" : "FAIL",
      details: { hasTitle, hasPersonalLink, hasBusinessLink }
    });
    
    console.log(`✅ Marketing: ${hasTitle && hasPersonalLink && hasBusinessLink ? "PASS" : "FAIL"}`);
  } catch (error) {
    results.push({ app: "marketing", status: "ERROR", error: error.message });
    console.log(`❌ Marketing: ERROR - ${error.message}`);
  }
  
  // Test 2: Business app
  try {
    console.log("Testing Business app...");
    await page.goto("http://localhost:3002/");
    await page.waitForTimeout(2000);
    
    const hasNavigation = await page.getByRole("navigation").isVisible();
    const hasBanner = await page.getByRole("banner").isVisible();
    
    results.push({
      app: "business",
      status: hasNavigation && hasBanner ? "PASS" : "FAIL",
      details: { hasNavigation, hasBanner }
    });
    
    console.log(`✅ Business: ${hasNavigation && hasBanner ? "PASS" : "FAIL"}`);
  } catch (error) {
    results.push({ app: "business", status: "ERROR", error: error.message });
    console.log(`❌ Business: ERROR - ${error.message}`);
  }
  
  // Test 3: Admin app
  try {
    console.log("Testing Admin app...");
    await page.goto("http://localhost:3003/");
    await page.waitForTimeout(2000);
    
    const hasContent = await page.getByRole("heading", { name: "Admin Dashboard" }).isVisible();
    
    results.push({
      app: "admin",
      status: hasContent ? "PASS" : "FAIL",
      details: { hasContent }
    });
    
    console.log(`✅ Admin: ${hasContent ? "PASS" : "FAIL"}`);
  } catch (error) {
    results.push({ app: "admin", status: "ERROR", error: error.message });
    console.log(`❌ Admin: ERROR - ${error.message}`);
  }
  
  // Test 4: Personal app (Flutter)
  try {
    console.log("Testing Personal app...");
    await page.goto("http://localhost:3020/#/home");
    await page.waitForTimeout(3000); // Flutter needs more time
    
    const hasContent = await page.getByText(/create|meeting|reminder/i).isVisible();
    
    results.push({
      app: "personal",
      status: hasContent ? "PASS" : "FAIL",
      details: { hasContent }
    });
    
    console.log(`✅ Personal: ${hasContent ? "PASS" : "FAIL"}`);
  } catch (error) {
    results.push({ app: "personal", status: "ERROR", error: error.message });
    console.log(`❌ Personal: ERROR - ${error.message}`);
  }
  
  await browser.close();
  
  // Save results
  const htmlReport = `
<!DOCTYPE html>
<html>
<head><title>Simple E2E Test Results</title></head>
<body>
<h1>Simple E2E Test Results</h1>
<pre>${JSON.stringify(results, null, 2)}</pre>
</body>
</html>`;
  
  await writeFile("qa/output/playwright/index.html", htmlReport);
  console.log("\n📊 Test Results:", results);
  console.log("📁 Report saved to: qa/output/playwright/index.html");
  
  // Exit with error code if any tests failed
  const failedTests = results.filter(r => r.status === "FAIL" || r.status === "ERROR");
  if (failedTests.length > 0) {
    console.log(`❌ ${failedTests.length} tests failed`);
    process.exitCode = 1;
  } else {
    console.log("✅ All tests passed!");
  }
}

runSimpleTests().catch(console.error);
