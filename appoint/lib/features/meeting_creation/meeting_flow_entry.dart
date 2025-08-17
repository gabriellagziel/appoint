import 'package:flutter/material.dart';

/// Minimal entry widget that wires an existing/placeholder wizard flow.
/// If your original step widgets/controllers exist, replace the inline
/// steps below with imports and use them in the same order.
class MeetingFlowEntry extends StatefulWidget {
  const MeetingFlowEntry({
    super.key,
    this.hideLegacyBanner = false,
    this.skipSetup = false,
  });

  final bool hideLegacyBanner;
  final bool skipSetup;

  @override
  State<MeetingFlowEntry> createState() => _MeetingFlowEntryState();
}

enum _FlowStep { greet, chooseType, chooseParticipants, review }

class _MeetingFlowEntryState extends State<MeetingFlowEntry> {
  _FlowStep current = _FlowStep.greet;
  String? selectedType; // e.g., 'chat', 'call', 'meet'
  final Set<String> participantIds = <String>{};

  @override
  void initState() {
    super.initState();
    if (widget.skipSetup) {
      current = _FlowStep.chooseType;
    }
  }

  void _next() {
    setState(() {
      switch (current) {
        case _FlowStep.greet:
          current = _FlowStep.chooseType;
          break;
        case _FlowStep.chooseType:
          current = _FlowStep.chooseParticipants;
          break;
        case _FlowStep.chooseParticipants:
          current = _FlowStep.review;
          break;
        case _FlowStep.review:
          // In the real app, submit the meeting model here.
          break;
      }
    });
  }

  void _back() {
    setState(() {
      switch (current) {
        case _FlowStep.greet:
          break;
        case _FlowStep.chooseType:
          current = _FlowStep.greet;
          break;
        case _FlowStep.chooseParticipants:
          current = _FlowStep.chooseType;
          break;
        case _FlowStep.review:
          current = _FlowStep.chooseParticipants;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stepWidget = switch (current) {
      _FlowStep.greet => _GreetingStep(onNext: _next),
      _FlowStep.chooseType => _ChooseTypeStep(
          selected: selectedType,
          onSelect: (v) => setState(() => selectedType = v),
          onNext: _next,
          onBack: _back,
        ),
      _FlowStep.chooseParticipants => _ChooseParticipantsStep(
          selected: participantIds,
          onToggle: (id) => setState(() {
            if (participantIds.contains(id)) {
              participantIds.remove(id);
            } else {
              participantIds.add(id);
            }
          }),
          onNext: _next,
          onBack: _back,
        ),
      _FlowStep.review => _ReviewStep(
          type: selectedType,
          participants: participantIds.toList(),
          onBack: _back,
        ),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Meeting flow')),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: stepWidget,
              ),
            ),
            if (!widget.hideLegacyBanner)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: const Color(0xFF1E40AF),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  child: const Text(
                    'FLOW ENTRY ACTIVE (MeetingFlowEntry) — vFLOW-001',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GreetingStep extends StatelessWidget {
  final VoidCallback onNext;
  const _GreetingStep({required this.onNext});

  String _greet() {
    final h = DateTime.now().hour;
    if (h < 5) return 'Good night';
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('qa_flow_greeting'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_greet(), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('What do you want to do today?',
            style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            key: const Key('qa_flow_next'),
            onPressed: onNext,
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }
}

class _ChooseTypeStep extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _ChooseTypeStep({
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final types = const [
      ('chat', Icons.chat_bubble_outline, 'Chat'),
      ('call', Icons.call_outlined, 'Call'),
      ('meet', Icons.calendar_month_outlined, 'Meet'),
    ];
    return Column(
      key: const Key('qa_flow_choose_type'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose a type', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (id, icon, label) in types)
              ChoiceChip(
                key: Key('qa_choose_type_$id'),
                avatar: Icon(icon),
                label: Text(label),
                selected: selected == id,
                onSelected: (_) => onSelect(id),
              ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              key: const Key('qa_flow_back'),
              onPressed: onBack,
              child: const Text('Back'),
            ),
            FilledButton(
              key: const Key('qa_flow_next'),
              onPressed: selected == null ? null : onNext,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChooseParticipantsStep extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _ChooseParticipantsStep({
    required this.selected,
    required this.onToggle,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final people = const [
      ('u_alex', 'Alex'),
      ('u_bailey', 'Bailey'),
      ('u_charlie', 'Charlie'),
    ];
    return Column(
      key: const Key('qa_flow_choose_participants'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('With whom?', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...people.map((p) {
          final (id, name) = p;
          final isSel = selected.contains(id);
          return ListTile(
            key: Key('qa_choose_person_$id'),
            leading: CircleAvatar(child: Text(name[0])),
            title: Text(name),
            trailing: isSel ? const Icon(Icons.check) : null,
            onTap: () => onToggle(id),
          );
        }),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              key: const Key('qa_flow_back'),
              onPressed: onBack,
              child: const Text('Back'),
            ),
            FilledButton(
              key: const Key('qa_flow_next'),
              onPressed: selected.isEmpty ? null : onNext,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final String? type;
  final List<String> participants;
  final VoidCallback onBack;
  const _ReviewStep({
    required this.type,
    required this.participants,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('qa_flow_review'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text('Type: ${type ?? '-'}'),
        const SizedBox(height: 8),
        Text('Participants: ${participants.join(', ')}'),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              key: const Key('qa_flow_back'),
              onPressed: onBack,
              child: const Text('Back'),
            ),
            FilledButton(
              key: const Key('qa_flow_submit'),
              onPressed: () {
                // Submit placeholder
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meeting submitted')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ],
    );
  }
}
