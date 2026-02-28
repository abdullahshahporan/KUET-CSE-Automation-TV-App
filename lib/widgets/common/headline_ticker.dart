import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/tv_theme.dart';

/// Professional TV-style bottom headline ticker — continuous scroll like CNN/BBC.
class HeadlineTicker extends StatefulWidget {
  final List<Announcement> announcements;

  const HeadlineTicker({super.key, required this.announcements});

  @override
  State<HeadlineTicker> createState() => _HeadlineTickerState();
}

class _HeadlineTickerState extends State<HeadlineTicker> {
  late final ScrollController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      final current = _controller.offset;
      if (current >= max) {
        _controller.jumpTo(0);
      } else {
        _controller.jumpTo(current + 1.2);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.announcements.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: TVTheme.tickerBg,
        border: Border(
          top: BorderSide(color: TVTheme.accent, width: 2),
        ),
      ),
      child: Row(
        children: [
          // ── "HEADLINES" label ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [TVTheme.accent, TVTheme.accentLight],
              ),
            ),
            alignment: Alignment.center,
            child: const Row(
              children: [
                Icon(Icons.fiber_manual_record, color: Colors.white, size: 10),
                SizedBox(width: 8),
                Text(
                  'HEADLINES',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          // ── Scrolling headlines ──
          Expanded(
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.announcements.length * 5,
              itemBuilder: (_, index) {
                final item =
                    widget.announcements[index % widget.announcements.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Priority dot
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _priorityColor(item.priority),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _priorityColor(item.priority)
                                    .withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.content,
                          style: TextStyle(
                            color: TVTheme.textSecondary.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 24),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: TVTheme.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.high:
        return TVTheme.priorityHigh;
      case Priority.medium:
        return TVTheme.priorityMedium;
      case Priority.low:
        return TVTheme.priorityLow;
    }
  }
}
