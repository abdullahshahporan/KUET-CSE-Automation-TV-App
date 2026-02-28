import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/tv_theme.dart';

/// A horizontal scrolling ticker that cycles through urgent announcements.
class AnnouncementTicker extends StatefulWidget {
  final List<Announcement> announcements;

  const AnnouncementTicker({super.key, required this.announcements});

  @override
  State<AnnouncementTicker> createState() => _AnnouncementTickerState();
}

class _AnnouncementTickerState extends State<AnnouncementTicker> {
  late final ScrollController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      final current = _controller.offset;
      if (current >= max) {
        _controller.jumpTo(0);
      } else {
        _controller.jumpTo(current + 1);
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
      height: 44,
      decoration: BoxDecoration(
        color: TVTheme.accent.withValues(alpha: 0.12),
        border: Border(
          top: BorderSide(color: TVTheme.accent.withValues(alpha: 0.3)),
          bottom: BorderSide(color: TVTheme.accent.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: TVTheme.accent,
            alignment: Alignment.center,
            child: const Row(
              children: [
                Icon(Icons.campaign, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'URGENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.announcements.length * 3, // repeat for loop
              itemBuilder: (_, index) {
                final item = widget.announcements[index % widget.announcements.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Center(
                    child: Text(
                      '${item.title}  •  ${item.content}',
                      style: const TextStyle(
                        color: TVTheme.textPrimary,
                        fontSize: 14,
                      ),
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
}
