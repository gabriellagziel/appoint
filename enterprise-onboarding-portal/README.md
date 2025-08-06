# App-Oint Enterprise Portal

A production-ready enterprise onboarding portal with Firebase integration, API key management, usage tracking, and invoice generation.

## 🚀 Features

- **Firebase Authentication**: Secure user registration and login
- **API Key Management**: Generate, manage, and track API keys
- **Usage Analytics**: Real-time usage tracking and analytics
- **Invoice Generation**: Monthly invoice generation with bank transfer instructions
- **Rate Limiting**: Per-plan rate limiting and quota enforcement
- **Email Notifications**: Welcome emails and invoice delivery

## 📋 Prerequisites

- Node.js 18.x or higher
- Firebase project with Firestore enabled
- Gmail account for email notifications
- Bank account details for invoice generation

## 🔧 Setup Instructions

### 1. Firebase Configuration

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication and Firestore Database
3. Download your service account key:
   - Go to Project Settings > Service Accounts
   - Click "Generate new private key"
   - Save the JSON file as `service-account-key.json` in the project root

### 2. Environment Configuration

1. Copy the environment template:

   ```bash
   cp env.example .env
   ```

2. Update `.env` with your configuration:

   ```env
   # Firebase Configuration
   FIREBASE_SERVICE_ACCOUNT=base64_encoded_service_account_json
   FIREBASE_DATABASE_URL=https://your-project.firebaseio.com

   # Email Configuration (SMTP)
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASS=your-app-password
   EMAIL_HOST=smtp.gmail.com
   EMAIL_PORT=587

   # Server Configuration
   PORT=3000
   NODE_ENV=production

   # Invoice Configuration
   COMPANY_NAME=Your Company Name
   COMPANY_IBAN=your-iban-number
   COMPANY_SWIFT=your-swift-code
   COMPANY_ADDRESS=Your Company Address
   COMPANY_EMAIL=billing@yourcompany.com
   ```

3. Encode your Firebase service account JSON:

   ```bash
   # On macOS/Linux
   base64 -i service-account-key.json | tr -d '\n' > service-account-base64.txt
   # Copy the content and paste it as FIREBASE_SERVICE_ACCOUNT value
   ```

### 3. Install Dependencies

```bash
npm install
```

### 4. Database Setup

The application will automatically create the required Firestore collections:

- `users` - User profiles and subscription data
- `api_keys` - API key management
- `usage_logs` - API usage tracking
- `subscriptions` - Subscription plans and limits
- `invoices` - Invoice generation and tracking

### 5. Start the Application

```bash
# Development mode
npm run dev

# Production mode
npm start
```

The application will be available at `http://localhost:3000`

## 📚 API Documentation

### Authentication Endpoints

#### POST /api/register

Register a new enterprise user.

**Request Body:**

```json
{
  "companyName": "Enterprise Corp",
  "email": "admin@enterprise.com",
  "password": "securepassword",
  "plan": "enterprise"
}
```

**Response:**

```json
{
  "message": "Registration successful",
  "customToken": "firebase-custom-token",
  "user": {
    "uid": "user-id",
    "companyName": "Enterprise Corp",
    "email": "admin@enterprise.com",
    "plan": "enterprise"
  }
}
```

#### POST /api/login

Authenticate existing user.

**Request Body:**

```json
{
  "email": "admin@enterprise.com",
  "password": "securepassword"
}
```

### API Key Management

#### POST /api/keys/generate

Generate a new API key.

**Headers:** `Authorization: Bearer <firebase-token>`

**Request Body:**

```json
{
  "label": "Production API Key",
  "permissions": "admin",
  "expiryDate": "2025-12-31"
}
```

#### GET /api/keys/list

List all API keys for the authenticated user.

**Headers:** `Authorization: Bearer <firebase-token>`

### Usage Analytics

#### GET /api/usage/analytics

Get usage analytics for the authenticated user.

**Headers:** `Authorization: Bearer <firebase-token>`

#### GET /api/usage/enterprise/usage

Get usage data (protected by API key).

**Headers:** `X-API-Key: <api-key>`

### Invoice Management

#### GET /api/invoices/user

Get user's invoices.

**Headers:** `Authorization: Bearer <firebase-token>`

#### POST /api/invoices/generate-monthly

Generate monthly invoices for all users (admin only).

**Headers:** `Authorization: Bearer <firebase-token>`

## 🔐 Security Features

- **Firebase Authentication**: Secure user authentication with ID tokens
- **Rate Limiting**: Per-plan rate limiting to prevent abuse
- **API Key Validation**: Secure API key authentication and validation
- **CORS Protection**: Cross-origin request protection
- **Security Headers**: XSS protection and content type validation

## 📊 Subscription Plans

| Plan | Price | API Calls/Month | Features |
|------|-------|-----------------|----------|
| Basic | $99 | 10,000 | API Access, Basic Analytics, Email Support |
| Professional | $299 | 50,000 | API Access, Advanced Analytics, Priority Support, Custom Integrations |
| Enterprise | $999 | 200,000 | API Access, Advanced Analytics, Priority Support, Custom Integrations, White Label, Dedicated Support |

## 🧾 Invoice System

The system automatically generates monthly invoices based on:

- Base subscription cost
- Overage API calls ($0.001 per call)
- Bank transfer instructions included

### Invoice Features

- Automatic monthly generation
- Email delivery with HTML template
- Bank transfer payment instructions
- Downloadable invoice format
- Payment status tracking

## 🚀 Deployment

### DigitalOcean App Platform

1. Update `enterprise-app-spec.yaml` with your configuration
2. Deploy using DigitalOcean CLI:

   ```bash
   doctl apps create --spec enterprise-app-spec.yaml
   ```

### Docker Deployment

1. Build the Docker image:

   ```bash
   docker build -t appoint-enterprise .
   ```

2. Run the container:

   ```bash
   docker run -p 3000:3000 --env-file .env appoint-enterprise
   ```

## 🔧 Development

### Project Structure

```
enterprise-onboarding-portal/
├── server.js              # Main application server
├── firebase.js            # Firebase configuration
├── middleware/
│   └── auth.js           # Authentication middleware
├── routes/
│   ├── api_keys.js       # API key management
│   ├── usage.js          # Usage tracking
│   └── invoices.js       # Invoice generation
├── *.html                # Frontend pages
├── package.json          # Dependencies
└── README.md            # This file
```

### Adding New Features

1. **New API Endpoints**: Add routes in the `routes/` directory
2. **Frontend Pages**: Create new HTML files and add routes in `server.js`
3. **Database Collections**: Define new collections in `firebase.js`

## 🐛 Troubleshooting

### Common Issues

1. **Firebase Connection Error**
   - Verify service account key is correctly encoded
   - Check Firebase project ID in configuration

2. **Email Not Sending**
   - Verify Gmail app password is correct
   - Check SMTP settings in environment variables

3. **Rate Limiting Issues**
   - Check plan limits in `firebase.js`
   - Verify API key permissions

### Logs

Check application logs for detailed error information:

```bash
npm run dev  # Development mode with detailed logging
```

## 📞 Support

For technical support or questions:

- Email: <support@appoint.com>
- Documentation: [API Docs](https://docs.appoint.com)
- Issues: [GitHub Issues](https://github.com/appoint/enterprise-portal/issues)

## 📄 License

MIT License - see LICENSE file for details.
