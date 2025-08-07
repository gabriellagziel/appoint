import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Demo widget for ChatBubble golden test
class ChatBubbleDemo extends StatelessWidget {
  const ChatBubbleDemo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Chat Bubbles'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chat Messages',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildChatBubble(
                        'Hello! How can I help you today?',
                        false, // incoming message (left-aligned)
                        '10:30 AM',
                      ),
                      const SizedBox(height: 8),
                      _buildChatBubble(
                        "Hi! I would like to book an appointment for a haircut. I'm looking for something that will work well with my face shape and lifestyle. Do you have any recommendations for styles that are easy to maintain but still look professional?",
                        true, // outgoing message (right-aligned)
                        '10:32 AM',
                      ),
                      const SizedBox(height: 8),
                      _buildChatBubble(
                        "Of course! I'd be happy to help you find the perfect style. Could you tell me a bit more about your hair type and what you do for work?",
                        false,
                        '10:33 AM',
                      ),
                      const SizedBox(height: 8),
                      _buildChatBubble(
                        "Sure! I have medium-length hair that's naturally wavy. I work in an office environment, so I need something that looks polished but doesn't require too much styling in the morning.",
                        true,
                        '10:35 AM',
                      ),
                      const SizedBox(height: 8),
                      _buildChatBubble(
                        'Perfect! I have several options that would work well for you. When would you like to come in?',
                        false,
                        '10:36 AM',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildChatBubble(String message, bool isOutgoing, String timestamp) =>
      Align(
        alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          constraints: const BoxConstraints(maxWidth: 280),
          child: Column(
            crossAxisAlignment:
                isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isOutgoing ? Colors.blue[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isOutgoing ? Colors.blue[800] : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(
                  left: isOutgoing ? 0 : 8,
                  right: isOutgoing ? 8 : 0,
                ),
                child: Text(
                  timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

void main() {
  testWidgets('ChatBubble matches golden', (tester) async {
    await tester.pumpWidget(const ChatBubbleDemo());
    await expectLater(
      find.byType(ChatBubbleDemo),
      matchesGoldenFile('goldens/chat_bubble.png'),
    );
  });
}
