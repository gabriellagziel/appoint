const express = require('express');
const cors = require('cors');
const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp();
}

const app = express();
const PORT = process.env.PORT || 5001;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Serve the dashboard at root
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Serve auth page
app.get('/auth.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'auth.html'));
});

// Serve landing page
app.get('/landing', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'landing.html'));
});

// Serve Next.js-style landing page
app.get('/next', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'next', 'index.html'));
});

app.get('/next/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'next', 'index.html'));
});

// Serve static files from next directory
app.use('/next', express.static(path.join(__dirname, 'public', 'next')));

// Serve docs
app.get('/docs/index.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'docs', 'index.html'));
});

// Serve dashboard routes
app.get('/dashboard', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'dashboard', 'index.html'));
});

app.get('/dashboard/:page', (req, res) => {
  const page = req.params.page;
  const filePath = path.join(__dirname, 'public', 'dashboard', `${page}.html`);

  // Check if file exists
  if (require('fs').existsSync(filePath)) {
    res.sendFile(filePath);
  } else {
    res.redirect('/dashboard/usage.html');
  }
});

// Serve dashboard static assets
app.use('/dashboard', express.static(path.join(__dirname, 'public', 'dashboard')));

// Serve mock data
app.use('/mock', express.static(path.join(__dirname, 'public', 'mock')));

// Serve test dashboard page
app.get('/test-dashboard', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'test-dashboard.html'));
});

app.get('/test-dashboard-fixed', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'test-dashboard-fixed.html'));
});

app.get('/dashboard/billing-fixed', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'dashboard', 'billing-fixed.html'));
});

app.get('/dashboard/settings-fixed', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'dashboard', 'settings-fixed.html'));
});

app.get('/dashboard/settings-enhanced', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'dashboard', 'settings-enhanced.html'));
});

app.get('/dashboard/billing-enhanced', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'dashboard', 'billing-enhanced.html'));
});

// Serve debug dashboard page
app.get('/debug-dashboard', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'debug-dashboard.html'));
});

// Serve simplified dashboard
app.get('/simple-dashboard', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'dashboard', 'simple-usage.html'));
});

// Serve navigation test page
app.get('/test-navigation', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'test-navigation.html'));
});

// Serve comprehensive test page
app.get('/test-all-pages', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'test-all-pages.html'));
});

// Serve complete dashboard
app.get('/complete-dashboard', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'complete-dashboard.html'));
});

// Health check endpoint
app.get('/api/status', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'App-Oint Enterprise API',
    version: '1.0.0',
    environment: 'local'
  });
});

// Register business endpoint
app.post('/registerBusiness', async (req, res) => {
  try {
    const { name, email, industry } = req.body || {};

    if (!name || !email) {
      res.status(400).json({ error: 'Missing required fields: name, email' });
      return;
    }

    const db = admin.firestore();
    const crypto = require('crypto');
    const apiKey = crypto.randomBytes(32).toString('hex');
    const docRef = db.collection('business_accounts').doc();

    const data = {
      name,
      email,
      industry: industry || null,
      apiKey,
      monthlyQuota: 1000,
      usageThisMonth: 0,
      status: 'active',
      ipWhitelistEnabled: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await docRef.set(data);

    res.status(201).json({
      id: docRef.id,
      apiKey,
      quota: data.monthlyQuota,
      message: 'Business registered successfully'
    });
  } catch (err) {
    console.error('registerBusiness error:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Enterprise API running on http://localhost:${PORT}`);
  console.log(`📊 Dashboard: http://localhost:${PORT}/`);
  console.log(`📊 Health check: http://localhost:${PORT}/api/status`);
  console.log(`📝 Register business: POST http://localhost:${PORT}/registerBusiness`);
}); app.get("/working-dashboard", (req, res) => { res.sendFile(path.join(__dirname, "public", "working-dashboard.html")); });
