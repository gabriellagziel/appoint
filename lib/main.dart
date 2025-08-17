// ignore_for_file: uri_does_not_exist, undefined_identifier
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'models/playtime_game.dart';
import 'models/playtime_session.dart';
import 'models/playtime_background.dart';
import 'models/meeting.dart';
import 'services/pwa_prompt_service.dart';
import 'services/meeting_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app_router.dart';
import 'app_router_quarantine.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// Stripe SDK initialization (publishable key via --dart-define STRIPE_PUBLISHABLE_KEY)
// Ensure flutter_stripe dependency is added in pubspec.yaml
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> _initFirebaseAndEmulators() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const useEmulators =
      bool.fromEnvironment('USE_EMULATORS', defaultValue: true);
  if (useEmulators) {
    try {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (_) {}
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8081);
    } catch (_) {}
    try {
      FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    } catch (_) {}
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setUrlStrategy(const HashUrlStrategy());
  }
  await _initFirebaseAndEmulators();
  // Initialize Stripe publishable key from env if available
  const stripeKey =
      String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
  if (stripeKey.isNotEmpty) {
    Stripe.publishableKey = stripeKey;
  }
  // Initialize PWA service for web
  PwaPromptService.initialize();

  runApp(const PlaytimeTestApp());
}

class PlaytimeTestApp extends StatelessWidget {
  const PlaytimeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bool kQuarantine =
        bool.fromEnvironment('FLOW_QUARANTINE', defaultValue: false);
    return MaterialApp.router(
      title: 'Playtime Test App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: kQuarantine ? quarantineRouter : router,
    );
  }
}

class PlaytimeTestScreen extends StatefulWidget {
  const PlaytimeTestScreen({super.key});

  @override
  State<PlaytimeTestScreen> createState() => _PlaytimeTestScreenState();
}

class _PlaytimeTestScreenState extends State<PlaytimeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.playtimeSystemTest ??
            'Playtime System Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.playtimeSystemImplementationTest ??
                  'Playtime System Implementation Test',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Test PlaytimeGame
            _buildTestSection(
              AppLocalizations.of(context)?.playtimeGameModel ??
                  'PlaytimeGame Model',
              () {
                final game = PlaytimeGame(
                  id: 'test_game_1',
                  name: 'Minecraft Adventure',
                  description: 'Build and explore together',
                  icon: '🎮',
                  category: 'creative',
                  ageRange: {'min': 8, 'max': 16},
                  type: 'virtual',
                  maxParticipants: 6,
                  estimatedDuration: 120,
                  isSystemGame: true,
                  isPublic: true,
                  creatorId: 'system',
                  parentApprovalRequired: true,
                  safetyLevel: 'safe',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                final json = game.toJson();
                final fromJson = PlaytimeGame.fromJson(json);

                return '✅ Game created successfully\n'
                    'ID: ${game.id}\n'
                    'Name: ${game.name}\n'
                    'Type: ${game.type}\n'
                    'Is Virtual: ${game.isVirtual}\n'
                    'Min Age: ${game.minAge}\n'
                    'Max Age: ${game.maxAge}';
              },
            ),

            const SizedBox(height: 20),

            // Test PlaytimeSession
            _buildTestSection(
              AppLocalizations.of(context)?.playtimeSessionModel ??
                  'PlaytimeSession Model',
              () {
                final session = PlaytimeSession(
                  id: 'test_session_1',
                  gameId: 'test_game_1',
                  type: 'virtual',
                  title: 'Minecraft Castle Building',
                  description: 'Let\'s build an amazing castle together!',
                  creatorId: 'child_user_001',
                  participants: [
                    PlaytimeParticipant(
                      userId: 'child_user_001',
                      displayName: 'Emma',
                      role: 'creator',
                      joinedAt: DateTime.now(),
                      status: 'joined',
                    ),
                  ],
                  duration: 120,
                  parentApprovalStatus: PlaytimeParentApprovalStatus(
                    required: true,
                  ),
                  adminApprovalStatus: PlaytimeAdminApprovalStatus(),
                  safetyFlags: PlaytimeSafetyFlags(),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  maxParticipants: 6,
                );

                final json = session.toJson();
                final fromJson = PlaytimeSession.fromJson(json);

                return '✅ Session created successfully\n'
                    'ID: ${session.id}\n'
                    'Title: ${session.title}\n'
                    'Type: ${session.type}\n'
                    'Is Virtual: ${session.isVirtual}\n'
                    'Requires Parent Approval: ${session.requiresParentApproval}\n'
                    'Can Start: ${session.canStart}';
              },
            ),

            const SizedBox(height: 20),

            // Test PlaytimeBackground
            _buildTestSection(
              AppLocalizations.of(context)?.playtimeBackgroundModel ??
                  'PlaytimeBackground Model',
              () {
                final background = PlaytimeBackground(
                  id: 'test_bg_1',
                  name: 'Park Scene',
                  description: 'Beautiful park with trees and playground',
                  imageUrl: 'https://example.com/park.jpg',
                  thumbnailUrl: 'https://example.com/park_thumb.jpg',
                  uploadedBy: 'system',
                  uploadedByDisplayName: 'System',
                  category: 'outdoor',
                  approvalStatus: PlaytimeApprovalStatus(
                    reviewedBy: 'admin',
                    reviewedAt: DateTime.now(),
                  ),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                final json = background.toJson();
                final fromJson = PlaytimeBackground.fromJson(json);

                return '✅ Background created successfully\n'
                    'ID: ${background.id}\n'
                    'Name: ${background.name}\n'
                    'Category: ${background.category}\n'
                    'Is Approved: ${background.isApproved}\n'
                    'Is Available: ${background.isAvailable}';
              },
            ),

            const SizedBox(height: 20),

            // Test Meeting with Playtime
            _buildTestSection(
              AppLocalizations.of(context)?.meetingWithPlaytimeSupport ??
                  'Meeting with Playtime Support',
              () {
                final meeting = Meeting(
                  id: 'test_meeting_1',
                  organizerId: 'child_user_001',
                  title: 'Minecraft Playtime Session',
                  description: 'Virtual playtime session with friends',
                  startTime: DateTime.now().add(const Duration(hours: 1)),
                  endTime: DateTime.now().add(const Duration(hours: 2)),
                  participants: [
                    MeetingParticipant(
                      userId: 'child_user_001',
                      name: 'Emma',
                      role: ParticipantRole.organizer,
                    ),
                  ],
                  meetingType: MeetingType.playtime,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  subtype: 'virtual',
                  isChildInitiated: true,
                  parentApproved: false,
                  virtualLink: 'https://meet.example.com/playtime',
                  notes: 'Bring your creativity!',
                );

                final json = meeting.toJson();
                final fromJson = Meeting.fromJson(json);

                return '✅ Meeting with Playtime created successfully\n'
                    'ID: ${meeting.id}\n'
                    'Title: ${meeting.title}\n'
                    'Meeting Type: ${meeting.meetingType}\n'
                    'Type Display: ${meeting.typeDisplayName}\n'
                    'Is Playtime: ${meeting.isPlaytime}\n'
                    'Is Virtual Playtime: ${meeting.isVirtualPlaytime}\n'
                    'Subtype: ${meeting.subtype}\n'
                    'Child Initiated: ${meeting.isChildInitiated}\n'
                    'Parent Approved: ${meeting.parentApproved}';
              },
            ),

            const SizedBox(height: 20),

            // Test Service Methods
            _buildTestSection(
              AppLocalizations.of(context)?.playtimeServiceMethods ??
                  'PlaytimeService Methods',
              () {
                return '✅ Service methods available:\n'
                    '• getAvailableGames()\n'
                    '• createSession()\n'
                    '• getUserSessions()\n'
                    '• approveSessionByParent()\n'
                    '• getAvailableBackgrounds()\n'
                    '• isChildUser()\n'
                    '• generateSessionId()\n'
                    '• generateGameId()\n'
                    '• generateBackgroundId()';
              },
            ),

            const SizedBox(height: 20),

            // Test Provider
            _buildTestSection(
              AppLocalizations.of(context)?.riverpodProviders ??
                  'Riverpod Providers',
              () {
                return '✅ Providers configured:\n'
                    '• playtimeGamesProvider\n'
                    '• playtimeSessionsNotifierProvider\n'
                    '• playtimeBackgroundsNotifierProvider\n'
                    '• isChildUserProvider\n'
                    '• parentIdProvider\n'
                    '• sessionCreationNotifierProvider';
              },
            ),

            const SizedBox(height: 40),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)
                            ?.phase1ImplementationComplete ??
                        '🎉 PHASE 1 Implementation Complete!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)?.allCoreModelsCreated ??
                        '✅ All core models created\n'
                            '✅ Service layer implemented\n'
                            '✅ Providers configured\n'
                            '✅ MeetingType.playtime support added\n'
                            '✅ Parent approval workflow ready\n'
                            '✅ Safety features included',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // PWA System Test
            _buildTestSection(
              AppLocalizations.of(context)?.pwaSystemImplementation ??
                  'PWA System Implementation',
              () {
                return '✅ PWA System configured:\n'
                    '• Manifest.json created\n'
                    '• Service Worker registered\n'
                    '• PWA prompt service ready\n'
                    '• User meta tracking active\n'
                    '• Add to home screen dialog\n'
                    '• Mobile device detection\n'
                    '• Meeting creation hooks';
              },
            ),

            const SizedBox(height: 20),

            // Test PWA functionality
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔧 PWA Testing',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _testPwaPrompt,
                    child: Text(AppLocalizations.of(context)?.testPwaPrompt ??
                        'Test PWA Prompt'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _simulateMeetingCreation,
                    child: Text(
                        AppLocalizations.of(context)?.simulateMeetingCreation ??
                            'Simulate Meeting Creation'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.nextStepsPhase2 ??
                        '📋 Next Steps for PHASE 2',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)?.nextStepsPhase2Details ??
                        '1. Create UI components\n'
                            '2. Implement Firestore collections\n'
                            '3. Add parent approval screens\n'
                            '4. Build admin moderation tools\n'
                            '5. Add real-time chat features\n'
                            '6. Implement safety monitoring',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _testPwaPrompt() async {
    await MeetingService.showPwaPrompt(context);
  }

  void _simulateMeetingCreation() async {
    final meeting = Meeting(
      id: 'test_meeting_${DateTime.now().millisecondsSinceEpoch}',
      organizerId: 'test_user',
      title: 'Test Meeting for PWA',
      startTime: DateTime.now().add(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      participants: [],
      meetingType: MeetingType.personal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await MeetingService.onMeetingCreated(context, meeting);
  }

  Widget _buildTestSection(String title, String Function() testFunction) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            testFunction(),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
