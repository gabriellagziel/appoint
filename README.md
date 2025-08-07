# App-Oint: Web Applications

A collection of Next.js web applications for meeting management and business operations.

## 🚀 Applications

### Marketing Site
- **Location**: `marketing/`
- **Purpose**: Public-facing marketing website
- **Features**: Landing pages, product information, contact forms

### User Portal
- **Location**: `user/`
- **Purpose**: Main user application for meeting management
- **Features**: Meeting creation, participant management, calendar integration

### Business Portal
- **Location**: `business/`
- **Purpose**: Business-focused features and analytics
- **Features**: Business dashboard, analytics, reporting

### Enterprise Onboarding Portal
- **Location**: `enterprise-onboarding-portal/`
- **Purpose**: Enterprise customer onboarding and management
- **Features**: Onboarding flows, enterprise setup, admin tools

### Admin Panel
- **Location**: `admin/`
- **Purpose**: Administrative interface for system management
- **Features**: User management, system monitoring, configuration

## 🏗️ Architecture

### Technology Stack

- **Frontend**: Next.js with React
- **Styling**: Tailwind CSS
- **State Management**: React Context and hooks
- **Backend**: Firebase Functions
- **Database**: Firestore
- **Authentication**: Firebase Auth
- **Hosting**: Firebase Hosting

### Project Structure

```
├── marketing/                    # Marketing website
├── user/                        # Main user application
├── business/                    # Business portal
├── enterprise-onboarding-portal/ # Enterprise onboarding
├── admin/                       # Admin panel
├── functions/                   # Firebase Functions
├── docs/                        # Documentation
└── scripts/                     # Build and deployment scripts
```

## 🚀 Getting Started

### Prerequisites

- Node.js 18.x or higher
- npm or yarn
- Firebase CLI

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd ga
   ```

2. Install dependencies for each application:
   ```bash
   # Marketing site
   cd marketing && npm install
   
   # User portal
   cd ../user && npm install
   
   # Business portal
   cd ../business && npm install
   
   # Enterprise onboarding portal
   cd ../enterprise-onboarding-portal && npm install
   
   # Admin panel
   cd ../admin && npm install
   ```

3. Set up environment variables:
   ```bash
   # Copy environment templates
   cp marketing/.env.example marketing/.env.local
   cp user/.env.example user/.env.local
   cp business/.env.example business/.env.local
   cp enterprise-onboarding-portal/.env.example enterprise-onboarding-portal/.env.local
   cp admin/.env.example admin/.env.local
   ```

### Development

Start the development server for any application:

```bash
# Marketing site
cd marketing && npm run dev

# User portal
cd user && npm run dev

# Business portal
cd business && npm run dev

# Enterprise onboarding portal
cd enterprise-onboarding-portal && npm run dev

# Admin panel
cd admin && npm run dev
```

### Building for Production

Build any application for production:

```bash
# Marketing site
cd marketing && npm run build

# User portal
cd user && npm run build

# Business portal
cd business && npm run build

# Enterprise onboarding portal
cd enterprise-onboarding-portal && npm run build

# Admin panel
cd admin && npm run build
```

## 📚 Documentation

- [API Documentation](docs/api/)
- [Deployment Guide](docs/deployment/)
- [Contributing Guidelines](docs/contributing/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
