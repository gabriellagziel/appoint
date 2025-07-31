const express = require('express'), FeatureFlags = require('./feature-flags');
const app = express(), flags = new FeatureFlags();
app.use(flags.middleware());
app.get('/api/beta-feature', (req, res) => {
    if (!req.flags.betaFeature) return res.status(403).json({ error: 'disabled' });
    res.json({ message: 'beta active' });
});
// ...rest of app
app.listen(3000, () => {
    console.log('App-Oint server running on port 3000');
}); 