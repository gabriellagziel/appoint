# Ambassador Quota Enforcement System

## Overview

The Ambassador Quota Enforcement System is a comprehensive solution for managing ambassador assignments across 50 countries and languages with hard-capped quotas. The system automatically assigns ambassador roles to eligible users and enforces strict quota limits per country-language combination.

## Key Features

### 🌍 Global Coverage
- **50 Countries & Languages** supported
- **6,675 Total Ambassador Slots** globally
- **Automatic Assignment** based on eligibility
- **Real-time Quota Enforcement**

### 🔐 Quota Management
- **Hard-capped quotas** per country-language combination
- **No application system** - first eligible adult gets the slot
- **Automatic slot freeing** when ambassadors become inactive
- **Children excluded** from ambassadorship (adults only)

### 📊 Comprehensive Dashboard
- **Global statistics** and utilization metrics
- **Country-specific** quota tracking
- **Language-specific** analysis
- **Real-time monitoring** and management tools

## Quota Distribution

### Europe (24 Countries)
| Country | Language | Quota | Country | Language | Quota |
|---------|----------|-------|---------|----------|-------|
| Poland | Polish | 95 | Finland | Finnish | 49 |
| France | French | 142 | Sweden | Swedish | 67 |
| Germany | German | 133 | Norway | Norwegian | 44 |
| Spain | Spanish | 220 | Denmark | Danish | 43 |
| Italy | Italian | 144 | Slovenia | Slovenian | 39 |
| Russia | Russian | 111 | Czech Republic | Czech | 59 |
| Ukraine | Ukrainian | 70 | Hungary | Hungarian | 57 |
| Romania | Romanian | 72 | Bulgaria | Bulgarian | 52 |
| Greece | Greek | 66 | Croatia | Croatian | 50 |
| Netherlands | Dutch | 61 | Slovakia | Slovak | 48 |
| Latvia | Latvian | 42 | Lithuania | Lithuanian | 41 |
| Serbia | Serbian | 40 | | | |

### North America (4 Countries)
| Country | Language | Quota |
|---------|----------|-------|
| United States | English | 345 |
| Canada | English | 54 |
| Canada | French | 46 |
| Mexico | Spanish | 173 |

### Asia (16 Countries)
| Country | Language | Quota | Country | Language | Quota |
|---------|----------|-------|---------|----------|-------|
| Japan | Japanese | 116 | Thailand | Thai | 64 |
| South Korea | Korean | 98 | Indonesia | Indonesian | 88 |
| China | Chinese | 400 | Malaysia | Malay | 60 |
| India | Hindi | 200 | Sri Lanka | Sinhala | 39 |
| India | Tamil | 84 | Nepal | Nepali | 38 |
| India | Gujarati | 63 | Philippines | Tagalog | 103 |
| Pakistan | Urdu | 125 | Vietnam | Vietnamese | 106 |
| Bangladesh | Bengali | 122 | Turkey | Turkish | 101 |
| Iran | Persian | 77 | | | |

### South America (1 Country)
| Country | Language | Quota |
|---------|----------|-------|
| Brazil | Portuguese | 215 |

### Africa (5 Countries)
| Country | Language | Quota |
|---------|----------|-------|
| Nigeria | English | 135 |
| Nigeria | Hausa | 45 |
| Ethiopia | Amharic | 56 |
| Kenya | Swahili | 53 |
| South Africa | Zulu | 36 |

## System Architecture

### Frontend Components

#### 1. AmbassadorQuotaService (`lib/services/ambassador_quota_service.dart`)
Core service handling all quota-related operations:
- Quota validation and checking
- Ambassador assignment logic
- Statistics generation
- Auto-assignment functionality

#### 2. AmbassadorQuotaProvider (`lib/providers/ambassador_quota_provider.dart`)
Riverpod providers for state management:
- Quota statistics providers
- Assignment operation notifiers
- Filtered data providers
- Real-time quota monitoring

#### 3. AmbassadorQuotaDashboardScreen (`lib/features/ambassador_quota_dashboard_screen.dart`)
Comprehensive dashboard with:
- Global statistics overview
- Country-specific quota tracking
- Language utilization analysis
- Management tools and controls

### Backend Components

#### 1. Firebase Cloud Functions (`functions/index.js`)
Serverless functions for:
- **Auto-assignment scheduling** (hourly)
- **Manual assignment triggers**
- **Quota statistics generation**
- **Daily reporting**
- **User eligibility monitoring**

#### 2. Firestore Collections
- `ambassadors` - Active ambassador records
- `users` - User profiles with role tracking
- `ambassador_assignments` - Assignment logs
- `ambassador_removals` - Removal tracking
- `quota_reports` - Daily statistics

## Assignment Logic

### Eligibility Criteria
1. **Adult Status**: User must be 18+ (`isAdult: true`)
2. **Role Check**: User must not already be an ambassador
3. **Country Match**: User's country must match quota country
4. **Slot Availability**: Quota must not be exceeded

### Assignment Process
1. **Automatic Trigger**: When user becomes eligible
2. **Quota Check**: Verify available slots
3. **Transaction**: Atomic assignment operation
4. **Role Update**: Set user role to 'ambassador'
5. **Record Creation**: Create ambassador document
6. **Logging**: Track assignment for audit

### Auto-Assignment
- **Scheduled**: Runs every hour via Cloud Function
- **Batch Processing**: Processes all available slots
- **First-Come-First-Served**: Based on user creation date
- **Atomic Operations**: Ensures data consistency

## Dashboard Features

### Overview Tab
- **Global Statistics Cards**: Total quota, current, available, utilization
- **Utilization Chart**: Pie chart showing current vs available
- **Top Countries**: Countries with highest utilization rates

### Countries Tab
- **Filterable Data Table**: By country and language
- **Real-time Statistics**: Current counts and availability
- **Utilization Indicators**: Color-coded percentage badges

### Languages Tab
- **Language Aggregation**: Combined statistics per language
- **Progress Bars**: Visual utilization indicators
- **Country Counts**: Number of countries per language

### Management Tab
- **Auto-Assignment Trigger**: Manual quota filling
- **Manual Assignment**: Direct user assignment (future)
- **Quota Management**: Configuration tools (future)

## API Endpoints

### HTTP Functions
- `GET /autoAssignAmbassadors` - Trigger auto-assignment
- `GET /getQuotaStats` - Retrieve quota statistics
- `POST /assignAmbassador` - Manual assignment

### Scheduled Functions
- `scheduledAutoAssign` - Hourly auto-assignment
- `dailyQuotaReport` - Daily statistics generation

### Firestore Triggers
- `checkAmbassadorEligibility` - User document changes
- `handleAmbassadorRemoval` - Ambassador status changes

## Usage Examples

### Check Available Slots
```dart
final service = AmbassadorQuotaService();
final availableSlots = await service.getAvailableSlots('US', 'en');
print('Available slots for US English: $availableSlots');
```

### Assign Ambassador
```dart
final success = await service.assignAmbassador(
  userId: 'user123',
  countryCode: 'US',
  languageCode: 'en',
);
```

### Get Global Statistics
```dart
final globalStats = await service.getGlobalStatistics();
print('Global utilization: ${globalStats['globalUtilizationPercentage']}%');
```

### Monitor Quota Data
```dart
final quotaDataAsync = ref.watch(quotaDataProvider);
quotaDataAsync.when(
  data: (data) => print('Quota data loaded: ${data.length} entries'),
  loading: () => print('Loading quota data...'),
  error: (error, stack) => print('Error: $error'),
);
```

## Security Considerations

### Data Protection
- **Role-based Access**: Admin-only quota management
- **Audit Logging**: All assignments and removals tracked
- **Transaction Safety**: Atomic operations prevent race conditions

### Quota Enforcement
- **Server-side Validation**: All quota checks on backend
- **Real-time Monitoring**: Continuous quota tracking
- **Automatic Cleanup**: Inactive ambassador removal

## Monitoring & Analytics

### Key Metrics
- **Global Utilization**: Overall quota usage percentage
- **Country Performance**: Per-country utilization rates
- **Language Distribution**: Language-specific statistics
- **Assignment Velocity**: Rate of new assignments

### Reporting
- **Daily Reports**: Automated quota statistics
- **Real-time Dashboard**: Live quota monitoring
- **Historical Data**: Assignment and removal tracking

## Future Enhancements

### Planned Features
1. **Manual Assignment Interface**: Admin tools for direct assignment
2. **Quota Adjustment**: Dynamic quota modification
3. **Performance Analytics**: Ambassador effectiveness tracking
4. **Notification System**: Quota alerts and updates
5. **API Rate Limiting**: Enhanced security controls

### Scalability Considerations
- **Horizontal Scaling**: Cloud Functions auto-scale
- **Database Optimization**: Indexed queries for performance
- **Caching Strategy**: Redis for frequently accessed data
- **Load Balancing**: Distributed quota checking

## Deployment

### Firebase Setup
1. **Enable Cloud Functions**: `firebase functions:config:set`
2. **Deploy Functions**: `firebase deploy --only functions`
3. **Configure Triggers**: Set up Firestore triggers
4. **Monitor Logs**: `firebase functions:log`

### Environment Configuration
```bash
# Required environment variables
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_REGION=us-central1
```

## Support & Maintenance

### Troubleshooting
- **Quota Mismatches**: Check Firestore indexes
- **Assignment Failures**: Verify user eligibility
- **Performance Issues**: Monitor Cloud Function logs

### Maintenance Tasks
- **Daily**: Review quota reports
- **Weekly**: Analyze assignment patterns
- **Monthly**: Optimize quota distribution

---

## Summary

The Ambassador Quota Enforcement System provides a robust, scalable solution for managing ambassador assignments across 50 countries and languages. With automatic assignment, real-time monitoring, and comprehensive analytics, it ensures fair and efficient quota management while maintaining data integrity and security.

**Total Global Ambassador Slots: 6,675**
**Countries Supported: 50**
**Languages Supported: 50**
**Auto-Assignment: Enabled**
**Real-time Monitoring: Active** 