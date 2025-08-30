import 'package:flutter/material.dart';

import '../flows/flow_engine.dart';
import '../flows/persist.dart';

class ConversationalShell extends StatefulWidget {
  final FlowEngine engine;
  final TextDirection textDirection;
  const ConversationalShell(
      {super.key,
      required this.engine,
      this.textDirection = TextDirection.ltr});

  @override
  State<ConversationalShell> createState() => _ConversationalShellState();
}

class _ConversationalShellState extends State<ConversationalShell> {
  final ctrl = TextEditingController();
  final focus = FocusNode();
  final List<_Bubble> bubbles = [];

  @override
  void initState() {
    super.initState();
    _addPrompt();
    // Try restore
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final restored = await FlowPersist.restore(widget.engine);
      if (restored && bubbles.isEmpty) _addPrompt();
    });
    widget.engine.addListener(() {
      // auto-save whenever step changes or slots update
      FlowPersist.save(widget.engine);
      setState(() {});
    });
  }

  void _addPrompt() {
    bubbles.add(_Bubble(text: widget.engine.current.prompt, fromApp: true));
  }

  Future<bool> _adGateIfNeeded() async {
    // demo logic: gate only on confirm
    if (widget.engine.current.key != 'confirm') return true;
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Sponsored break'),
        content: const Text('Watch a short promo to continue.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(_, false),
              child: const Text('Skip')),
          FilledButton(
              onPressed: () => Navigator.pop(_, true),
              child: const Text('Watch')),
        ],
      ),
    );
    // Simulate 1.5s "ad"
    if (ok == true) await Future.delayed(const Duration(milliseconds: 1500));
    return ok == true;
  }

  void _onContinue() async {
    final input = ctrl.text.trim();
    final step = widget.engine.current;
    final err = step.validator?.call(input);
    if (!widget.engine.isLast && (err != null)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    if (input.isNotEmpty) bubbles.add(_Bubble(text: input, fromApp: false));
    ctrl.clear();

    // ⛔ ad gate before confirming
    if (widget.engine.isLast) {
      final ok = await _adGateIfNeeded();
      if (!ok) return;
    }

    if (!widget.engine.next(input.isEmpty ? null : input)) {
      // reached confirm - show summary card
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Review')),
          body: SummaryCard(slots: widget.engine.slots),
        ),
      ));
    } else {
      _addPrompt();
    }
    focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bubbles.length,
              itemBuilder: (c, i) {
                final b = bubbles[i];
                final align =
                    b.fromApp ? Alignment.centerLeft : Alignment.centerRight;
                final bg = b.fromApp
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.primaryContainer;
                final fg = b.fromApp
                    ? null
                    : Theme.of(context).colorScheme.onPrimaryContainer;
                return Align(
                  alignment: align,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(b.text, style: TextStyle(color: fg)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    focusNode: focus,
                    decoration:
                        const InputDecoration(hintText: 'Type your answer...'),
                    onSubmitted: (_) => _onContinue(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                    onPressed: _onContinue, child: const Text('Continue')),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: widget.engine.back,
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble {
  final String text;
  final bool fromApp;
  _Bubble({required this.text, required this.fromApp});
}

class SummaryCard extends StatelessWidget {
  final Map<String, String> slots;
  const SummaryCard({super.key, required this.slots});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...slots.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 90,
                          child: Text('${e.key}:',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600))),
                      Expanded(child: Text(e.value)),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close')),
                const SizedBox(width: 8),
                FilledButton(onPressed: () {}, child: const Text('Continue')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
