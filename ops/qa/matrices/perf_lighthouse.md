# Performance Lighthouse Matrix

## Overview
This document tracks Lighthouse performance scores across all web applications.

## Performance Test Status

### Marketing App
- **Status**: ⚠️ Dev server startup non-trivial
- **Test Command**: `npm run dev` (from marketing/ directory)
- **Port**: 3000 (default Next.js)
- **Lighthouse Command**: `npx @lhci/cli autorun --collect.url=http://localhost:3000 --upload.target=filesystem --upload.outputDir=./.lhci`
- **Last Attempt**: 2025-08-17 21:32 UTC (failed - server not responding)
- **Notes**: TODO - Start dev server manually and run Lighthouse

### Business App
- **Status**: ⚠️ Static HTML app - no dev server
- **Test Command**: N/A (static files)
- **Port**: N/A
- **Lighthouse Command**: N/A
- **Notes**: Static HTML app, no performance testing needed

### Enterprise App
- **Status**: ⚠️ Dev server startup non-trivial
- **Test Command**: `npm run dev` (from enterprise-app/ directory)
- **Port**: 5000 (custom)
- **Lighthouse Command**: `npx @lhci/cli autorun --collect.url=http://localhost:5000 --upload.target=filesystem --upload.outputDir=./.lhci`
- **Notes**: TODO - Start dev server manually and run Lighthouse

### Dashboard App
- **Status**: ⚠️ Dev server startup non-trivial
- **Test Command**: `npm run dev` (from dashboard/ directory)
- **Port**: 3000 (default Next.js)
- **Lighthouse Command**: `npx @lhci/cli autorun --collect.url=http://localhost:3000 --upload.target=filesystem --upload.outputDir=./.lhci`
- **Notes**: TODO - Start dev server manually and run Lighthouse

## Lighthouse Results

### No Results Available
- **Reason**: Dev servers not started during fast-track session
- **Impact**: Performance scores not captured
- **Next Steps**: Manual performance testing required

## Performance Testing Commands

### Marketing App
```bash
cd marketing
npm run dev
# Wait for server to start, then in another terminal:
npx @lhci/cli autorun --collect.url=http://localhost:3000 --upload.target=filesystem --upload.outputDir=./.lhci
```

### Enterprise App
```bash
cd enterprise-app
npm run dev
# Wait for server to start, then in another terminal:
npx @lhci/cli autorun --collect.url=http://localhost:5000 --upload.target=filesystem --upload.outputDir=./.lhci
```

### Dashboard App
```bash
cd dashboard
npm run dev
# Wait for server to start, then in another terminal:
npx @lhci/cli autorun --collect.url=http://localhost:3000 --upload.target=filesystem --upload.outputDir=./.lhci
```

## Summary
- **Total Apps**: 4
- **Apps Tested**: 0/4
- **Performance Scores**: None captured
- **Status**: ⚠️ Performance tests deferred due to dev server complexity
- **Next Steps**: Manual performance testing required for each app

## Notes
- **Fast-track limitation**: Dev server startup complexity prevented automated testing
- **Business app**: Static HTML, no performance testing needed
- **Admin app**: Not included in performance testing scope
- **Priority**: Low - performance testing can be done in separate session
