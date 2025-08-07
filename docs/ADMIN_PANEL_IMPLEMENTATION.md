# Admin Panel Implementation Guide

This document provides comprehensive guidance for implementing and using the APP-OINT admin panel system.

## Table of Contents

1. [Overview](#overview)
2. [Role-Based Access Control](#role-based-access-control)
3. [Custom Claims Setup](#custom-claims-setup)
4. [Permission System](#permission-system)
5. [Admin Panel Features](#admin-panel-features)
6. [Implementation Examples](#implementation-examples)
7. [Security Considerations](#security-considerations)
8. [Troubleshooting](#troubleshooting)

## Overview

The APP-OINT admin panel provides comprehensive system management capabilities with role-based access control (RBAC). The system supports multiple admin roles with different permission levels.

### Supported Roles

- **Super Admin**: Full system access
- **System Admin**: System-wide management
- **Business Admin**: Business-specific management
- **Moderator**: Content moderation and support
- **Analyst**: Read-only analytics access

## Role-Based Access Control

### Role Hierarchy

```
Super Admin
├── System Admin
│   ├── Business Admin
│   │   ├── Moderator
│   │   └── Analyst
│   └── Moderator
└── Analyst
```

### Permission Matrix

| Feature | Super Admin | System Admin | Business Admin | Moderator | Analyst |
|---------|-------------|--------------|----------------|-----------|---------|
| User Management | ✅ Full | ✅ Full | ❌ | ❌ | ❌ |
| Business Management | ✅ Full | ✅ Full | ✅ Own | ❌ | ❌ |
| System Settings | ✅ Full | ✅ Read/Write | ❌ | ❌ | ❌ |
| Analytics | ✅ Full | ✅ Full | ✅ Own | ❌ | ✅ Read |
| Content Moderation | ✅ Full | ✅ Full | ✅ Own | ✅ Full | ❌ |
| Payment Management | ✅ Full | ✅ Full | ✅ Own | ❌ | ❌ |
| Support Management | ✅ Full | ✅ Full | ✅ Own | ✅ Full | ❌ |

## Custom Claims Setup

### Firebase Custom Claims

Custom claims are used to store user roles and permissions in Firebase Auth.

#### Setting Custom Claims

```javascript
// Cloud Function to set admin role
exports.setAdminRole = functions.https.onCall(async (data, context) => {
  // Verify the caller is a super admin
  if (!context.auth?.token?.admin || !context.auth?.token?.superAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'Insufficient permissions');
  }

  const { uid, role, permissions } = data;
  
  const customClaims = {
    admin: true,
    role: role,
    permissions: permissions,
    updatedAt: Date.now()
  };

  try {
    await admin.auth().setCustomUserClaims(uid, customClaims);
    return { success: true, message: 'Role updated successfully' };
  } catch (error) {
    throw new functions.https.HttpsError('internal', 'Failed to update role');
  }
});
```

#### Role Definitions

```javascript
const ROLES = {
  SUPER_ADMIN: {
    role: 'super_admin',
    permissions: ['*'] // All permissions
  },
  SYSTEM_ADMIN: {
    role: 'system_admin',
    permissions: [
      'user.manage',
      'business.manage',
      'system.settings',
      'analytics.view',
      'content.moderate',
      'payment.manage',
      'support.manage'
    ]
  },
  BUSINESS_ADMIN: {
    role: 'business_admin',
    permissions: [
      'business.own.manage',
      'analytics.own.view',
      'content.own.moderate',
      'payment.own.manage',
      'support.own.manage'
    ]
  },
  MODERATOR: {
    role: 'moderator',
    permissions: [
      'content.moderate',
      'support.manage'
    ]
  },
  ANALYST: {
    role: 'analyst',
    permissions: [
      'analytics.view'
    ]
  }
};
```

## Permission System

### Permission Structure

Permissions follow a hierarchical structure: `resource.action` or `resource.own.action`

#### Core Permissions

- `user.manage` - Full user management
- `business.manage` - Full business management
- `business.own.manage` - Own business management
- `system.settings` - System configuration
- `analytics.view` - View analytics
- `analytics.own.view` - View own business analytics
- `content.moderate` - Content moderation
- `content.own.moderate` - Own content moderation
- `payment.manage` - Payment management
- `payment.own.manage` - Own payment management
- `support.manage` - Support ticket management
- `support.own.manage` - Own support ticket management

### Permission Checking

```dart
class PermissionService {
  static bool hasPermission(String permission, Map<String, dynamic> claims) {
    if (claims['permissions'] == null) return false;
    
    final permissions = List<String>.from(claims['permissions']);
    
    // Check for wildcard permission
    if (permissions.contains('*')) return true;
    
    // Check exact permission
    if (permissions.contains(permission)) return true;
    
    // Check resource-level permission
    final resource = permission.split('.')[0];
    if (permissions.contains('$resource.*')) return true;
    
    return false;
  }
  
  static bool hasRole(String role, Map<String, dynamic> claims) {
    return claims['role'] == role;
  }
}
```

## Admin Panel Features

### Dashboard

The admin dashboard provides an overview of system metrics and key performance indicators.

#### Key Metrics

- Total users
- Active businesses
- Total appointments
- Revenue metrics
- System health status
- Recent activities

### User Management

#### User List

```dart
class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Consumer(
        builder: (context, ref, child) {
          final usersAsync = ref.watch(usersProvider);
          
          return usersAsync.when(
            data: (users) => ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserListTile(
                  user: user,
                  onRoleChange: (newRole) => _updateUserRole(user.id, newRole),
                );
              },
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}
```

#### Role Assignment

```dart
class RoleAssignmentDialog extends StatelessWidget {
  final String userId;
  final String currentRole;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign Role'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: currentRole,
            items: ROLES.keys.map((role) => 
              DropdownMenuItem(value: role, child: Text(role))
            ).toList(),
            onChanged: (newRole) => _assignRole(userId, newRole!),
          ),
        ],
      ),
    );
  }
}
```

### Business Management

#### Business Overview

```dart
class BusinessManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Business Management')),
      body: Consumer(
        builder: (context, ref, child) {
          final businessesAsync = ref.watch(businessesProvider);
          
          return businessesAsync.when(
            data: (businesses) => ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business = businesses[index];
                return BusinessCard(
                  business: business,
                  onEdit: () => _editBusiness(business),
                  onSuspend: () => _suspendBusiness(business.id),
                );
              },
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}
```

### Analytics Dashboard

#### Analytics Widgets

```dart
class AnalyticsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Revenue Chart
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Revenue Overview', style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 16),
                    RevenueChart(),
                  ],
                ),
              ),
            ),
            
            // User Growth Chart
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Growth', style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 16),
                    UserGrowthChart(),
                  ],
                ),
              ),
            ),
            
            // System Metrics
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('System Metrics', style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 16),
                    SystemMetricsGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Implementation Examples

### Admin Route Guard

```dart
class AdminRouteGuard extends ConsumerWidget {
  final Widget child;
  
  const AdminRouteGuard({required this.child});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      data: (user) {
        if (user == null) {
          return LoginScreen();
        }
        
        final claims = user.customClaims;
        if (claims == null || !claims['admin']) {
          return UnauthorizedScreen();
        }
        
        return child;
      },
      loading: () => LoadingScreen(),
      error: (error, stack) => ErrorScreen(error: error),
    );
  }
}
```

### Permission-Based UI

```dart
class PermissionWidget extends StatelessWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;
  
  const PermissionWidget({
    required this.permission,
    required this.child,
    this.fallback,
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final user = ref.watch(currentUserProvider);
        
        if (user == null) return fallback ?? SizedBox.shrink();
        
        final claims = user.customClaims;
        if (claims == null) return fallback ?? SizedBox.shrink();
        
        if (PermissionService.hasPermission(permission, claims)) {
          return child;
        }
        
        return fallback ?? SizedBox.shrink();
      },
    );
  }
}
```

### Admin Provider

```dart
class AdminProvider extends StateNotifier<AdminState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  AdminProvider(this._firestore, this._auth) : super(AdminState.initial());
  
  Future<void> loadUsers() async {
    state = state.copyWith(loading: true);
    
    try {
      final snapshot = await _firestore.collection('users').get();
      final users = snapshot.docs.map((doc) => 
        UserModel.fromJson(doc.data())
      ).toList();
      
      state = state.copyWith(
        users: users,
        loading: false,
      );
    } catch (error) {
      state = state.copyWith(
        error: error.toString(),
        loading: false,
      );
    }
  }
  
  Future<void> updateUserRole(String userId, String role) async {
    try {
      final functions = FirebaseFunctions.instance;
      await functions.httpsCallable('setAdminRole').call({
        'uid': userId,
        'role': role,
        'permissions': ROLES[role]?.permissions ?? [],
      });
      
      // Reload users
      await loadUsers();
    } catch (error) {
      state = state.copyWith(error: error.toString());
    }
  }
}
```

## Security Considerations

### Input Validation

```dart
class AdminInputValidator {
  static String? validateRole(String? role) {
    if (role == null || role.isEmpty) {
      return 'Role is required';
    }
    
    if (!ROLES.containsKey(role)) {
      return 'Invalid role';
    }
    
    return null;
  }
  
  static String? validateUserId(String? userId) {
    if (userId == null || userId.isEmpty) {
      return 'User ID is required';
    }
    
    // Validate Firebase UID format
    if (!RegExp(r'^[a-zA-Z0-9]{28}$').hasMatch(userId)) {
      return 'Invalid user ID format';
    }
    
    return null;
  }
}
```

### Rate Limiting

```javascript
// Cloud Function with rate limiting
exports.adminAction = functions.https.onCall(async (data, context) => {
  // Rate limiting check
  const uid = context.auth?.uid;
  const rateLimitKey = `admin_action_${uid}`;
  
  const currentCount = await redis.get(rateLimitKey) || 0;
  if (currentCount > 10) { // 10 actions per minute
    throw new functions.https.HttpsError('resource-exhausted', 'Rate limit exceeded');
  }
  
  await redis.incr(rateLimitKey);
  await redis.expire(rateLimitKey, 60); // 1 minute
  
  // Proceed with admin action
  // ...
});
```

### Audit Logging

```dart
class AdminAuditLogger {
  static Future<void> logAction({
    required String action,
    required String targetUserId,
    required Map<String, dynamic> details,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    
    await firestore.collection('admin_audit_logs').add({
      'action': action,
      'adminUserId': user?.uid,
      'targetUserId': targetUserId,
      'details': details,
      'timestamp': FieldValue.serverTimestamp(),
      'ipAddress': await _getClientIP(),
    });
  }
}
```

## Troubleshooting

### Common Issues

#### 1. Custom Claims Not Updating

**Problem**: User roles not reflecting after assignment

**Solution**:
```dart
// Force token refresh after role assignment
await FirebaseAuth.instance.currentUser?.getIdToken(true);
```

#### 2. Permission Denied Errors

**Problem**: Admin users getting permission denied

**Solution**:
```dart
// Check if user has admin claims
final user = FirebaseAuth.instance.currentUser;
final token = await user?.getIdTokenResult();
final claims = token?.claims;

if (claims?['admin'] != true) {
  // Handle unauthorized access
}
```

#### 3. Role Assignment Fails

**Problem**: Cloud function fails to assign roles

**Solution**:
```javascript
// Ensure proper error handling in Cloud Function
exports.setAdminRole = functions.https.onCall(async (data, context) => {
  try {
    // Validate input
    if (!data.uid || !data.role) {
      throw new functions.https.HttpsError('invalid-argument', 'Missing required fields');
    }
    
    // Check permissions
    if (!context.auth?.token?.admin) {
      throw new functions.https.HttpsError('permission-denied', 'Admin access required');
    }
    
    // Set custom claims
    await admin.auth().setCustomUserClaims(data.uid, {
      admin: true,
      role: data.role,
      permissions: data.permissions || [],
      updatedAt: Date.now(),
    });
    
    return { success: true };
  } catch (error) {
    console.error('Role assignment error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to assign role');
  }
});
```

### Debug Tools

#### Admin Debug Panel

```dart
class AdminDebugPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(currentUserProvider);
        
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Debug Information', style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 8),
                Text('User ID: ${user?.uid ?? 'N/A'}'),
                Text('Email: ${user?.email ?? 'N/A'}'),
                Text('Claims: ${user?.customClaims ?? 'N/A'}'),
                Text('Role: ${user?.customClaims?['role'] ?? 'N/A'}'),
                Text('Permissions: ${user?.customClaims?['permissions'] ?? 'N/A'}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

## Conclusion

This admin panel implementation provides a robust, secure, and scalable solution for managing the APP-OINT platform. The role-based access control system ensures proper security while maintaining flexibility for different admin needs.

For additional support or questions, please refer to the main documentation or create an issue in the repository. 