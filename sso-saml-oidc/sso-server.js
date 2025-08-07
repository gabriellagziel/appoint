const express = require('express');
const passport = require('passport');
const SamlStrategy = require('passport-saml').Strategy;
const { Issuer, Strategy: OidcStrategy } = require('openid-client');
const session = require('express-session');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3002;

// Session configuration
app.use(session({
    secret: process.env.SESSION_SECRET || 'your-session-secret',
    resave: false,
    saveUninitialized: false,
    cookie: { secure: process.env.NODE_ENV === 'production' }
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(passport.initialize());
app.use(passport.session());

// Load configurations
const samlConfig = JSON.parse(fs.readFileSync(path.join(__dirname, 'saml-config/okta-config.xml'), 'utf8'));
const oidcConfig = JSON.parse(fs.readFileSync(path.join(__dirname, 'oidc-config/azure-ad-config.json'), 'utf8'));

// SAML Strategy for Okta
passport.use(new SamlStrategy({
    entryPoint: process.env.OKTA_ENTRY_POINT || 'https://your-okta-domain.okta.com/app/your-app-id/sso/saml',
    issuer: 'https://appoint.com/saml/metadata',
    callbackUrl: 'https://appoint.com/saml/acs',
    cert: process.env.OKTA_CERT || fs.readFileSync(path.join(__dirname, 'certs/okta-cert.pem'), 'utf8'),
    validateInResponseTo: false,
    requestIdExpirationPeriodMs: 28800000, // 8 hours
    decryptionPvk: process.env.SAML_DECRYPTION_KEY ? fs.readFileSync(process.env.SAML_DECRYPTION_KEY, 'utf8') : null,
    privateCert: process.env.SAML_PRIVATE_KEY ? fs.readFileSync(process.env.SAML_PRIVATE_KEY, 'utf8') : null,
    signatureAlgorithm: 'sha256'
}, (profile, done) => {
    // Map SAML attributes to user profile
    const user = {
        id: profile.nameID,
        email: profile.email,
        firstName: profile.firstName,
        lastName: profile.lastName,
        company: profile.company,
        department: profile.department,
        groups: profile.groups ? profile.groups.split(',') : [],
        provider: 'saml',
        providerId: 'okta'
    };

    return done(null, user);
}));

// OpenID Connect Strategy for Azure AD
async function setupOidcStrategy() {
    try {
        const issuer = await Issuer.discover(oidcConfig.issuer.replace('{tenant_id}', oidcConfig.tenant_id));

        passport.use(new OidcStrategy({
            issuer,
            client_id: oidcConfig.client_id,
            client_secret: oidcConfig.client_secret,
            redirect_uri: oidcConfig.redirect_uri,
            scope: oidcConfig.scope,
            response_type: oidcConfig.response_type,
            response_mode: oidcConfig.response_mode
        }, (tokenSet, userinfo, done) => {
            // Map OIDC claims to user profile
            const user = {
                id: userinfo.sub,
                email: userinfo.email,
                firstName: userinfo.given_name,
                lastName: userinfo.family_name,
                fullName: userinfo.name,
                company: userinfo.company,
                department: userinfo.department,
                groups: userinfo.groups || [],
                roles: userinfo.roles || [],
                provider: 'oidc',
                providerId: 'azure-ad'
            };

            return done(null, user);
        }));
    } catch (error) {
        console.error('Failed to setup OIDC strategy:', error);
    }
}

// Serialize user for session
passport.serializeUser((user, done) => {
    done(null, user);
});

passport.deserializeUser((user, done) => {
    done(null, user);
});

// Routes
app.get('/saml/metadata', (req, res) => {
    res.type('application/xml');
    res.send(samlConfig);
});

app.get('/saml/login', passport.authenticate('saml', {
    failureRedirect: '/login',
    failureFlash: true
}));

app.post('/saml/acs', passport.authenticate('saml', {
    failureRedirect: '/login',
    failureFlash: true
}), (req, res) => {
    // Successful SAML authentication
    res.redirect('/dashboard');
});

app.get('/saml/slo', (req, res) => {
    req.logout();
    res.redirect('/');
});

// OIDC Routes
app.get('/oidc/login', passport.authenticate('oidc', {
    failureRedirect: '/login',
    failureFlash: true
}));

app.get('/oidc/callback', passport.authenticate('oidc', {
    failureRedirect: '/login',
    failureFlash: true
}), (req, res) => {
    // Successful OIDC authentication
    res.redirect('/dashboard');
});

app.get('/oidc/logout', (req, res) => {
    req.logout();
    res.redirect('/');
});

// Authentication status
app.get('/auth/status', (req, res) => {
    if (req.isAuthenticated()) {
        res.json({
            authenticated: true,
            user: {
                id: req.user.id,
                email: req.user.email,
                firstName: req.user.firstName,
                lastName: req.user.lastName,
                company: req.user.company,
                provider: req.user.provider
            }
        });
    } else {
        res.json({ authenticated: false });
    }
});

// Enterprise user creation/update
app.post('/api/enterprise/users', (req, res) => {
    if (!req.isAuthenticated()) {
        return res.status(401).json({ error: 'Unauthorized' });
    }

    const { email, firstName, lastName, company, department, role } = req.body;

    // Create or update enterprise user
    const enterpriseUser = {
        id: req.user.id,
        email: email || req.user.email,
        firstName: firstName || req.user.firstName,
        lastName: lastName || req.user.lastName,
        company: company || req.user.company,
        department: department || req.user.department,
        role: role || 'user',
        provider: req.user.provider,
        providerId: req.user.providerId,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    // In production, save to database
    res.json({ success: true, user: enterpriseUser });
});

// Logout
app.get('/logout', (req, res) => {
    req.logout();
    res.redirect('/');
});

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Initialize OIDC and start server
setupOidcStrategy().then(() => {
    app.listen(PORT, () => {
        console.log(`SSO server running on port ${PORT}`);
        console.log('Available endpoints:');
        console.log('- SAML: /saml/login, /saml/metadata, /saml/acs, /saml/slo');
        console.log('- OIDC: /oidc/login, /oidc/callback, /oidc/logout');
        console.log('- Auth: /auth/status, /logout');
    });
}).catch(error => {
    console.error('Failed to start SSO server:', error);
}); 